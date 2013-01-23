
for i=1:size(expk,1)
    higher = 0;
    for j=2:size(expk,2)-2 %it should be okay to skip the last two since we expect there to be a lot of zero-entries at the end
        if expk(i,j,3) > 0
            if (expk(i,j-1,2) - higher) > 230
                if (expk(i,j,2) < 40) & (expk(i,j+1,2) < 40) & (expk(i,j+2,2) < 40)
                    higher = higher + 256;
                end
            end
            expk(i,j,2) = expk(i,j,2) + higher;
        end
	end
end
