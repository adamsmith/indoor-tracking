% load up a passive beacon data set first

figure;
cdfplot(exp_passive_cnt);
grid off;
axis([0 7 0 1]);
xlabel('Number of Observations');
ylabel('Occurrences');
title('');