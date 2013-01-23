numobs = zeros(3,1);
numobs(1) = (metabounds(1,4,2) - metabounds(1,4,1) + 1);
numobs(2) = (metabounds(2,4,2) - metabounds(2,4,1) + 1)*6;
numobs(3) = sum(metagraph(3,4,4,:))*6 + (metabounds(3,4,2) - metabounds(3,4,1) + 1);

meanobs = zeros(3,1);
meanobs(1) = 1;
meanobs(2) = 6;
meanobs(3) = 1 + (6*sum(metagraph(3,4,4,:)) / (metabounds(2,4,2) - metabounds(2,4,1)));

toterr = zeros(3,1);
toterr(1) = sum(range_filter(squeeze(metagraph(1,4,5,metabounds(1,4,1):metabounds(1,4,2))),0.99));
toterr(2) = sum(range_filter(squeeze(metagraph(2,4,5,metabounds(2,4,1):metabounds(2,4,2))),0.99));
toterr(3) = sum(range_filter(squeeze(metagraph(3,4,6,metabounds(3,4,1):metabounds(3,4,2))),0.99));

mederr = zeros(3,1);
mederr(1) = median(squeeze(metagraph(1,4,5,metabounds(1,4,1):metabounds(1,4,2))));
mederr(2) = median(squeeze(metagraph(2,4,5,metabounds(2,4,1):metabounds(2,4,2))));
mederr(3) = median(squeeze(metagraph(3,4,6,metabounds(3,4,1):metabounds(3,4,2))));

meanerr = zeros(3,1);
meanerr(1) = mean(range_filter(squeeze(metagraph(1,4,5,metabounds(1,4,1):metabounds(1,4,2))),0.99));
meanerr(2) = mean(range_filter(squeeze(metagraph(2,4,5,metabounds(2,4,1):metabounds(2,4,2))),0.99));
meanerr(3) = mean(range_filter(squeeze(metagraph(3,4,6,metabounds(3,4,1):metabounds(3,4,2))),0.99));

metric = zeros(3,1);
metric = meanerr .* meanobs;
% metric = meanerr ./ numobs;
% metric = mederr ./ numobs;
% metric = toterr ./ numobs;

metric