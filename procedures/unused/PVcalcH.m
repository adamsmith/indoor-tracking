function H = PVcalcH(x,c)
H = zeros(size(c,1),6);
for i=1:size(c,1)
    for j=1:3
        H(i,j)=(x(j)-c(i,j))/getrealdist(i,c,x);
    end
    for j=4:6
        H(i,j)=0;
    end
end