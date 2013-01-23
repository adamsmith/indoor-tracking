
passive_dists = squeeze(exp_data(data_pointer,1:exp_passive_cnt(data_pointer),3));
passive_beacons = squeeze(exp_data(data_pointer,1:exp_passive_cnt(data_pointer),4));
passive_points = zeros(max(size(passive_beacons)),3);
for i=1:size(passive_points,1)
    passive_beacon_index = find(FNid == passive_beacons(i));
    passive_points(i,:) = c(passive_beacon_index,:);
end

if data_pointer == 1
    dT = -1; % dT doesn't matter if runcounter <= 4 anyway, since EKF's will revert to altpoint (NLLS, which isn't a function of dT)
else
    dT = exp_data(data_pointer,1,1) - exp_data(data_pointer-1,1,1);
end

for i=1:xmaxcnt
    if xvisible(i) > 0
        
        
        if modeltype(i) == model_real
            
            
            lasttrack_index = mod(exp_data(data_pointer,1,2),counter_max)+1;
            x(i,1:3) = pdata(lasttrack_index,:);
            
            
        elseif modeltype(i) == model_min_kalman
            
            % We can use the same state variables (min_runcounter, min_x, etc.) for both passive and active, don't need to differentiate
            min_index = i;
            min_runcounter(min_index) = min_runcounter(min_index) + 1;
            if dT > 0
                [chisqr_out(i),tmp] = min_kalman_passive(squeeze(x(2,1:3)),dT,passive_points,passive_dists);
                x(i,:) = min_x(min_index,:);
                handle = find(multi_sources == i);
                if ~isempty(handle)
                    multi_x(handle,:) = x(i,:);
                    multi_weights(handle) = tmp;
                end
            end
            
            
        elseif modeltype(i) == model_minP_kalman
            
            
            minP_index = i;
            minP_runcounter(minP_index) = minP_runcounter(minP_index) + 1;
            if dT > 0
                [chisqr_out(i),tmp] = minP_kalman_passive(squeeze(x(2,1:3)),dT,passive_points,passive_dists);
                x(i,:) = [minP_x(minP_index,1:3) 0 0 0];
                handle = find(multi_sources == i);
                if ~isempty(handle)
                    multi_x(handle,:) = x(i,:);
                    multi_weights(handle) = tmp;
                end
            end
            
            
        elseif modeltype(i) == model_multi
            
            
            x(i,:) = multi(multi_weights,multi_x);
            
            
        elseif modeltype(i) == model_multi2
            
            
            x(i,:) = multi2(multi_weights,multi_x);
%             x_hist(data_pointer,:) = x(i,:);
            
            
        elseif modeltype(i) == model_bls
            
            
            [bls_x(i,:),bls_resnorm(i)] = bls_passive(squeeze(bls_x(i,:)),passive_points,passive_dists,bls_resnorm(i));
            if (bls_x(i,3) > c(1,3)) % we should be below the plane of beacons => filter symmetry
                bls_x(i,3) = bls_x(i,3) - 2 * c(1,3);
            end
            x(i,:) = [bls_x(i,:) 0 0 0];
%             passpoints(passpointscnt,:) = [mod(exp_data(data_pointer,1,2),counter_max)  x(i,1:3)];
%             passpointscnt = passpointscnt + 1;
            
            
        elseif modeltype(i) == model_LinLS
            
            
            error('not supporting LinLS in passive mode for now');
%             [x(i,1) x(i,2) x(i,3)] = linls(z(i,:),c,m);
            
            
        else
            
            
            error(['Unknown modeltype for model number ' num2str(i)]);
            
            
        end        
    end
end