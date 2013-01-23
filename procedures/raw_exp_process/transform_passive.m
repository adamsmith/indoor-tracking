% transform_passive

% (MN send timestamp, track counter, distance, FNid, MNid)
% (FN rx clock timestamp, MN tx clock timestamp, distance, rand sequence number, track counter, FNid, MNid)

tmp = zeros(size(expq,1),size(expq,2),5);

for i=1:size(expq,1)
    for j=1:size(expq,2)
        tmp(i,j,1) = expq(i,j,2);
        tmp(i,j,2) = expq(i,j,5);
        tmp(i,j,3) = expq(i,j,3);
        tmp(i,j,4) = expq(i,j,6);
        tmp(i,j,5) = expq(i,j,7);
    end
end

expq = tmp;