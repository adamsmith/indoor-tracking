function [x,P] = Kalman(x,z,P,Q,R,H,c,m)
Pk_est=squeeze(P)+squeeze(Q);
Kbar=Pk_est*(H')*inv(H*Pk_est*(H')+diag(R));
x=x'+Kbar*(z'-h(x,c,m));
x=x';
P=(eye(3)-Kbar*H)*Pk_est;