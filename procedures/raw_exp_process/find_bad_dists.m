badcnt=0;
for i=1:size(expq,1)
    for j=1:size(expq,2)
        if (expq(i,j,1) ~= 0) & (expq(i,j,3) < 10)
            for k=1:5
                expq(i,j,k) = 0;
            end
            badcnt = badcnt + 1;
        end
    end
end
disp(num2str(badcnt));