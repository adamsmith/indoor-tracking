gtdata = zeros(size(graphdata,1)-1,344,100);
gtdata_cnt = ones(344,1);

for i=1:size(graphdata,2)
    track = mod(graphdata(1,i),344)+1;
    if gtdata_cnt(track) <= 100 % if it's more then that's where we were at rest and we don't care for more samples
        for j=1:size(graphdata,1)-1
            gtdata(j,track,gtdata_cnt(track)) = graphdata(j+1,i);
        end
        gtdata_cnt(track) = gtdata_cnt(track) + 1;
    end
end

gtdata_med = zeros(size(graphdata,1)-1,344);
for i=1:size(graphdata,1)-1
    for j=1:344
        gtdata_med(i,j) = median(squeeze(gtdata(i,j,1:gtdata_cnt(j)-1)));
    end
end