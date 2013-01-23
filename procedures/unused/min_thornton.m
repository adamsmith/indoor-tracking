function [x,U,D] = min_thornton(xin,Phi,Uin,Din,Gin,Q)
% INPUTS(with dimensions)
%      xin(n,1) corrected estimate of state vector...
%      Phi(n,n) state transition matrix
%      Uin(n,n) unit upper triangular factor (U) of the modified Cholesky
%               factors (U-D factors) of the covariance matrix of
%               corrected state estimation uncertainty (P+) 
%      Din(n,n) diagonal factor (D) of the U-D factors of the covariance
%               matrix of corrected estimation uncertainty (P+)
%      Gin(n,r) process noise distribution matrix (modified, if necessary to
%               make the associated process noise covariance diagonal)
%      Q(r,r)   diagonal covariance matrix of process noise
%               in the stochastic system model
% OUTPUTS:
%      x(n,1)  predicted estimate of state vector
%      U(n,n)  unit upper triangular factor (U) of the modified Cholesky
%              factors (U-D factors) of the covariance matrix of
%              predicted state estimation uncertainty (P-) 
%      D(n,n)  diagonal factor (D) of the U-D factors of the covariance
%              matrix of predicted estimation uncertainty (P-)
%

% n=6
% r=6
dT=.2;
Qscale=14.3301;

% NEW INPUTS: dT,Qscale

% state update
x = xin;
x(1) = x(1)+x(4)*dT;
x(2) = x(2)+x(5)*dT;
x(3) = x(3)+x(6)*dT;


G     = Gin;       % move to internal array for destructive updates
U     = eye(6);    % initialize lower triangular part of U

% PhiU  = Phi*Uin;   % rows of [PhiU,G] are to be orthononalized
PhiU = [zeros(3,3),[dT,dT*Uin(4,5),dT*Uin(4,6);0,dT,dT*U(5,6);0,0,dT];zeros(3,3),zeros(3,3)]

for i=6:-1:1
    
   sigma = 0;
   
   for j=i+3:6 %if i>3 then it won't do anything => good
       sigma = sigma + PhiU(i,j)^2*Din(j,j);
   end
   
   for j=1:6
       sigma = sigma + G(i,j)^2*Qscale;
   end
   
   D(i,i) = sigma;
   
   for j=1:i-1
      sigma = 0;
      for k=i+3:6
          sigma = sigma + PhiU(i,k)*Din(k,k)*PhiU(j,k); % only significant on i==2 (j==1) or i==3 (j==1,j==2)
      end
      for k=1:6
         sigma = sigma + G(i,k)*G(j,k)*Qscale;
      end
      
      U(j,i) = sigma/D(i,i);
      
      
      % note: this won't execute if i==1 (j=1:i-1)
      % note 2: this doesn't change the zero / non-zero structure of PhiU (VERY GOOD) since it only changes things if i==2(j==1(k==5|6)) or i==3(j==1(k==6)|2(k==6))
      for k=i+3:6
          PhiU(j,k) = PhiU(j,k) - U(j,i)*PhiU(i,k);
      end
      
      % note: this won't execute if i==1 (j=1:i-1)
      % note 2: this DOES change the zero / non-zero structure of G (VERY BAD); after i=4 is iterated (remember counting down) it (the rows of interest / G(1..3,*)) 
      %         will be completely non-zero
      for k=1:6
         G(j,k) = G(j,k) - U(j,i)*G(i,k);
      end
   end
end
PhiU;