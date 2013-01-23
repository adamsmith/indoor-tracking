for i=1:size(expg,1)
    err=0;
    for j=1:expg_bound(i,3)
        lasttrack_index = mod(expg(i,j,2),counter_max)+1;
        mypos = pdata(lasttrack_index,:);
        mybeac = [];
        stillokay=1;
		while isempty(mybeac) == 1
			mybeac = find(FNid == expg(i,j,4));
            if isempty(mybeac)
                warning(['WARNING: Invalid beacon id found at ' num2str(j)]);
                j = j + 1;
                if j >= expg_bound(i,3)
                    stillokay=0;
                    break
                end
            end
		end
        if stillokay == 1
            err(j) = expg(i,j,3) - sqrt((mypos(1,1)-c(mybeac,1))^2+(mypos(1,2)-c(mybeac,2))^2+(mypos(1,3)-c(mybeac,3))^2);
        end
    end
    figure; cdfplot(err(expg_bound(i,1):expg_bound(i,2)));
    axis([0 100 0 1]);
    median(err(expg_bound(i,1):expg_bound(i,2)))
%     for i=2300:1000:6300
%         figure; cdfplot(err(i-1000:i));
% 	end
end

%expf motion periods:
% 1:357-5462
% 2:1018-6506
% 3:973-5273
% 4:1246-6741