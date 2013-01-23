
beac_chirp = [];
while isempty(beac_chirp) == 1
	beac_chirp = find(FNid == exp_data(data_pointer,4));
    if isempty(beac_chirp)
        warning(['WARNING: Invalid beacon id found at ' num2str(data_pointer)]);
        data_pointer = data_pointer + 1;
    end
end
z(beac_chirp) = exp_data(data_pointer,3);

if data_pointer == 1
    dT = -1;
else
    dT = exp_data(data_pointer,1) - exp_data(data_pointer-1,1);
end

hybridused = 0;
lasttrack_index = mod(exp_data(data_pointer,2),counter_max)+1;
if enable_hybrid > 0
	min_hybrid = zeros(hybrid_data_cnt(lasttrack_index),4);
	for i=1:size(min_hybrid,1)
		min_hybrid(i,:) = [hybrid_data(lasttrack_index,i,3) hybrid_coords(hybrid_data(lasttrack_index,i,4),:)];
	end
end

for i=1:xmaxcnt
    if xvisible(i) > 0
        
        
        if modeltype(i) == model_real
            
            
            x(i,1:3) = pdata(lasttrack_index,:);
            
            
        elseif modeltype(i) == model_LinLS
            
            
            [x(i,1) x(i,2) x(i,3)] = linls(z(i,:),c,m);
            
            
        elseif modeltype(i) == model_bls
            
            
            [bls_point_buffer(i,:,:),bls_dist_buffer(i,:),bls_x(i,:),bls_resnorm(i)] = bls(squeeze(bls_point_buffer(i,:,:)),squeeze(bls_dist_buffer(i,:)),squeeze(bls_x(i,:)),bls_window_size(i),c(beac_chirp,:)',z(beac_chirp),bls_resnorm(i));
            x(i,:) = [bls_x(i,:) 0 0 0];
            %filter x_z symmetry
            if x(i,3) > 252.73
                x(i,3) = 2*252.73 - x(i,3);
                bls_x(i,3) = x(i,3);
            end
            
            
        elseif modeltype(i) == model_min_kalman
            
            alt_pt = squeeze(x(2,1:3));
            min_index = i;
            min_runcounter(min_index) = min_runcounter(min_index) + 1;
            if dT > 0
                [chisqr_out(i),tmp] = min_kalman(alt_pt,dT,c(beac_chirp,:)',z(beac_chirp));
                x(i,:) = min_x(min_index,:);
                handle = find(multi_sources == i);
                if ~isempty(handle)
                    multi_x(handle,:) = x(i,:);
                    multi_weights(handle) = tmp;
                end
            end
            %filter x_z symmetry
            if x(i,3) > 252.73
                x(i,3) = 2*252.73 - x(i,3);
                min_x(min_index,3) = x(i,3);
            end
            
            
        elseif modeltype(i) == model_minP_kalman
            
            alt_pt = squeeze(x(2,1:3));
            minP_index = i;
            minP_runcounter(minP_index) = minP_runcounter(minP_index) + 1;
            if dT > 0
                [chisqr_out(i),tmp] = minP_kalman(alt_pt,dT,c(beac_chirp,:)',z(beac_chirp));
                x(i,:) = [minP_x(minP_index,1:3) 0 0 0];
                handle = find(multi_sources == i);
                if ~isempty(handle)
                    multi_x(handle,:) = x(i,:);
                    multi_weights(handle) = tmp;
                end
            end
            %filter x_z symmetry
            if x(i,3) > 252.73
                x(i,3) = 2*252.73 - x(i,3);
                minP_x(minP_index,3) = x(i,3);
            end
            
            
        elseif modeltype(i) == model_multi
            
            
            x(i,:) = multi(multi_weights,multi_x);
            
            
        elseif modeltype(i) == model_multi2
            
            
            x(i,:) = multi2(multi_weights,multi_x);
            
            
        else
            
            
            error(['Unknown modeltype for model number ' num2str(i)]);
            
            
        end
    end
end