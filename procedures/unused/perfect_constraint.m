% X=A\B

A=[2*(x1-x0),2*(y1-y0),2*(z1-z0);2*(x2-x0),2*(y2-y0),2*(z2-z0);2*(x3-x0),2*(y3-y0),2*(z3-z0)];
B=[x1^2-x0^2+y1^2-y0^2+z1^2-z0^2;x2^2-x0^2+y2^2-y0^2+z2^2-z0^2;x3^2-x0^2+y3^2-y0^2+z3^2-z0^2];
X = A\B