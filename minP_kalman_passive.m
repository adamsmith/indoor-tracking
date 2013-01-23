function [chisqr,f_cov]=minP_kalman_passive(alt_point,dT,minP_points,minP_dists) %alt_point = least sq
% true input: dT, minP_point, minP_dist
% "static" input / information: x, D, U, reject_buf, suspect_buf, runcounter, per_constr_point_buffer, per_constr_dist_buffer
% output: same as "static" input (i.e. propagation of state)

global multi_num minP_index minP_x minP_D minP_U minP_Qscale minP_reject_buf minP_suspect_buf minP_runcounter minP_PR_glob
chisqr=0; f_cov=0; % to shut up MATLAB warning about output not assigned if runcount<3

if (minP_runcounter(minP_index) <= 4)
    minP_x(minP_index,1:3) = alt_point;
elseif minP_runcounter(minP_index) > 3
	minP_R = 145.2218;
	minP_reject_thresh = 10^3;%minP_PR_glob(minP_index);
	% min_suspect_thresh = inf;  % There is no notion of suspect in an active mobile chirp
	
	% ----BEGIN G-MATRIX CALCULATOR----
	minP_G = eye(3)*minP_Qscale(minP_index);
	% ----END G-MATRIX CALCULATOR----
    
	% ----BEGIN G-MATRIX CALCULATOR----
	sqrt3 = 1.732050808;
	Gtemp = sqrt(dT);
	minP_G = eye(3)*sqrt3/3*Gtemp*dT;
	% ----END G-MATRIX CALCULATOR----
	
	% ----BEGIN STATE PREDICTOR----
    x_est = minP_x(minP_index,1:3);
	% ----END STATE PREDICTOR----
    
	% ----BEGIN COVAR PREDICTOR----
%     [x_est,U_est,D_est] = thornton(x_est',eye(3),squeeze(minP_U(minP_index,:,:)),diag(minP_D(minP_index,:)),minP_G,minP_G);
	myG       = minP_G;       % move to INTERNAL array for destructive updates
	U_est     = eye(3);    % initialize lower triangular part of U; we will build this up and then output it
	D_est     = zeros(1,3);
	PhiU      = squeeze(minP_U(minP_index,:,:));   % rows of [PhiU,G] are to be orthononalized
	
	for ivar=3:-1:1
       sigma = 0;
       for k=ivar:3
          sigma = sigma + PhiU(ivar,k)^2*minP_D(minP_index,k);
          sigma = sigma + myG(ivar,k)^2*minP_Qscale(minP_index);
       end
       D_est(ivar) = sigma;
       
       for j=1:ivar-1
          sigma = 0;
          for k=ivar:3
             sigma = sigma + PhiU(ivar,k)*minP_D(minP_index,k)*PhiU(j,k);
             sigma = sigma + myG(ivar,k)*minP_Qscale(minP_index)*myG(j,k);
          end
          U_est(j,ivar) = sigma/D_est(ivar);
          
          for k=ivar:3
             PhiU(j,k) = PhiU(j,k) - minP_U(minP_index,j,ivar)*PhiU(ivar,k); % This does NOT change zero / non-zero structure of PhiU
             myG(j,k) = minP_G(j,k) - minP_U(minP_index,j,ivar)*myG(ivar,k); % U(j,i) term is always non-zero by def of loop bounds
          end
       end
	end
% 	----END COVAR PREDICTOR----
	
	chisqr = zeros(size(minP_points,1),1);
    PH = zeros(size(minP_points,1),3);
    for j=1:size(minP_points,1)
        %load up this fix
        minP_point = minP_points(j,:);
        minP_dist = minP_dists(j);
        
		htheo=sqrt((minP_point(1)-x_est(1))^2+(minP_point(2)-x_est(2))^2+(minP_point(3)-x_est(3))^2);
		PH(j,:)=[(x_est(1)-minP_point(1))/htheo (x_est(2)-minP_point(2))/htheo (x_est(3)-minP_point(3))/htheo];
		
		% ----BEGIN OUTLIER REJECTOR----
		chisqr(j) = (minP_dist - htheo)^2;%  / C_est;  if uncommenting this adjust f_cov definition below
		minP_exit = 0;
		if chisqr(j) > minP_reject_thresh %throw away sample
            disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Throwing out single sample']);
            minP_exit = 1;
		end
		% ----END OUTLIER REJECTOR----
        
        % ----BEGIN CORRECTOR----
        if minP_exit == 0
            C_est = 0;
			[x_est,U_est,D_est,C_est]=minP_bierman(minP_dist,htheo,minP_R,PH(j,:),x_est,U_est,D_est); % note: not minP_bierman!!
            D_est = diag(D_est); % convert back to "compressed" form
        end
        % ----END CORRECTOR----	
    end
    
	if median(chisqr) > minP_reject_thresh
% IMPORTANT NOTE: The code commented out in the next few lines was a weak feature with a bug that was present when processing the experimental data
% for the first submitted copy of the paper for the MobiSys 2004 review.
%         % our bad state detection buffer is one-step long -> if the predicate above is satisfied two times in a row then we're in bad state
%         if minP_reject_buf(minP_index,1) == 0
%             minP_reject_buf(minP_index,1) = 1;
%         else
            % we're in a bad state -> reset
            % use our non-linear least squares answer (here just 'alt_point')
            disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Bad state detected, switching to NLLS and clearing this chibuffer']);
            x_est(1) = alt_point(1); x_est(2) = alt_point(2); x_est(3) = alt_point(3);
            D_est = ones(3,1);
			U_est = diag(ones(3,1)*6.5567);
%             minP_reject_buf(minP_index,1) = 0;
% 		end
        minP_exit = 1;
    else
        minP_exit = 0;
	end
    
    %in efficient implementation we would do correction here iff minP_exit=0
    minP_x(minP_index,:)=x_est;
    minP_U(minP_index,:,:)=U_est;
    if size(minP_D(minP_index,:),1) ~= size(D_est',1)
        a=1; %we're messed up because we didn't hit the bierman filter right or something, quick fix:
        D_est = D_est';
    end
    minP_D(minP_index,:)=D_est';
    
    if minP_exit == 0
        %otherwise f_cov will remain zero
        f_cov = exp(-0.5*(chisqr.^.5)'*inv(C_est)*(chisqr.^.5))/((2*pi*C_est)^(multi_num/2));
    end
    
    minP_chisqr_hist = chisqr(:); %for now only return one of the chisqr values
    chisqr = chisqr(1);
end