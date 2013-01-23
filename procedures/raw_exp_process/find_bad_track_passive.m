
correct = 1;
badcnt=0;
for i=1:size(expq,1)
    done = zeros(size(expq,2),1);
    for j=2:size(expq,2)
        if done(j) == 0
            pair = find(squeeze(expq(i,:,1))' == expq(i,j,1));
            if isempty(pair)
                %can't validate
                done(j) = 1;
            else
                bestval = popular(expq(i,pair,2)); %not immune to some errors, most popular would be best
                for k=1:size(pair,1)
                    done(pair(k)) = 1;
                    if expq(i,pair(k),2) ~= bestval
                        badcnt = badcnt+1;
						if correct == 1
                            for n=1:
                                expq(i,pair(k),n) = 0;
                            end
                        end
                    else
                        a=1;
                    end
                end
            end
        end
    end
end
disp(num2str(badcnt));