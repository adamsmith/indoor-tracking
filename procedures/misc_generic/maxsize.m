function ret = maxsize(x)
%x is a row vector
val = size(x);
val2 = size(x');
if val > val2
    ret = val;
else
    ret = val2;
end