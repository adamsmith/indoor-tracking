


figure;
yo = zeros(size(lines,1),1);
meds = zeros(size(lines,1),1)';

for i=1:size(lines,1)
	int1=metabounds(lines(i,1),lines(i,2),1);
	int2=metabounds(lines(i,1),lines(i,2),2);
	yo(i)=cdfplot(metagraph(lines(i,1),lines(i,2),lines(i,3),int1:int2));
	hold on
    meds(i) = median(metagraph(lines(i,1),lines(i,2),lines(i,3),int1:int2));
end
if size(lines,1) > 3
	set(yo(4),'LineStyle',':');
end
if size(lines,1) > 2
	set(yo(3),'LineStyle','-.');
end
if size(lines,1) > 1
	set(yo(2),'LineStyle','--');
end
set(yo(1),'LineStyle','-');

axis([0 xmax 0 1]);
xlabel('Error (cm)','FontSize',12);
ylabel('Occurrences','FontSize',12);
title('');
% grid off;
if exist('strmat') == 0
	strmat=zeros(size(lines,1),30);
	master_arch = strvcat('PassiveMobile', 'ActiveMobile', 'Hybrid');
	master_model = strvcat('Real', 'LSQ', 'EKF-PV', 'HybridUsed', 'EKF-P', 'MultiModal');
	for i=1:size(lines,1)
        strmat(i,1:size(strcat(master_arch(lines(i,1),:), '-', master_model(lines(i,3),:)),2)) = strcat(master_arch(lines(i,1),:), '-', master_model(lines(i,3),:));
	end
end
[legend_h,object_h,plot_h,t_strings]=legend(yo,char(strmat),4);
for i=1:size(object_h,1)
    if get(object_h(1),'Type') == 'text'
        set(object_h(1),'FontSize',12);
    end
end
clear strmat;
% 'Hybrid-EKF-PV'
% 'Hybrid-MultiModal'
% 'ActiveMobile-MultiModal'

% h=legend(yo,'Medium Speed (44 cm/s)','High Speed (86 cm/s)',4);
% set(h,'Position',[0.4554    0.1548    0.4161    0.1238]);
% set(h,'Position',[0.5526    0.1521    0.3232    0.1250]);

meds