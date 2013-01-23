function [x,U,D] = min_thornton2(xin,Phi,Uin,Din,Gin,Q)
dT=.2;
Qscale=14.3301;
x = xin;
x(1) = x(1)+x(4)*dT;
x(2) = x(2)+x(5)*dT;
x(3) = x(3)+x(6)*dT;

G     = Gin;       % move to internal array for destructive updates
U     = eye(6);    % initialize lower triangular part of U

PhiU = Uin;   % rows of [PhiU,G] are to be orthononalized
PhiU(1,4) = PhiU(1,4) + dT*PhiU(4,4);
PhiU(1,5) = PhiU(1,5) + dT*PhiU(4,5);
PhiU(1,6) = PhiU(1,6) + dT*PhiU(4,6);
PhiU(2,5) = PhiU(2,5) + dT*PhiU(5,5);
PhiU(2,6) = PhiU(2,6) + dT*PhiU(5,6);
PhiU(3,6) = PhiU(3,6) + dT*PhiU(6,6);


for i=6:-1:1
   sigma = 0;
   for k=i:6
      sigma = sigma + PhiU(i,k)^2*Din(k,k);
      sigma = sigma + G(i,k)^2*Q(k,k);
   end
   D(i,i) = sigma;
   
   for j=1:i-1
      sigma = 0;
      for k=i:6
         sigma = sigma + PhiU(i,k)*Din(k,k)*PhiU(j,k);
         sigma = sigma + G(i,k)*Q(k,k)*G(j,k);
      end
      U(j,i) = sigma/D(i,i);
      
      for k=i:6
         PhiU(j,k) = PhiU(j,k) - U(j,i)*PhiU(i,k); % This does NOT change zero / non-zero structure of PhiU
         G(j,k) = G(j,k) - U(j,i)*G(i,k); % U(j,i) term is always non-zero by def of loop bounds
      end
   end
end