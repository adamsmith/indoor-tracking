function [sys,x0,str,ts] = simu_min_kalman(t,x,u,flag)
global min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer
%SFUNTMPL General M-file S-function template
%   With M-file S-functions, you can define you own ordinary differential
%   equations (ODEs), discrete system equations, and/or just about
%   any type of algorithm to be used within a Simulink block diagram.
%
%   The general form of an M-File S-function syntax is:
%       [SYS,X0,STR,TS] = SFUNC(T,X,U,FLAG,P1,...,Pn)
%
%   What is returned by SFUNC at a given point in time, T, depends on the
%   value of the FLAG, the current state vector, X, and the current
%   input vector, U.
%
%   FLAG   RESULT             DESCRIPTION
%   -----  ------             --------------------------------------------
%   0      [SIZES,X0,STR,TS]  Initialization, return system sizes in SYS,
%                             initial state in X0, state ordering strings
%                             in STR, and sample times in TS.
%   1      DX                 Return continuous state derivatives in SYS.
%   2      DS                 Update discrete states SYS = X(n+1)
%   3      Y                  Return outputs in SYS.
%   4      TNEXT              Return next time hit for variable step sample
%                             time in SYS.
%   5                         Reserved for future (root finding).
%   9      []                 Termination, perform any cleanup SYS=[].
%
%
%   The state vectors, X and X0 consists of continuous states followed
%   by discrete states.
%
%   Optional parameters, P1,...,Pn can be provided to the S-function and
%   used during any FLAG operation.
%
%   When SFUNC is called with FLAG = 0, the following information
%   should be returned:
%
%      SYS(1) = Number of continuous states.
%      SYS(2) = Number of discrete states.
%      SYS(3) = Number of outputs.
%      SYS(4) = Number of inputs.
%               Any of the first four elements in SYS can be specified
%               as -1 indicating that they are dynamically sized. The
%               actual length for all other flags will be equal to the
%               length of the input, U.
%      SYS(5) = Reserved for root finding. Must be zero.
%      SYS(6) = Direct feedthrough flag (1=yes, 0=no). The s-function
%               has direct feedthrough if U is used during the FLAG=3
%               call. Setting this to 0 is akin to making a promise that
%               U will not be used during FLAG=3. If you break the promise
%               then unpredictable results will occur.
%      SYS(7) = Number of sample times. This is the number of rows in TS.
%
%
%      X0     = Initial state conditions or [] if no states.
%
%      STR    = State ordering strings which is generally specified as [].
%
%      TS     = An m-by-2 matrix containing the sample time
%               (period, offset) information. Where m = number of sample
%               times. The ordering of the sample times must be:
%
%               TS = [0      0,      : Continuous sample time.
%                     0      1,      : Continuous, but fixed in minor step
%                                      sample time.
%                     PERIOD OFFSET, : Discrete sample time where
%                                      PERIOD > 0 & OFFSET < PERIOD.
%                     -2     0];     : Variable step discrete sample time
%                                      where FLAG=4 is used to get time of
%                                      next hit.
%
%               There can be more than one sample time providing
%               they are ordered such that they are monotonically
%               increasing. Only the needed sample times should be
%               specified in TS. When specifying than one
%               sample time, you must check for sample hits explicitly by
%               seeing if
%                  abs(round((T-OFFSET)/PERIOD) - (T-OFFSET)/PERIOD)
%               is within a specified tolerance, generally 1e-8. This
%               tolerance is dependent upon your model's sampling times
%               and simulation time.
%
%               You can also specify that the sample time of the S-function
%               is inherited from the driving block. For functions which
%               change during minor steps, this is done by
%               specifying SYS(7) = 1 and TS = [-1 0]. For functions which
%               are held during minor steps, this is done by specifying
%               SYS(7) = 1 and TS = [-1 1].

%   Copyright 1990-2001 The MathWorks, Inc.
%   $Revision: 1.1 $

%
% The following outlines the general structure of an S-function.
%
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes
global min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 7; % chisqr, x, y, z, vx, vy, vz
sizes.NumInputs      = 9; % dT, dist, x, y, z
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

min_kalman_init
x0  = [];

str = [];
ts  = [-1 1];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)
global min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)
global chisqr min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

dT = u(1); min_dist = u(2); min_point = [u(3);u(4);u(5)];
min_runcounter = min_runcounter + 1;
if (min_x(1) == 0) & (min_x(2) == 0) & (min_x(3) == 0)
    do_record = 1; % but not if it's a beacon we already have in our buffer
    for k=1:4
        for l=1:3
            if min_per_constr_point_buffer(k,l) == min_point(l)
                do_record = 0;
            end
        end
    end
    if do_record == 1
		for k=1:3 %rows (point)
            for l=1:3 %columns (coordinates)
                min_per_constr_point_buffer(k,l) = min_per_constr_point_buffer(k+1,l);
            end
            min_per_constr_dist_buffer(k) = min_per_constr_dist_buffer(k+1);
		end
		for k=1:3
            min_per_constr_point_buffer(4,k) = min_point(k);
		end
		min_per_constr_dist_buffer(4) = min_dist;
	end
end
if (min_x(1) == 0) & (min_x(2) == 0) & (min_x(3) == 0) & (min_per_constr_dist_buffer(1) ~= 0)
    [min_x(1) min_x(2) min_x(3)] = min_per_constr(min_per_constr_point_buffer,min_per_constr_dist_buffer);
    min_x(4) = 0;
    min_x(5) = 0;
    min_x(6) = 0;
elseif min_runcounter > 3
	%-----------BEGIN MIN_KALMAN---------------
	Qscale = 14.3301;
	min_R = 9.08;
	min_max_reject_ratio = .2;
	min_max_suspect_ratio = .6;
	min_reject_thresh = 1000;
	min_suspect_thresh = 200;
	
	if min_runcounter==172
        profile on -detail operator -history
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
	x_est(1) = min_x(1)+min_x(4)*dT;
	x_est(2) = min_x(2)+min_x(5)*dT;
	x_est(3) = min_x(3)+min_x(6)*dT;
	x_est(4) = min_x(4);
	x_est(5) = min_x(5);
	x_est(6) = min_x(6);
	% ----END STATE PREDICTOR----
	
	
	htheo=sqrt((min_point(1)-x_est(1))^2+(min_point(2)-x_est(2))^2+(min_point(3)-x_est(3))^2);
	PVH=[(x_est(1)-min_point(1))/htheo (x_est(2)-min_point(2))/htheo (x_est(3)-min_point(3))/htheo 0 0 0];
	
	
	% ----BEGIN OUTLIER REJECTOR / BAD STATE ESTIMATOR----
	chisqr = (min_dist - htheo)^2;
	rejectcnt = 0;
	suspectcnt = 0;
	ignore_outlier_rejection = 0;
	badest = 0;
	min_exit = 0;
	if chisqr > min_reject_thresh % Record chisqr value, must do this before next loop
        min_reject_buf(10) = 1;
        min_suspect_buf(10) = 0; % We don't want to count an outlier as suspicious
	else
        min_reject_buf(10) = 0;
        if chisqr > min_suspect_thresh
            min_suspect_buf(10) = 1;
		else
            min_suspect_buf(10) = 0;
		end
	end
	for k=1:10
        if min_reject_buf(k) == 1
            rejectcnt = rejectcnt + 1;
        end
        if min_suspect_buf(k) == 1
            suspectcnt = suspectcnt + 1;
        end
	end
	if (rejectcnt / 10) >= min_max_reject_ratio
        ignore_outlier_rejection = 1;
        disp([num2str(min_runcounter) '/20: Ignoring outlier rejection']);
	end
	if (suspectcnt / 10) >= min_max_suspect_ratio
        badest = 1;
	end
	if (min_reject_buf(10) == 1) & (min_runcounter > 10) %throw away sample
        if (ignore_outlier_rejection == 0)
            disp([num2str(min_runcounter) '/20: Throwing out sample, ignoring bad state indicator (' num2str(badest) ')']);
            x_est = min_x;
            D_est = min_D;
			U_est = min_U;
            min_exit = 1;
        else
            disp([num2str(min_runcounter) '/20: Would throw out sample, but not going to since ignoring']);
        end
	end
	if (badest > 0)
        % we're in a bad state -> reset
        % check to see if min_per_constr provides better estimate by comparing its residuals to last heard beacon
        % this probably doesn't work that well since the last measurement was used as a heavy input into the generating function, so
        % if it was an outlier we might still think that min_per_constr is better
        min_alt = zeros(3,1);
        [min_alt(1) min_alt(2) min_alt(3)] = min_per_constr(min_per_constr_point_buffer,min_per_constr_dist_buffer);
        min_alt_residual = (sqrt((min_alt(1)-min_point(1))^2+(min_alt(2)-min_point(2))^2+(min_alt(3)-min_point(3))^2)-min_dist)^2; %todo: look at approx this so not have to take sqrt
        if min_alt_residual < chisqr
            % min_per_constr is assumed to be better at this point
            disp([num2str(min_runcounter) '/20: Bad state detected, switching to LinLS and clearing this chibuffer']);
            x_est(1) = min_alt(1); x_est(2) = min_alt(2); x_est(3) = min_alt(3);
            x_est(4) = 0; x_est(5) = 0; x_est(6) = 0;
            D_est = ones(6,1);
			U_est = diag(ones(6,1)*6.5567);
            %clear chibuffer
            for k=1:10
                min_reject_buf(10) = 0;
                min_suspect_buf(10) = 0;
            end
            min_exit = 1;
        else
            %LinLS is assumed to be worse, but what should we do about it?  For now do nothing.  On next iteration maybe it will be better.
            disp([num2str(min_runcounter) '/20: Bad state detected, LinLS is worse -> doing nothing']);
        end
	end
	if min_exit == 0 % we should record this distance measurement for future possible use in min_per_constr
        do_record = 1; % but not if it's a beacon we already have in our buffer
        for k=1:4
            for l=1:3
                if min_per_constr_point_buffer(k,l) == min_point(l)
                    do_record = 0;
                end
            end
        end
        if do_record == 1
			for k=1:3 %rows (point)
                for l=1:3 %columns (coordinates)
                    min_per_constr_point_buffer(k,l) = min_per_constr_point_buffer(k+1,l);
                end
                min_per_constr_dist_buffer(k) = min_per_constr_dist_buffer(k+1);
			end
			for k=1:3
                min_per_constr_point_buffer(4,k) = min_point(k);
			end
			min_per_constr_dist_buffer(4) = min_dist;
		end
	end
	% ----END OUTLIER REJECTOR / BAD STATE ESTIMATOR----
	
	if min_exit == 0
		% ----BEGIN COVAR PREDICTOR----
		myG       = min_G;       % move to INTERNAL array for destructive updates
		U_est     = eye(6);    % initialize lower triangular part of U; we will build this up and then output it
		D_est     = zeros(1,6);
		PhiU      = min_U;   % rows of [PhiU,G] are to be orthononalized
		PhiU(1,4) = PhiU(1,4) + dT*PhiU(4,4);
		PhiU(1,5) = PhiU(1,5) + dT*PhiU(4,5);
		PhiU(1,6) = PhiU(1,6) + dT*PhiU(4,6);
		PhiU(2,5) = PhiU(2,5) + dT*PhiU(5,5);
		PhiU(2,6) = PhiU(2,6) + dT*PhiU(5,6);
		PhiU(3,6) = PhiU(3,6) + dT*PhiU(6,6);
		
		for ivar=6:-1:1
           sigma = 0;
           for k=ivar:6
              sigma = sigma + PhiU(ivar,k)^2*min_D(k);
              sigma = sigma + myG(ivar,k)^2*Qscale;
           end
           D_est(ivar) = sigma;
           
           for j=1:ivar-1
              sigma = 0;
              for k=ivar:6
                 sigma = sigma + PhiU(ivar,k)*min_D(k)*PhiU(j,k);
                 sigma = sigma + myG(ivar,k)*Qscale*myG(j,k);
              end
              U_est(j,ivar) = sigma/D_est(ivar);
              
              for k=ivar:6
                 PhiU(j,k) = PhiU(j,k) - min_U(j,ivar)*PhiU(ivar,k); % This does NOT change zero / non-zero structure of PhiU
                 myG(j,k) = min_G(j,k) - min_U(j,ivar)*myG(ivar,k); % U(j,i) term is always non-zero by def of loop bounds
              end
           end
		end
		% ----END COVAR PREDICTOR----
		
		
		[x_est,U_est,D_est]=min_bierman(min_dist,htheo,min_R,PVH,x_est,U_est,D_est);
        D_est = diag(D_est); % convert back to "compressed" form
        min_x=x_est';
        min_U=U_est;
        min_D=D_est;
	end
	
	% if min_runcounter==172
	%     profile report
	% end
	%-----------END MIN_KALMAN---------------
end

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
global chisqr min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

sys = [chisqr min_x']; %[];

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)
global chisqr min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

sys = 0;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)
global chisqr min_x min_D min_U min_reject_buf min_suspect_buf min_runcounter min_per_constr_point_buffer min_per_constr_dist_buffer

sys = [];

% end mdlTerminate
