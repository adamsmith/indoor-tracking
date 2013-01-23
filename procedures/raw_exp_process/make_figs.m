clear variables;
load('c:\exp_data\results\make_figs_env.mat');
see_pdata
save_figs(gcf,'track_layout');
close(gcf);

%arch, speed, model

lines = [ ...
1,3,6;  
1,3,2;
2,3,6;
3,3,3;
];
xmax = 100;
make_cdf;
save_figs(gcf,'model_err_3ticks');
close(gcf);

lines = [ ...
1,6,6;  
1,6,2;
2,6,6;
3,6,3;
];
xmax = 100;
make_cdf;
save_figs(gcf,'model_err_6ticks');
close(gcf);

lines = [ ...
3,3,3;
3,6,3;
];
xmax = 100;
strmat = strvcat('Medium Speed (78 cm/s)','High Speed (143 cm/s)');
make_cdf;
save_figs(gcf,'hybrid_speed_err');
close(gcf);

%arch, speed, model

lines = [ ...
1,6,6;
2,6,2;
3,6,3;
];
xmax = 100;
make_cdf;
save_figs(gcf,'arch_err_6ticks');
close(gcf);

lines = [ ...
1,3,6;
2,3,2;
3,3,3;
];
xmax = 100;
make_cdf;
save_figs(gcf,'arch_err_3ticks');
close(gcf);

figure; cdfplot(moving_meas_err);
axis([0 6 0 1]);
xlabel('Error (cm)','FontSize',12);
ylabel('Occurrences','FontSize',12);
title('');
grid on;
save_figs(gcf,'exp_meas_err_3ticks');
close(gcf);

save('tempyoyo.mat');
clear variables;
load('C:\Exp_data\results\discrete_multimodal_err.mat');
% have to load up 'discrete_multimodal_err.mat' first
lines = [ ...
1,3,6;
1,3,5;
];
xmax = 100;
strmat = strvcat('PassiveMobile-MultiModal','PassiveMobile-DiscreteMultiModal');
make_cdf;
save_figs(gcf,'discrete_multimodal_err');
close(gcf);
clear variables;
load('tempyoyo.mat')
delete('tempyoyo.mat');


lines = [ ...
1,3,3;
1,3,5;
];
xmax = 100;
make_cdf;
save_figs(gcf,'ekf_err_3ticks');
close(gcf);


lines = [ 1 , 6 ;  %don't give speed, that's what we're exploring
          2 , 6 ;
          3 , 3 ;];
pos=2; %upper-left corner
make_speed_err;
grid on;
save_figs(gcf,'arch_speed_err');
close(gcf);


figure; cdfplot(meta_exp_passive_cnt(3,1:3000));
axis([1 5 0 .1]);
set(gca,'xtick',[1 2 3 4 5]);
xlabel('Number of Observations','FontSize',12);
ylabel('Occurrences','FontSize',12);
title('');
grid off;
save_figs(gcf,'active_mobile_replies_cable');
close(gcf);


save('tempyoyo.mat');
clear variables;
load('C:\Documents and Settings\Administrator\My Documents\nms\Cricket\doc\Mobisys04\code\exp1_results\passive_2ticks_results.mat');
% have to load up old exp1 data first
figure; cdfplot(exp_passive_cnt);
axis([1 6 0 1]);
set(gca,'xtick',[1 2 3 4 5 6]);
xlabel('Number of Observations','FontSize',12);
ylabel('Occurrences','FontSize',12);
title('');
grid off;
save_figs(gcf,'active_mobile_replies_rf');
close(gcf);
clear variables;
load('tempyoyo.mat');
delete('tempyoyo.mat');



%----------------------------------------------
save('tempyoyo.mat');
clear variables;
load('C:\Documents and Settings\Administrator\My Documents\nms\Cricket\doc\Mobisys04\code\exp1_results\processed_meta_data.mat');
load('C:\Documents and Settings\Administrator\My Documents\nms\Cricket\doc\Mobisys04\code\exp1_results\passive_2ticks_results.mat');
% have to load up old exp1 data first

lines = [ ...
1,4,5;
1,4,6;
];
xmax = 150;
strmat = strvcat('PassiveMobile-MultiModal','PassiveMobile-DiscreteMultiModal');
make_cdf;
% set(gca,'xtick',[]);
xlabel('Error','FontSize',12);
% grid off;
save_figs(gcf,'discrete_multimodal_err_exp1');
close(gcf);

lines = [ ...
1,4,3;
1,4,5;
];
xmax = 150;
make_cdf;
% set(gca,'xtick',[]);
xlabel('Error','FontSize',12);
% grid off;
save_figs(gcf,'ekf_err_exp1_4ticks');
% close(gcf);

see_pdata
save_figs(gcf,'track_layout_exp1');
close(gcf);

clear variables;
load('tempyoyo.mat');
delete('tempyoyo.mat');
%----------------------------------------------



lines = [ 1 , 6 ;  %don't give speed, that's what we're exploring
          1 , 2 ;
          2 , 6 ;];
pos=2; %upper-left corner
make_speed_err;
grid on;
save_figs(gcf,'model_speed_err');
close(gcf);


make_hybrid_chirps;
grid on;
save_figs(gcf,'hybrid_chirp_freq');
close(gcf);


figure;
yo = plot(speed_scaling_error(:,1),speed_scaling_error(:,2).*100,'-');
xlabel('Speed Scaling Factor','FontSize',12);
ylabel('Relative Error (%)','FontSize',12);
title('');
grid on;
set(yo,'LineStyle','-');
set(yo,'Marker','.');
set(yo,'MarkerSize',20);
save_figs(gcf,'speed_scaling_proof');
close(gcf);


figure;
yo = plot(scaled_speed_err(:,1),scaled_speed_err(:,2),'-');
xlabel('Scaled Speed (cm/s)','FontSize',12);
ylabel('Median Error (cm)','FontSize',12);
title('');
grid on;
set(yo,'LineStyle','-');
set(yo,'Marker','.');
set(yo,'MarkerSize',20);
save_figs(gcf,'speed_scaling_results');
close(gcf);