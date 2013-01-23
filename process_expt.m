% input format:
% (MN timestamp),(track counter),(distance),(beacon id),(listener id)

clear exp_data exp_passive_cnt

ibac = i; jbac = j; kbac = k;

if data_type == type_active_beacon
    exp_data = rawdata;
    exp_bound = find_bounds(exp_data); % returns 1x3
elseif data_type == type_passive_beacon
    exp_data = zeros(1,size(FNid,1),5);
	exp_passive_cnt = ones(1,1); % 1xk matrix (i.e. grows into columns)
	
	for i=1:size(rawdata,1)
        if rawdata(i,5) == MNid
            MNtimematch = 0;
            FNidmatch = 0;
            for j=1:size(FNid)
                if rawdata(i,4) == FNid(j)
                    FNidmatch = 1;
                    for k=1:size(exp_passive_cnt,2) - 1
                        if rawdata(i,1) == exp_data(k,1)  % if time indexes match
                            MNtimematch = 1;
                            if exp_passive_cnt(k) > 
                                % we're getting some kind of error from hearing two records with the same
                                % FNid's and timestamps -> just skip this last one
                                break
                            end
                            exp_data(k,exp_passive_cnt(k),:) = rawdata(i,:);
                            exp_passive_cnt(k) = exp_passive_cnt(k) + 1;
                            break
                        end
                    end
                    if MNtimematch == 0 %start a new active mobile chirp record with this time index
                        exp_data(size(exp_passive_cnt,2),1,:) = rawdata(i,:);
                        exp_passive_cnt(size(exp_passive_cnt,2)) = 2;
                        exp_passive_cnt(size(exp_passive_cnt,2)+1) = 2;
                    end
                    break
                end
            end
            if FNidmatch == 0
                error(['Error: rawdata entry ',num2str(i),' does not has (i,3)==MNid but (i,4)~=FNid!']);
            end
        elseif rawdata(i,3) == 0
            % do nothing since it's a zero'd entry
        end
	end
    exp_bound = find_bounds(squeeze(exp_data(:,1,:))); % returns 1x3
    exp_passive_cnt = exp_passive_cnt(1:size(exp_passive_cnt,2)-1);
    for i=1:size(exp_passive_cnt,2)
        exp_passive_cnt(i) = exp_passive_cnt(i)-1;
    end
else
    error('Unknown data_type');
end

i = ibac; j = jbac; k = kbac;





















%%% ACTIVE BEACON MODELS
% Note that we must process BLS before min_Kalman since the latter uses the former as a backup for bad state
% cricket_data format: (MN timestamp),(distance),(source/beacon id)

% min_kalman_init;
% xmaxcnt=1;
% bls_x = zeros(xmaxcnt,3);
% bls_window_size = zeros(xmaxcnt,1);
% bls_point_buffer = zeros(xmaxcnt,30,3);
% bls_dist_buffer = zeros(xmaxcnt,30,1);
% 
% bls_window_size(19) = 14;
% 
% x_log = zeros(5,6);
% 
% for i=1:size(cricket_data,1)
%     if i==1
%         dT = .1; % this shouldn't matter really
% 	else
%         dT = cricket_data(i,1) - cricket_data(i-1,1);
%     end
%     if dT <= 0
%         error(['Error: dT ',num2str(dT),' is negative or zero!']);
%     end
%     
%     
%     [bls_point_buffer(1,:,:),bls_dist_buffer(1,:),bls_x(1,:)] = bls(squeeze(bls_point_buffer(1,:,:)),squeeze(bls_dist_buffer(1,:)),squeeze(bls_x(1,:)),bls_window_size(1),dT,FNcoord(find(FNid == cricket_data(i,3)),:),cricket_data(i,2));
%     x_log(1,:) = [bls_x(1,:) 0 0 0];
%     
%     
%     [graph_min_chisqr,dummy] = min_kalman(x(19,1:3),dT,c(beac_chirp,:)',z(1,beac_chirp));