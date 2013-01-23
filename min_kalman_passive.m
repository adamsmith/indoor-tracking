function [chisqr,f_cov]=min_kalman_passive(alt_point,dT,min_points,min_dists) %alt_point = least sq
% true input: dT, min_point, min_dist
% "static" input / information: x, D, U, min_runcounter
% output: same as "static" input (i.e. propagation of state), chisqr value for logging only, and f_cov for multimodal filtering

global multi_num min_index min_x min_D min_U min_Qscale min_reject_buf min_runcounter min_PR_glob
chisqr=0; f_cov=0; % to suppress MATLAB warning about output not assigned if runcount<=4

if (min_runcounter(min_index) <= 4)
    min_x(min_index,1:3) = alt_point;
    min_x(min_index,4) = 0;
    min_x(min_index,5) = 0;
    min_x(min_index,6) = 0;
elseif min_runcounter(min_index) > 3
	min_R = 145.2218;
	min_reject_thresh = 10^2;%min_PR_glob(min_index);
	% min_suspect_thresh = inf;  % There is no notion of suspect in an active mobile chirp
	
% 	if min_runcounter(min_index)>=172
% 	    profile on -detail operator -history
% 	end
	
	% ----BEGIN G-MATRIX CALCULATOR----
	sqrt3 = 1.732050808;
	Gtemp = sqrt(dT);
	G1 = sqrt3/3*Gtemp*dT;
	G2 = sqrt3/2*Gtemp;
	G3 = 1/2*Gtemp;
	min_G = [eye(3)*G1 eye(3)*G2;zeros(3,3) eye(3)*G3];
	% ----END G-MATRIX CALCULATOR----
	
	% ----BEGIN STATE PREDICTOR----
	x_est = zeros(1,6);
	x_est(1) = min_x(min_index,1)+min_x(min_index,4)*dT;
	x_est(2) = min_x(min_index,2)+min_x(min_index,5)*dT;
	x_est(3) = min_x(min_index,3)+min_x(min_index,6)*dT;
	x_est(4) = min_x(min_index,4);
	x_est(5) = min_x(min_index,5);
	x_est(6) = min_x(min_index,6);
	% ----END STATE PREDICTOR----
    
	% ----BEGIN COVAR PREDICTOR----
		myG       = min_G;       % move to INTERNAL array for destructive updates
		U_est     = eye(6);    % initialize lower triangular part of U; we will build this up and then output it
		D_est     = zeros(1,6);
		PhiU      = squeeze(min_U(min_index,:,:));   % rows of [PhiU,G] are to be orthononalized
		PhiU(1,4) = PhiU(1,4) + dT*PhiU(4,4);
		PhiU(1,5) = PhiU(1,5) + dT*PhiU(4,5);
		PhiU(1,6) = PhiU(1,6) + dT*PhiU(4,6);
		PhiU(2,5) = PhiU(2,5) + dT*PhiU(5,5);
		PhiU(2,6) = PhiU(2,6) + dT*PhiU(5,6);
		PhiU(3,6) = PhiU(3,6) + dT*PhiU(6,6);
		
		for ivar=6:-1:1
           sigma = 0;
           for k=ivar:6
              sigma = sigma + PhiU(ivar,k)^2*min_D(min_index,k);
              sigma = sigma + myG(ivar,k)^2*min_Qscale(min_index);
           end
           D_est(ivar) = sigma;
           
           for j=1:ivar-1
              sigma = 0;
              for k=ivar:6
                 sigma = sigma + PhiU(ivar,k)*min_D(min_index,k)*PhiU(j,k);
                 sigma = sigma + myG(ivar,k)*min_Qscale(min_index)*myG(j,k);
              end
              U_est(j,ivar) = sigma/D_est(ivar);
              
              for k=ivar:6
                 PhiU(j,k) = PhiU(j,k) - min_U(min_index,j,ivar)*PhiU(ivar,k); % This does NOT change zero / non-zero structure of PhiU
                 myG(j,k) = min_G(j,k) - min_U(min_index,j,ivar)*myG(ivar,k); % U(j,i) term is always non-zero by def of loop bounds
              end
           end
		end
	% ----END COVAR PREDICTOR----
	
    % Initialize variables
    chisqr = zeros(size(min_points,1),1);
    PVH = zeros(size(min_points,1),6);
    
    for j=1:size(min_points,1)
        %load up the j-th measurement
        min_point = min_points(j,:);
        min_dist = min_dists(j);
        
		htheo=sqrt((min_point(1)-x_est(1))^2+(min_point(2)-x_est(2))^2+(min_point(3)-x_est(3))^2);
		PVH(j,:)=[(x_est(1)-min_point(1))/htheo (x_est(2)-min_point(2))/htheo (x_est(3)-min_point(3))/htheo 0 0 0];
		
		chisqr(j) = (min_dist - htheo)^2; %NOTE: chisqr(j) is computed from x_est which is updated for every estimate, only chisqr(1) is based on the "true" EKF predicted state

		if chisqr(j) > min_reject_thresh %throw away individual measurement sample (only the one from this beacon)
            disp([num2str(min_runcounter(min_index)) '/' num2str(min_index) ': Throwing out single sample']);
        else
            C_est = 0;
			[x_est,U_est,D_est,C_est]=min_bierman(min_dist,htheo,min_R,PVH(j,:),x_est,U_est,D_est);
            D_est = diag(D_est); % convert back to "compressed" form
		end
    end
    
	if median(chisqr) > min_reject_thresh
% IMPORTANT NOTE: The code commented out in the next few lines was a weak feature with a bug that was present when processing the experimental data
% for the first submitted copy of the paper for the MobiSys 2004 review.
%         % our bad state detection buffer is one-step long -> if the predicate above is satisfied two times in a row then we're in bad state
%         if min_reject_buf(min_index,1) == 0
%             min_reject_buf(min_index,1) = 1;
%         else
            % we're in a bad state -> reset
            % use our non-linear least squares answer (here just 'alt_point')
            disp([num2str(min_runcounter(min_index)) '/' num2str(min_index) ': Bad state detected, switching to NLLS and clearing this chibuffer']);
            x_est(1) = alt_point(1); x_est(2) = alt_point(2); x_est(3) = alt_point(3);
            x_est(4) = 0; x_est(5) = 0; x_est(6) = 0;
            D_est = ones(6,1);
			U_est = diag(ones(6,1)*6.5567);
%             min_reject_buf(min_index,1) = 0;
% 		end
        min_exit = 1;
    else
        min_exit = 0;
	end
    
    
    
    min_x(min_index,:)=x_est;
    min_U(min_index,:,:)=U_est;
    if size(min_D(min_index,:),1) ~= size(D_est',1)
        %we're messed up because we didn't hit the bierman filter right or something, quick fix:
        D_est = D_est'; %this is just a MATLAB representation problem
    end
    min_D(min_index,:)=D_est';
    if min_exit == 0
        % if we're in bad state then f_cov will remain zero
        f_cov = exp(-0.5*(chisqr.^.5)'*inv(C_est)*(chisqr.^.5))/((2*pi*C_est)^(multi_num/2));
    end
    
    % for logging purposes only
    chisqr = chisqr(1); %for now only return one of the chisqr values
end