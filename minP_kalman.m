function [chisqr,f_cov]=minP_kalman(alt_point,dT,minP_point,minP_dist) %alt_point = least sq
% true input: dT, minP_point, minP_dist
% "static" input / information: x, D, U, reject_buf, suspect_buf, runcounter, per_constr_point_buffer, per_constr_dist_buffer
% output: same as "static" input (i.e. propagation of state)

global enable_hybrid hybridused min_hybrid multi_num minP_index minP_x minP_D minP_U minP_Qscale minP_reject_buf minP_suspect_buf minP_runcounter minP_PR_glob
chisqr=0; f_cov=0; % to shut up MATLAB warning about output not assigned if runcount<3

if (minP_runcounter(minP_index) <= 4)
    minP_x(minP_index,1:3) = alt_point;
elseif minP_runcounter(minP_index) > 3
	minP_R = 145.2218;
	minP_max_reject_ratio = .4;
	minP_max_suspect_ratio = .4;
	minP_reject_thresh = 10^4;
	minP_suspect_thresh = inf;
	
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
	
	
	htheo=sqrt((minP_point(1)-x_est(1))^2+(minP_point(2)-x_est(2))^2+(minP_point(3)-x_est(3))^2);
	PH=[(x_est(1)-minP_point(1))/htheo (x_est(2)-minP_point(2))/htheo (x_est(3)-minP_point(3))/htheo];
	
	% ----BEGIN OUTLIER REJECTOR / BAD STATE ESTIMATOR----
	chisqr = (minP_dist - htheo)^2;%  / C_est;  if uncommenting this adjust f_cov definition below
	rejectcnt = 0;
	suspectcnt = 0;
	ignore_outlier_rejection = 0;
	badest = 0;
	minP_exit = 0;
	for k=1:19
        minP_reject_buf(minP_index,k) = minP_reject_buf(minP_index,k+1);
        minP_suspect_buf(minP_index,k) = minP_suspect_buf(minP_index,k+1);
	end
	if chisqr > minP_reject_thresh % Record chisqr value, must do this before next loop
        minP_reject_buf(minP_index,20) = 1;
        minP_suspect_buf(minP_index,20) = 0; % We don't want to count an outlier as suspicious
	else
        minP_reject_buf(minP_index,20) = 0;
        if chisqr > minP_suspect_thresh
            minP_suspect_buf(minP_index,20) = 1;
		else
            minP_suspect_buf(minP_index,20) = 0;
		end
	end
	for k=1:20
        if minP_reject_buf(minP_index,k) == 1
            rejectcnt = rejectcnt + 1;
        end
        if minP_suspect_buf(minP_index,k) == 1
            suspectcnt = suspectcnt + 1;
        end
	end
	if (rejectcnt / 20) >= minP_max_reject_ratio
        ignore_outlier_rejection = 1;
%         disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Ignoring outlier rejection']);
	end
	if (suspectcnt / 20) >= minP_max_suspect_ratio
        badest = 1;
	end
	if (minP_reject_buf(minP_index,20) == 1) & (minP_runcounter(minP_index) > 20) %throw away sample
        if (ignore_outlier_rejection == 0)
            disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Throwing out sample, ignoring bad state indicator (' num2str(badest) ')']);
            x_est = minP_x(minP_index,:);
            D_est = minP_D(minP_index,:)';
			U_est = minP_U(minP_index,:,:);
            minP_exit = 1;
        else
%             disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Would throw out sample, but not going to since ignoring; setting badest flag']);
            badest = 1;
        end
	end
    if hybridused == 1 & minP_exit == 0
        % note that we don't look at enable_hybrid here.  We do not allow the P model to perform an active mobile chirp in hybrid mode since it will get into
        % bad state during large turns, etc.  We simply use the active mobile data if it's available (that is, if the PV model went into bad state)
        
        % we have more data, use it regardless of badest
        disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': PV in bad state, P-model using extra data']);
        % ----BEGIN CORRECTOR----
        for k=1:size(min_hybrid,1)
            %minP_hybrid is mx4, where m is # of dist's and columns are [dist,beacon x,y,z]
            htheo=sqrt((min_hybrid(k,2)-x_est(1))^2+(min_hybrid(k,3)-x_est(2))^2+(min_hybrid(k,4)-x_est(3))^2);
			PH=[(x_est(1)-min_hybrid(k,2))/htheo (x_est(2)-min_hybrid(k,3))/htheo (x_est(3)-min_hybrid(k,4))/htheo];
            C_est = 0;
			[x_est,U_est,D_est,C_est]=minP_bierman(min_hybrid(k,1),htheo,minP_R,PH,x_est,U_est,D_est);
            D_est = diag(D_est); % convert back to "compressed" form
        end
        % ----END CORRECTOR----	
        %clear chibuffer
        for k=1:20
            minP_reject_buf(minP_index,k) = 0;
            minP_suspect_buf(minP_index,k) = 0;
        end
        minP_exit = 1; %let the PV model take over for now
    elseif (badest > 0)
        % we're in a bad state -> reset
        
        disp([num2str(minP_runcounter(minP_index)) '/' num2str(minP_index) ': Bad state detected, not in hybrid mode so using NLLS under (false) simultaneity assumption']);
        x_est(1) = alt_point(1); x_est(2) = alt_point(2); x_est(3) = alt_point(3);
        D_est = ones(3,1);
		U_est = diag(ones(3,1)*3.5567);
        
        %clear chibuffer
        for k=1:20
            minP_reject_buf(minP_index,k) = 0;
            minP_suspect_buf(minP_index,k) = 0;
        end
        
        chisqr=6; %high confidence in our estimate
        minP_exit = 1; % let PV model take over
	% ----END OUTLIER REJECTOR / BAD STATE ESTIMATOR----
    elseif badest == 0 & minP_exit == 0 %normal
        % ----BEGIN CORRECTOR----
        C_est = 0;
		[x_est,U_est,D_est,C_est]=minP_bierman(minP_dist,htheo,minP_R,PH,x_est,U_est,D_est); % note: not minP_bierman!!
        D_est = diag(D_est); % convert back to "compressed" form
        % ----END CORRECTOR----	
	end
	
    %in efficient implementation we would do correction here iff minP_exit=0
    minP_x(minP_index,:)=x_est;
    minP_U(minP_index,:,:)=U_est;
    minP_D(minP_index,:)=D_est';
    
    if minP_exit == 0
        %otherwise f_cov will remain zero
        f_cov = exp(-0.5*chisqr/C_est)/((2*pi*C_est)^(multi_num/2));
    end
end