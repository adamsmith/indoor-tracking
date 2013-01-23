function x = point_fix_zero(FNid, FNcoords, distdata)
% SAME AS point_fix BUT WITH ADDED KNOWLEDGE THAT Z=0!

% calculate coordinates of single point given large number of samples
% input: FNid, c (or FNcoords), and distdata (distance,FNid)

beac_dists = 0;
beac_cnt = 1;
myFNcoords = zeros(1,3);
for i=1:size(FNid,1) %build dist list for every beacon
    tmp=0;
    cnt=1;
    for j=1:size(distdata,1)
        if (distdata(j,2) == FNid(i)) & distdata(j,1) ~= 0
            tmp(cnt) = distdata(j,1);
            cnt=cnt+1;
        end
    end
    if cnt == 1 %didn't get any data from this beacon
        % do nothing
    else
        beac_dists(beac_cnt) = median(tmp);
        myFNcoords(beac_cnt,:) = FNcoords(i,:);
        beac_cnt = beac_cnt+1;
    end
end

%start at -142, in inches haha
[x,resnorm] = LSQNONLIN(@nonlin_err_zero,[-142 0],[],[],optimset('Display','off','Jacobian','on','TolX',1e-10,'MaxFunEvals',10^(10^(1e10000))),myFNcoords,beac_dists);
x = [x 0];
if resnorm > 10000
    x = [0 0 0];
end
disp(['LSQ Residual: ' num2str(resnorm)]);
