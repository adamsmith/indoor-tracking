expq_p_1 = csvread('c:\exp_data\expq_p_1.txt');
expq_p_2 = csvread('c:\exp_data\expq_p_2.txt');
expq_p_3 = csvread('c:\exp_data\expq_p_3.txt');
expq_p_4 = csvread('c:\exp_data\expq_p_4.txt');
expq_p_5 = csvread('c:\exp_data\expq_p_5.txt');
expq_p_6 = csvread('c:\exp_data\expq_p_6.txt');

all_pdata = zeros(120000,7);

counter=1;
for i=1:size(expq_p_1,1)
        all_pdata(counter,:) = expq_p_1(i,:); counter = counter + 1;
end
for i=1:size(expq_p_2,1)
        all_pdata(counter,:) = expq_p_2(i,:); counter = counter + 1;
end
for i=1:size(expq_p_3,1)
        all_pdata(counter,:) = expq_p_3(i,:); counter = counter + 1;
end
for i=1:size(expq_p_4,1)
        all_pdata(counter,:) = expq_p_4(i,:); counter = counter + 1;
end
for i=1:size(expq_p_5,1)
        all_pdata(counter,:) = expq_p_5(i,:); counter = counter + 1;
end
for i=1:size(expq_p_6,1)
        all_pdata(counter,:) = expq_p_6(i,:); counter = counter + 1;
end



% function segment_pdata
% input: all_pdata: records (active mobile format: time meas recv'ed, time of chirp,
% dist, chirp nonce, track counter, beacon id, mobile id)

cpy = sortrows(all_pdata, 5);

stop_points = zeros(1,1); %vector of track counters where we've stopped
%  clear stop_points; %so that we don't rule out '0' track counter
cnt = 0;
for i=1:size(cpy,1)
    if (cnt > 0) & (find(stop_points == cpy(i, 5)) > 0) % we're already doing this one
        % nothing
    elseif (find_end_from_here(cpy, 5, i) - i) > 30
        cnt = cnt + 1;
        stop_points(cnt) = cpy(i, 5);
        i = find_end_from_here(cpy, 5, i);
    else
        % there aren't enough from this track counter, jump to end
        i = find_end_from_here(cpy, 5, i);
    end
end

pdata_in = zeros(1,5,1); % in format for find_pdata: time, counter, distance, beacon id, listener id
cnt1 = 0;
cnt2 = 1; %index for current cnt1

for i=1:size(cpy,1)
    if (find(stop_points == cpy(i, 5)) > 0) %we should record this one
        if (cnt1 == 0) | (pdata_in(cnt1, 2, 1) ~= cpy(i, 5))
            %start new row
            cnt2 = 1;
            cnt1 = cnt1 + 1;
        end
        pdata_in(cnt1, :, cnt2) = [cpy(i,1), cpy(i,5), cpy(i,3), cpy(i,6:7)];
        cnt2 = cnt2 + 1;
    end
end

% convert distances

% for i=1:size(pdata_in,1)
%     for j=1:size(pdata_in,3)
%         pdata_in(i,4,j) = pdata_in(i,5,j);
%     end
% end