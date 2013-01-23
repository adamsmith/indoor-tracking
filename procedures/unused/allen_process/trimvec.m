function val = trimvec(x)
a=size(x');
for i=1:a
    if x(i)==0
        break;
    else
        val(i)=x(i);
    end
end