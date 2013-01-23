function val = mag(x)
val=0;
for i=1:max(size(x))
    val = val + x(i)^2;
end
val = sqrt(val);