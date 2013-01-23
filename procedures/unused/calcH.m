function H = calcH(x,c)
H = zeros(size(c,1),3);
for i=1:size(c,1)
    for j=1:3
        H(i,j)=(x(j)-c(i,j))/getrealdist(i,c,x);
    end
end