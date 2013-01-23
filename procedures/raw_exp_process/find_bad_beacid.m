% MAKE SURE FNid IS LOADED UP FIRST!
% MAKE SURE FNid IS LOADED UP FIRST!
% MAKE SURE FNid IS LOADED UP FIRST!
% MAKE SURE FNid IS LOADED UP FIRST!

correct = 1;
for i=1:size(expq,1)
    for j=1:size(expq,2)
        if (isempty(find(FNid == expq(i,j,4))) == 1) & (expq(i,j,5) ~= 0)
            disp([num2str(i) ' ' num2str(j)]);
			if correct == 1
                for k=1:
                    expq(i,j,k) = 0;
                end
            end
        end
    end
end
