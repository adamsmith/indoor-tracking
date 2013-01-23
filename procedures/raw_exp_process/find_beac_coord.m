FNid = [1;
    2;
    3;
    4;
    5;
    6];

r_coord = [0,0,0;
    -214.4,0,0;
    -214.4,129.0,0;
    0,129.0,0];

c0 = [-6.9,152.4,229.3;
    39.1,46.9,229.3;
    -43.9,-20.3,229.3;
    -196.5,2.1,229.3;
    -277.4,56,229.3;
    -191.4,153.8,229.3];

c = zeros(size(c0,1),3);

% import_beac_coord_mult_files, then convert to cm


% we have 'r' points which are fixed (probably on the track) and have known
% coordinates.  For each 'r' we have r_coord (r x 3)

% expq_r = (each 'r', measurement record (___, ___, distance, FNid))
r_dists = zeros(size(r_coord,1),size(FNid,1));

for i=1:size(r_coord,1)  % for every 'r'
    for j=1:size(FNid,1)  % for every beacon
        tmp = zeros(1,1);
        cnt = 1;
        for k=1:size(expq_r,2)  % for every record
            if expq_r(i,k,4) == FNid(j)  % find each record for this 'r' from beacon 'j'
                tmp(cnt) = expq_r(i,k,3);
                cnt=cnt+1;
            end
        end
        r_dists(i,j) = median(tmp);  % find the median distance to beacon 'j' at this point r[i]
    end
end

for i=1:size(FNid)
    % beacons is (4 x 3) (rows are points and columns are coordinates)
    % dists is (4 x 1) (rows are distances to points)
    c(i,:) = LSQNONLIN(@nonlin_err,c0(i,:),[],[],optimset('Jacobian','on'),r_coord,r_dists(:,i));
%     c(i,1:2) = LSQNONLIN(@nonlin_err_zero,c0(i,1:2),[],[],optimset('Jacobian','on'),r_coord,r_dists(:,i));
end