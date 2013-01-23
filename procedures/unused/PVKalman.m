function [PVx,PVP,stab] = PVKalman(PVx,PVz,PVP,PVQ,PVR,PVH,c,m,dT,PVzr)
F=[0,0,0,dT,0,0;0,0,0,0,dT,0;0,0,0,0,0,dT;0,0,0,0,0,0;0,0,0,0,0,0;0,0,0,0,0,0];
x_est=(eye(6)+F)*PVx;
% UNSTABLE!
% for i=1:m %note: changes in 'z' are not propagated back to p.m
%     PVz(i) = sqrt((PVz(i)^2*(c(i,1)^2+c(i,2)^2+c(i,3)^2)-2*PVz(i)*(c(i,1)*x_est(1)+c(i,2)*x_est(2)+c(i,3)*x_est(3))*PVzr(i)+PVzr(i)^2*(x_est(1)^2+x_est(2)^2+x_est(3)^2))/PVzr(i)^2);
% end
Pk_est=(eye(6)+F)*PVP*(eye(6)+F)'+PVQ;
Kbar=Pk_est*(PVH')*inv(PVH*Pk_est*(PVH')+PVR);
PVx=x_est+Kbar*(PVz-h(x_est(1:3),c,m));
PVP=(eye(6)-Kbar*PVH)*Pk_est;

stab=max(abs(eig((eye(6)+F)-Kbar*PVH*(eye(6)+F)))); % > 1 means filter is unstable