xpthand = zeros(xmaxcnt,1);
xptcolor = zeros(xmaxcnt,3);
xlinehand = zeros(xmaxcnt,1);
xlinecolor = zeros(xmaxcnt,3);
xlinescale = zeros(xmaxcnt,1);

xptcolor(1,:) = [.49 1 .63];
xptcolor(2,:) = [0 0 1]; %blue
xptcolor(3,:) = [1 1 0]; %yellow
xptcolor(4,:) = [.87 .8 .94];
xptcolor(5,:) = [1 1 0];

xlinecolor(1,:) = [0 0 1];
xlinecolor(4,:) = [0 0 1];
xlinecolor(5,:) = [0 0 1];
xlinecolor(6,:) = [0 0 1];

% xlinescale(1) = 1;
xlinescale(3) = 1; % Kalman is only one that should have velocity "line"

hold on
% 	for i=1:m
%         plot3(c(i,1),c(i,2),c(i,3),'-ro','Erasemode','xor','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12); %plot beacons; we don't need handles.
% 	end

bound = 50;
axis([-600 100 -80 150 -30 30])

simaxis = get(gcf,'CurrentAxes');
set(simaxis,'Position',[.25 .1 .7 .8]);
textaxis = axes('Position',[0 0 1 1],'Visible','off');
%textobj = text(.02,.85,'','FontSize',12,'FontName','FixedWidth');
set(gcf,'CurrentAxes',simaxis)
%PVinfo(1) = {'Info:'};

for i=1:graphcnt
    graphaxis(i) = axes('Position',[.02 .95-.30*i .23 .25]);
    graphobj(i) = plot(0);
end
set(gcf,'CurrentAxes',simaxis)
    
grid
set(gca,'CameraPosition',[-152.7587   28.3001  219.3363])
set(gca,'CameraTarget',[-152.7587   31.1977 -147.5235])
set(gca,'CameraUpVector',[0 0 1])
set(gca,'CameraViewAngle',8.6633)
% 	set(gca,'CameraPosition',[1.45924898052099 -0.94495553311281 1.44680785992351]*10^3)
% 	set(gca,'CameraTarget',[1.52513069867639 0.46552359231241 -1.20358835560264]*10^2)
% 	set(gca,'CameraUpVector',[-0.71801651939350 0.54480713356697 1.64786066865291])
% 	set(gca,'CameraViewAngle',8.6633)
set(gca,'XScale','linear')
set(gca,'YScale','linear')
set(gca,'ZScale','linear')
fig = figure(1);
button='+';
linehand = zeros(m); %to hold handles to line objects
hscale=0;

% 	for i=1:m
%         hscale=z(i)/getrealdist(i,c,x(1,1:3));
%         linehand(i)=line([c(i,1) x(1,1)*hscale],[c(i,2) x(1,2)*hscale],[c(i,3) x(1,3)*hscale],'Color','r','Erasemode','xor');
% 	end
for i=1:xmaxcnt
    if xvisible(i) > 0
        xpthand(i) = plot3(x(i,1),x(i,2),x(i,3),'-bo','Erasemode','xor','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',xptcolor(i,:),'MarkerSize',12);
        if xlinescale(i) > 0
            xlinehand(i) = line([x(i,1) x(i,1)+x(i,4)*xlinescale(i)],[x(i,2) x(i,2)+x(i,5)*xlinescale(i)],[x(i,3) x(i,3)+x(i,6)*xlinescale(i)],'Color',xlinecolor(i,:),'Erasemode','xor');
        end
    end
end
%aviobj = avifile('anim5.avi','fps',5);