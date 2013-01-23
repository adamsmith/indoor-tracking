function [res] = mult(x,y,z,cnt)
if (nargin ==3)
    res = x*y;
    myln=z;
else
    res = x*y*z;
    myln=cnt;
end
if (res == 0)
    disp(['Zero multiply on ' num2str(myln)]);
end