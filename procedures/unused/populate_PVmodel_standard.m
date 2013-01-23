function [Q,R,P,G,D,U,bufsize,chireject,chisuspect,chiPRbuffersize,chiBEbuffersize,chiPRratio,chiBEratio,modeltype,R0,Rstep] = populate_PVmodel_standard(m,dT,Qscale,bufsize,chireject,chisuspect,chiPRbuffersize,chiBEbuffersize,chiPRratio,chiBEratio,modeltype,R0,Rstep)
% Q = [eye(3)*(dT^3/3) eye(3)*(dT^2/2);eye(3)*(dT^2/2) eye(3)*dT];
% G = chol(Q); % PVQ=G*Q*G' where Q is diagonal, holds covariances, and G is distribution
Q = eye(6)*Qscale;
Gtemp = sqrt(dT);
G1 = sqrt(3)/3*Gtemp*dT;
G2 = sqrt(3)/2*Gtemp;
G3 = 1/2*Gtemp;
G = [eye(3)*G1 eye(3)*G2;zeros(3,3) eye(3)*G3];

R = ones(m,1)'*8;
P = eye(6)*3*Qscale;
D = ones(6,1)';  %THIS AND PVU ARE ONLY FOR PVP = eye(6)*3!
U = diag(ones(6,1)*sqrt(3*Qscale));



% G matrix computed originally as two commented lines, optimized for our case by maple:
% with(linalg);
% S := matrix(6,6, [dt^3/3,0,0,dt^2/2,0,0,0,dt^3/3,0,0,dt^2/2,0,0,0,dt^3/3,0,0,dt^2/2,dt^2/2,0,0,dt,0,0,0,dt^2/2,0,0,dt,0,0,0,dt^2/2,0,0,dt]);
% cholesky(S);