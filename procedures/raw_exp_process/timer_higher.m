
for i=1:size(expp,1)
    higher = 0;
    for j=2:size(expp,2)-2
        if expp(i,j,3) > 0
            if expp(i,j-1,1) - higher > 60000
                if (expp(i,j,1) < 5000) & (expp(i,j+1,1) < 5000) & (expp(i,j+2,1) < 5000)
                    higher = higher + 65536;
                end
            end
            expp(i,j,1) = expp(i,j,1) + higher;
        end
	end
end
