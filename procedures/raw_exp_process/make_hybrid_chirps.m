arch_ind = 3;
      
err = zeros(5,1);

figure;

for i=0:6
    if i > 0
        int1=metabounds(arch_ind,i,1);
        int2=metabounds(arch_ind,i,2);
        err(i+1) = sum(metagraph(arch_ind,i,4,int1:int2)) / (int2-int1+1);
    else
        int1=1;
        int2=metabounds(arch_ind,1,1);
        err(1) = sum(metagraph(arch_ind,1,4,int1:int2)) / (int2-int1+1);
    end
end
yo = plot([0;speed],err'.*100);
set(yo,'LineStyle','-');
set(yo,'Marker','.');
set(yo,'MarkerSize',20);

% axis([0 150 0 1]);
xlabel('Speed (cm/s)','FontSize',12);
ylabel('Percentile of Active Mobile Chirps','FontSize',12);
title('');
% grid off;
% h=legend(yo,'Hybrid-MultiModal','ActiveBeacon-MultiModal','ActiveMobile-MultiModal',4);
% h=legend(yo,'ActiveMobile-MultiModal','ActiveMobile-LSQ',4);
% set(h,'Position',[0.4554    0.1548    0.4161    0.1238]);
% set(h,'Position',[0.5526    0.1521    0.3232    0.1250]);