function [point_buffer2,dist_buffer2,x,resnorm]=bls(bls_point_buffer,bls_dist_buffer,bls_x,bls_window_size,min_point,min_dist,resnorm)


for j=1:bls_window_size-1
    for k=1:3
        point_buffer(j,k) = bls_point_buffer(j+1,k);
    end
    dist_buffer(j) = bls_dist_buffer(j+1);
end
for j=1:3
    point_buffer(bls_window_size,j) = min_point(j);
end
dist_buffer(bls_window_size) = min_dist;

bls_internal_window_size = 1;
for i=1:bls_window_size
    if dist_buffer(i) ~= 0
        bls_internal_window_size = i;
        break
    end
end

% LSQNONLIN is bad about local mins and therefore sensitive to x0, so use Allen's LinLS on last four samples first to get x0
if resnorm > 10000
	if bls_window_size - bls_internal_window_size == 4
        [bls_x(1) bls_x(2) bls_x(3)] = min_per_constr(bls_point_buffer,bls_dist_buffer);
    elseif bls_window_size - bls_internal_window_size > 4
        %suppose a max of 1 in 5 is an outlier: try all 5 choose 4 and see which ones correlate
        xres = zeros(5,3);
        for i=1:5
            tempx = zeros(4,3);
            tempz = zeros(4,1);
            cnt = 1;
            for j=1:5
                if i ~= j
                    tempx(cnt,:) = point_buffer(bls_window_size - j + 1,:);
                    tempz(cnt) = dist_buffer(bls_window_size - j +1);
                    cnt = cnt + 1;
                end
            end
            xres(i,:) = min_per_constr(tempx,tempz);
        end
        bls_x = median(xres);
	end
end

% [bls_x(1),bls_x(2),bls_x(3)] = linls(dist_buffer(bls_internal_window_size:bls_window_size),point_buffer(bls_internal_window_size:bls_window_size,:),1+bls_window_size - bls_internal_window_size);

[x,resnorm] = LSQNONLIN(@nonlin_err,bls_x,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10^10^10^10),point_buffer(bls_internal_window_size:bls_window_size,:),dist_buffer(bls_internal_window_size:bls_window_size));

if (bls_window_size - bls_internal_window_size) ~= 0
	resnorm = resnorm / (bls_window_size - bls_internal_window_size);
end

point_buffer2 = zeros(30,3);
dist_buffer2 = zeros(1,30);
for i=1:bls_window_size
    dist_buffer2(i) = dist_buffer(i);
    for j=1:3
        point_buffer2(i,j) = point_buffer(i,j);
    end
end