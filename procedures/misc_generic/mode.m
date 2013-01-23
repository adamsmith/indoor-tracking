function val = mode(x)
min=inf;
xsize = maxsize(x);
for i=1:xsize
    if x(i) < min
        min = x(i);
    end
end

count = zeros(range(x)+1,1);
for i=1:xsize
    count(x(i)-min+1)=count(x(i)-min+1)+1;
end

val=0;

for i=1:range(x)+1
    if count(i) > val
        val = i+min;
    end
end