function [Q,R,P,modeltype,R0,Rstep] = populate_Pmodel(m,modeltype,R0,Rstep)
%[Q(2,:,:) R(2,:) P(2,:,:) modeltype(4) R0(2) Rstep(2)] = populate_Pmodel(m,Pmodel,1,1);
Q = diag([ones(3,1);zeros(3,1)]*1000);
R = ones(m,1)';
P = diag([ones(3,1);zeros(3,1)]*3);