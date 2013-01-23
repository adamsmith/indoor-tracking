function [chisqr,f_cov]=min_kalman(alt_point,dT,min_point,min_dist) %alt_point = least sq
% true input: dT, min_point, min_dist
% "static" input / information: x, D, U, reject_buf, suspect_buf, runcounter, per_constr_point_buffer, per_constr_dist_buffer
% output: same as "static" input (i.e. propagation of state), chisqr value for logging only, and f_cov for multimodal filtering

global enable_hybrid hybridused min_hybrid multi_num min_index min_x min_D min_U min_Qscale min_reject_buf min_suspect_buf min_runcounter min_PR_glob
chisqr=0; f_cov=0; hybridused=0; % to shut up MATLAB warning about output not assigned if runcount <= 4

if (min_runcounter(min_index) <= 4)
    min_x(min_index,1:3) = alt_point;
    min_x(min_index,4) = 0;
    min_x(min_index,5) = 0;
    min_x(min_index,6) = 0;
else
	min_R = 145.2218;
        
	min_max_reject_ratio = .4;
	min_max_suspect_ratio = .2;
	min_reject_thresh = 10^4;
	min_suspect_thresh = inf;
    
    if enable_hybrid > 0
		min_max_reject_ratio = .3;
		min_max_suspect_ratio = .1;
		min_reject_thresh = 10^4;
		min_suspect_thresh = 10^3;
    end
	
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
	
	
	htheo=sqrt((min_point(1)-x_est(1))^2+(min_point(2)-x_est(2))^2+(min_point(3)-x_est(3))^2);
	PVH=[(x_est(1)-min_point(1))/htheo (x_est(2)-min_point(2))/htheo (x_est(3)-min_point(3))/htheo 0 0 0];
	
	% ----BEGIN OUTLIER REJECTOR / BAD STATE ESTIMATOR----
	chisqr = (min_dist - htheo)^2;
	rejectcnt = 0;
	suspectcnt = 0;
	ignore_outlier_rejection = 0;
	badest = 0;
	min_exit = 0;
	for k=1:19
        min_reject_buf(min_index,k) = min_reject_buf(min_index,k+1);
        min_suspect_buf(min_index,k) = min_suspect_buf(min_index,k+1);
	end
	if chisqr > min_reject_thresh % Record chisqr value, must do this before next loop
        min_reject_buf(min_index,20) = 1;
        min_suspect_buf(min_index,20) = 0; % We don't want to count an outlier as suspicious
	else
        min_reject_buf(min_index,20) = 0;
        if chisqr > min_suspect_thresh
            min_suspect_buf(min_index,20) = 1;
		else
            min_suspect_buf(min_index,20) = 0;
		end
	end
	for k=1:20
        if min_reject_buf(min_index,k) == 1
            rejectcnt = rejectcnt + 1;
        end
        if min_suspect_buf(min_index,k) == 1
            suspectcnt = suspectcnt + 1;
        end
	end
	if (rejectcnt / 20) >= min_max_reject_ratio
        ignore_outlier_rejection = 1;
	end

	if (min_reject_buf(min_index,20) == 1) & (min_runcounter(min_index) > 20) %throw away sample
        if (ignore_outlier_rejection == 0)
            disp([num2str(min_runcounter(min_index)) '/' num2str(min_index) ': Throwing out sample, ignoring bad state indicator (' num2str(badest) ')']);
            x_est = min_x(min_index,:);
            D_est = min_D(min_index,:)';
			U_est = min_U(min_index,:,:);
            min_exit = 1;
        else
            % Would throw out sample, but not going to since we're in bad state
            badest = 1;
        end
    elseif (suspectcnt / 20) >= min_max_suspect_ratio
        badest = 2;
	end
    
	if (badest > 0)
        if enable_hybrid > 0
            disp([num2str(min_runcounter(min_index)) '/' num2str(min_index) ': Bad state detected, in hybrid mode so using active mobile information']);
            hybridused = 1;
            % Now run corrector on each sample
            % Note that we can't do chi-squared outlier rejection here since our x_est is "bad"
            % ----BEGIN CORRECTOR----
            for k=1:size(min_hybrid,1)
                %min_hybrid is mx4, where m is # of dist's and columns are [dist,beacon x,y,z]
                htheo=sqrt((min_hybrid(k,2)-x_est(1))^2+(min_hybrid(k,3)-x_est(2))^2+(min_hybrid(k,4)-x_est(3))^2);
				PVH=[(x_est(1)-min_hybrid(k,2))/htheo (x_est(2)-min_hybrid(k,3))/htheo (x_est(3)-min_hybrid(k,4))/htheo 0 0 0];
                C_est = 0;
				[x_est,U_est,D_est,C_est]=min_bierman(min_hybrid(k,1),htheo,min_R,PVH,x_est,U_est,D_est);
                D_est = diag(D_est); % convert back to "compressed" form
            end
            % ----END CORRECTOR----
            chisqr=6; %high confidence in our estimate
        else
            disp([num2str(min_runcounter(min_index)) '/' num2str(min_index) ': Bad state detected (' num2str(badest) '), not in hybrid mode so using NLLS under (false) simultaneity assumption']);
            
            % we're in a bad state -> reset without hybrid information

            x_est(1) = alt_point(1); x_est(2) = alt_point(2); x_est(3) = alt_point(3); % alt_point is our NLLS estimate using the simultaneity assumption
            x_est(4) = 0; x_est(5) = 0; x_est(6) = 0;
            D_est = ones(6,1);
			U_est = diag(ones(6,1)*6.5567);
            min_exit = 1;
        end
        %clear chibuffer
        for k=1:20
            min_reject_buf(min_index,k) = 0;
            min_suspect_buf(min_index,k) = 0;
        end
	% ----END OUTLIER REJECTOR / BAD STATE ESTIMATOR----
    elseif min_exit == 0
        % ----BEGIN CORRECTOR----
        C_est = 0;
		[x_est,U_est,D_est,C_est]=min_bierman(min_dist,htheo,min_R,PVH,x_est,U_est,D_est);
        D_est = diag(D_est); % convert back to "compressed" diagonal form
        % ----END CORRECTOR----	
	end
	
    
    min_x(min_index,:)=x_est;
    min_U(min_index,:,:)=U_est;
    min_D(min_index,:)=D_est';
    
    if min_exit == 0 % i.e. we're not in a bad state and we didn't reject this sample
        %otherwise f_cov will remain zero
        f_cov = exp(-0.5*chisqr/C_est)/((2*pi*C_est)^(multi_num/2));
    end
end