
for i=1:size(expq,1)
    tmp = zeros(size(expq,2),5);
    cnt = 1;
    for j=2:size(expq,2)
        if expq(i,j,3) ~= 0
            for k=1:5
                tmp(cnt,k) = expq(i,j,k);
            end
            cnt=cnt+1;
        end
    end
    cnt=1;
    for j=1:size(tmp,1)
        if tmp(j,3) == 0
            cnt=j-1;
            break
        end
    end
    expq(i,:,:) = tmp(:,:); %[ sortrows(tmp(1:cnt,:),1) ; zeros(size(tmp,1)-cnt,5) ];
end