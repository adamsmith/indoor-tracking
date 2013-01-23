load('C:\Documents and Settings\Administrator\Desktop\expg\expg_setup.mat');

r_dists = zeros(size(r_coord,1),size(FNid,1));

for i=1:size(r_coord,1)
    for j=1:size(FNid,1)
        tmp = zeros(1,1);
        cnt = 1;
        for k=1:size(expg_r,2)
            if expg_r(i,k,4) == FNid(j)
                tmp(cnt) = expg_r(i,k,3);
                cnt=cnt+1;
            end
        end
        r_dists(i,j) = median(tmp);
        if (i == 2) & (j == 6)
            cdfplot(tmp);
        end
    end
end

error_cnt = 1;
for i=1:size(r_dists,1)
    for j=1:size(r_dists,2)
        %calculate what it should be
        expected(error_cnt) = sqrt((c(j,1) - r_coord(i,1))^2+(c(j,2) - r_coord(i,2))^2+(c(j,3) - r_coord(i,3))^2);
        error(error_cnt) = abs(expected(error_cnt) - r_dists(i,j));
        errm(i,j) = error(error_cnt);
        if (i == 8) & (j == 3)
            a=1;
        end
        error_cnt = error_cnt + 1;
    end
end