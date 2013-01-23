function [x,resnorm]=bls_passive(bls_x,min_points,min_dists,resnorm)

% LSQNONLIN is bad about local mins and therefore sensitive to x0, so use Allen's LinLS to get x0
if resnorm > 900
	if size(min_points,1) == 4
        [bls_x(1) bls_x(2) bls_x(3)] = min_per_constr(min_points,min_dists');
	elseif size(min_points,1) > 4
        %suppose a max of 1 in 5 is an outlier: try all 5 choose 4 and see which ones correlate
        xres = zeros(5,3);
        for i=1:5
            tempx = zeros(4,3);
            tempz = zeros(4,1);
            cnt = 1;
            for j=1:5
                if i ~= j
                    tempx(cnt,:) = min_points(j,:);
                    tempz(cnt) = min_dists(j);
                    cnt = cnt + 1;
                end
            end
            xres(i,:) = min_per_constr(tempx,tempz);
        end
        bls_x = median(xres);
	end
end
    
[x,resnorm] = LSQNONLIN(@nonlin_err,bls_x,[],[],optimset('Display','off','Jacobian','on'),min_points,min_dists');
resnorm = resnorm / size(min_points,1);