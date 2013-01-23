
      
% format of metabounds: arch, speed, bound
      
err = zeros(size(lines,1),5);
yo = zeros(size(lines,1),1);

figure;

for i=1:size(lines,1)
    for j=0:6
        if j > 0
			int1=metabounds(lines(i,1),j,1);
			int2=metabounds(lines(i,1),j,2);
%             err(i,j+1) = percentile(metagraph(lines(i,1),j,lines(i,2),int1:int2),.95);
            err(i,j+1) = median(metagraph(lines(i,1),j,lines(i,2),int1:int2));
        else
            int1=1;
            int2=metabounds(lines(i,1),j+1,1);
%             err(i,j+1) = percentile(metagraph(lines(i,1),1,lines(i,2),int1:int2),.95);
            err(i,j+1) = median(metagraph(lines(i,1),1,lines(i,2),int1:int2));
        end
    end
    yo(i) = plot([0;speed],err(i,:)');
    hold on;
end
if size(lines,1) > 3
	set(yo(4),'LineStyle',':');
	set(yo(4),'Marker','.');
	set(yo(4),'MarkerSize',20);
end
if size(lines,1) > 2
	set(yo(3),'LineStyle','-.');
	set(yo(3),'Marker','.');
	set(yo(3),'MarkerSize',20);
end
if size(lines,1) > 1
	set(yo(2),'LineStyle','--');
	set(yo(2),'Marker','.');
	set(yo(2),'MarkerSize',20);
end
set(yo(1),'LineStyle','-');
set(yo(1),'Marker','.');
set(yo(1),'MarkerSize',20);

% axis([0 xmax 0 1]);
xlabel('Speed (cm/s)','FontSize',12);
% ylabel('Median Error (cm)');
ylabel('Median Error (cm)','FontSize',12);
title('');%num2str(myfrac));
% grid off;
% h=legend(yo,'Hybrid-MultiModal','ActiveBeacon-MultiModal','ActiveMobile-MultiModal',4);
if exist('strmat') == 0
	strmat=zeros(size(lines,1),30);
	master_arch = strvcat('PassiveMobile', 'ActiveMobile', 'Hybrid');
	master_model = strvcat('Real', 'LSQ', 'EKF-PV', 'HybridUsed', 'EKF-P', 'MultiModal');
	for i=1:size(lines,1)
        strmat(i,1:size(strcat(master_arch(lines(i,1),:), '-', master_model(lines(i,2),:)),2)) = strcat(master_arch(lines(i,1),:), '-', master_model(lines(i,2),:));
	end
end
[legend_h,object_h,plot_h,t_strings]=legend(yo,char(strmat),pos);
for i=1:size(object_h,1)
    if get(object_h(1),'Type') == 'text'
        set(object_h(1),'FontSize',12);
    end
end
clear strmat;
% set(h,'Position',[0.4554    0.1548    0.4161    0.1238]);
% set(h,'Position',[0.5526    0.1521    0.3232    0.1250]);