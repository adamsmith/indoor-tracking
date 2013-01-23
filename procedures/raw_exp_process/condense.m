expq = zeros(6,30000,7);

for i=1:size(expq_1,1)
    for j=1:size(expq,3)
        expq(1,i,j) = expq_1(i,j);
    end
end
for i=1:size(expq_2,1)
    for j=1:size(expq,3)
        expq(2,i,j) = expq_2(i,j);
    end
end
for i=1:size(expq_3,1)
    for j=1:size(expq,3)
        expq(3,i,j) = expq_3(i,j);
    end
end
for i=1:size(expq_4,1)
    for j=1:size(expq,3)
        expq(4,i,j) = expq_4(i,j);
    end
end
for i=1:size(expq_5,1)
    for j=1:size(expq,3)
        expq(5,i,j) = expq_5(i,j);
    end
end
for i=1:size(expq_6,1)
    for j=1:size(expq,3)
        expq(6,i,j) = expq_6(i,j);
    end
end