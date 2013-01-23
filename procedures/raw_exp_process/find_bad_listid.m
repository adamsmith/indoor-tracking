
for i=1:size(expi,1)
    for j=1:size(expi,2)
        if (expi(i,j,5) ~= 9) & (expi(i,j,5) ~= 0)
            disp([num2str(i) ' ' num2str(j)]);
        end
    end
end