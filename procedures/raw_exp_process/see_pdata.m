figure;
% for i=1:size(pdata,1)
%     pdata(i,1) = pdata(i,1) + 450;
%     pdata(i,2) = pdata(i,2) + 20;
% end
for i=2:size(pdata,1)
    line([pdata(i-1,1) pdata(i,1)],[pdata(i-1,2) pdata(i,2)]);
    hold on
%     if mod(i,20) == 0
%         text(pdata(i,1),pdata(i,2),['\leftarrow ' num2str(i)],'FontSize',16)
%         hold on
%     end
end
line([pdata(i,1) pdata(1,1)],[pdata(i,2) pdata(1,2)]);
xlabel('Position (cm)','FontSize',12);
ylabel('Position (cm)','FontSize',12);
title('');
% axis([0 500 0 160])

% figure;
% for i=2:size(known,1)
%     text(known(i,2),known(i,3),['\leftarrowcounter = ' num2str(known(i,1))],'FontSize',16)
%     hold on
%     line([known(i-1,2) known(i,2)],[known(i-1,3) known(i,3)]);
%     hold on
% end
% text(known(1,2),known(1,3),['\leftarrowcounter = ' num2str(known(1,1))],'FontSize',16)
% hold on
% line([known(i,2) known(1,2)],[known(i,3) known(1,3)]);