
% clear variables;
load('C:\Documents and Settings\Adam\My Documents\nms\Cricket\doc\Mobisys04\code\exp2\post_everything.mat');
clc
defineConstants;
global enable_hybrid hybridused min_hybrid multi_num min_index min_x min_D min_U min_Qscale min_reject_buf min_suspect_buf min_runcounter min_PR_glob minP_index minP_x minP_D minP_U minP_Qscale minP_reject_buf minP_suspect_buf minP_runcounter minP_PR_glob

error_type = error_exp; %this code has been modified to assume this from here down

% comment one and uncomment the other:
data_type = type_active_beacon;
% data_type = type_passive_beacon;

input_series = 1;

% This is all down-sampling stuff
% sim_speed = target_scale * speed(input_series);
target_scale = 1; % no down-sampling

start_pos = 0;     %if ==1 then start sim when moving began, if ==0 start at beginning of log, if ==2 start just before stopping of motion
end_counter = -1; %if > 0 then this is the number of samples to process, if == 0 then go to end of motion,
                   %if == -1 then go to end of log

% this is only legal if data_type == type_active_beacon
enable_hybrid = 1;

mode = simmode;



%%%%%%  END OF SETUP INPUT  %%%%%%%%

% loadData;
% exp_in = expq;
% rawdata = squeeze(exp_in(input_series,:,:));
% process_expt;

%active mobile
% exp_passive_cnt = squeeze(meta_exp_passive_cnt(input_series,:));
% exp_data = squeeze(meta_exp_data(input_series,:,:,:));
% exp_bound = find_bounds(squeeze(exp_data(:,1,:))); % returns 1x3

%passive mobile
exp_data = squeeze(meta_single_exp_data(input_series,:,:));
exp_bound = find_bounds(squeeze(exp_data(:,:))); % returns 1x3

if start_pos == 1
	data_pointer = exp_bound(1)-40;
elseif start_pos == 0
    data_pointer = 1;
elseif start_pos == 2
    data_pointer = exp_bound(2)-80;
else
    data_pointer = start_pos;
end
if end_counter > 0
    end_at = data_pointer + end_counter;
elseif end_counter == 0
    end_at = exp_bound(2);
elseif end_counter == -1
    end_at = exp_bound(3);
else
    error('Unknown end_counter interpretation.');
end

if (enable_hybrid > 0) & (data_type ~= type_active_beacon)
    error('Hybrid operation is only legal in active beacon mode');
end

batchsize = end_at - data_pointer; % number of samples to get (for indexed data, up to this index (not size))
simmodesize = end_at - data_pointer; % size of circular data buffer

% # of beacons
m = size(FNid,1);
hybridused = 0;

xmaxcnt = 20;

% Data recording graphs
% Column 1 - absolute distance error (NOT SQUARED)
% Column 2 - chi-squared error of last beacon heard
% Column 3 - hybrid used?
% Note: this doesn't apply to first row, which has its own description in the comment next to it

graphs = [0,1,0; % Listener (abs. error and train position), don't put a '1' in (1,1) if looking at passive beacon data!
          1,0,0; % NLLS
          1,0,1; % Kalman
          1,0,0; % P_Kalman
          1,0,0; % multi
          1,0,0; % multi2
          
          0,0,0; % ...
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          0,0,0;
          
          0,0,0;
          0,0,0;
          0,0,0];
      
graphcnt = sum(sum(graphs));
if mode == simmode
    graphsize = simmodesize;
else
    graphsize = batchsize;
    graphruns = 1;
end

% Initialize some logging variables
graphdata = ones(graphcnt,graphsize);
graphptr = ones(2,1);
graphcnter = 1;
graphaxis = zeros(graphcnt,1);
graphobj = zeros(graphcnt,1);
simaxis = zeros(graphcnt,1);
chisqr_out = zeros(xmaxcnt,1);
x_hist = zeros(graphsize,6);


% Define beacons
% c = ___; c should already be loaded up from loadData!


lasttrack_index = 0;
beac_chirp = 1; % will indicate which beacon from FNid chirped
bufsize = zeros(xmaxcnt,1);
x = zeros(20,6); % define state vectors for every model
z = zeros(size(FNid,1),1); % define measurement vector for each beacon


% Set up models, first visibility
xvisible = zeros(xmaxcnt,1);
xvisible(1) = 1;
xvisible(2) = 1; % Remember most models are dependant on model 2 (by convention, NLLS) for init and bad state fallback
xvisible(3) = 1;
xvisible(4) = 1;
xvisible(5) = 1;
xvisible(6) = 1;

% xvisible(7) = 1;
% xvisible(8) = 1;
% xvisible(9) = 1;
% xvisible(10) = 1;
% xvisible(11) = 1;
% xvisible(12) = 1;
% xvisible(13) = 1;
% xvisible(14) = 1;
% xvisible(15) = 1;
% xvisible(16) = 1;
% xvisible(17) = 1;

% Now establish model types for every visible model
modeltype = zeros(xmaxcnt,1);
modeltype(1) = model_real;
modeltype(2) = model_bls;
modeltype(3) = model_min_kalman;
modeltype(4) = model_minP_kalman;
modeltype(5) = model_multi;
modeltype(6) = model_multi2;

% Define model descriptors matrices

bls_x = zeros(xmaxcnt,3);
bls_window_size = zeros(xmaxcnt,1);
bls_point_buffer = zeros(xmaxcnt,30,3);
bls_dist_buffer = zeros(xmaxcnt,30);
bls_resnorm = ones(xmaxcnt,1)*inf;

min_x = zeros(xmaxcnt,6);
min_D = ones(xmaxcnt,6);
min_U = zeros(xmaxcnt,6,6);
min_Qscale = zeros(20,1);  %%%%%%%%%%%%%%%% MUST COMMENT OUT DURING META_RUNS!!!!!!!
min_reject_buf = zeros(xmaxcnt,20);
min_suspect_buf = zeros(xmaxcnt,20);
min_runcounter = zeros(xmaxcnt,1);

minP_x = zeros(xmaxcnt,3);
minP_D = ones(xmaxcnt,3);
minP_U = zeros(xmaxcnt,3,3);
minP_Qscale = zeros(20,1);  %%%%%%%%%%%%%%%% MUST COMMENT OUT DURING META_RUNS!!!!!!!
minP_reject_buf = zeros(xmaxcnt,20);
minP_suspect_buf = zeros(xmaxcnt,20);
minP_runcounter = zeros(xmaxcnt,1);


% Now populate appropriate information for each model
min_Qscale(3:17) = 10^-4.4;
minP_Qscale(3:17) = 10^-4;
for i=1:xmaxcnt
    min_U(i,:,:) = diag(ones(1,6)*sqrt(3*min_Qscale(i))); % const = sqrt(3*Qscale)
    minP_U(i,:,:) = diag(ones(1,3)*minP_Qscale(i)); % this is really G1 == sqrt(Qscale), but we'll just "call" minP_Qscale == sqrt(Qscale)
end
% chisqr values and max threshold ratios are coded into each procedure (min_kalman, ...)

bls_window_size(2) = 10;
bls_x(2,:) = [0 0 0];

multi_sources = [ 3 ; 4 ];
multi_num = size(multi_sources,1);
multi_weights = zeros(multi_num,1);
multi_x = zeros(multi_num,6);

% if we're doing visualizations then prepare
if mode == simmode
    setupSimmode;
end


internal_data_pointer = data_pointer;
% BEGIN
if mode == batchmode
    
    for i=1:3
        exp_bound(i) = floor(exp_bound(i) / target_scale);
    end
    batchsize = batchsize / target_scale;
	while graphcnter <= batchsize % graphcnter = 1 at beginning and inc's in tick after graphs but before steps
        tick
        
%         data_pointer = data_pointer + 1;
        internal_data_pointer = internal_data_pointer + target_scale;
%         internal_data_pointer = internal_data_pointer + speed(target_series)/speed(input_series);
        data_pointer = floor(internal_data_pointer);
%         if data_pointer < (exp_bound(3) * (speed(target_series)/speed(input_series)))
            if mod(graphcnter,100) == 0 
                disp(num2str(graphcnter));
            end        
	end
    
%     figure; [subplotx,subploty] = subplotsize(2); subplotcounter = 1;
    subplotx=0; subploty=0;
%     errGraph;
%     chiPRGraph;
elseif mode == simmode
	while button~='s' % one loop = one tick
        if graphcnter > simmodesize
            waitforbuttonpress;
        end
        if button=='p'
            waitforbuttonpress;
        end
        button=get(fig,'CurrentCharacter');
        if isempty(button)
            button='+';
        end
        if button=='d' %debug
            a=1;
            set(fig,'CurrentCharacter','+');
%             profile off
%             profile clear
%             profile on -detail operator -history
        end
        
        tick
        data_pointer = data_pointer + 1;
        
        for i=1:graphcnt
            set(graphobj(i),'XData',[1:graphsize],'YData',graphdata(i,:)');
        end
    
%         hscale=z(beac_chirp)/getrealdist(beac_chirp,c,x(1,1:3));
%         set(linehand(beac_chirp),'XData',[c(beac_chirp,1) x(1,1)*hscale],'YData',[c(beac_chirp,2) x(1,2)*hscale],'ZData',[c(beac_chirp,3) x(1,3)*hscale])
        
        for i=1:xmaxcnt
            if xvisible(i) > 0
                set(xpthand(i),'XData',x(i,1),'YData',x(i,2),'ZData',-1*abs(x(i,3)))
                if xlinehand(i) > 0
                    set(xlinehand(i),'Xdata',[x(i,1) x(i,1)+x(i,4)*xlinescale(i)],'YData',[x(i,2) x(i,2)+x(i,5)*xlinescale(i)],'ZData',[x(i,3) x(i,3)+x(i,6)*xlinescale(i)])
                end
            end
        end
        
        drawnow
        %frame = getframe(gca);
        %aviobj = addframe(aviobj,frame);
	end
end

if mode == simmode
	close all
	%aviobj = close(aviobj);
end