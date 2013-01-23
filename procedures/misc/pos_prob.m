% ss = 1;
% bound = 150;
x = -100:1:100; %let each unit be a cm
y = -100:1:150;
z = zeros(size(y,2),size(x,2));
z2 = zeros(size(y,2),size(x,2));
answ = zeros(2,2);
resnorm = zeros(2,1);
x0 = [ 80, 20 ];

% now for each (x,y) find the lsq error

truepos = [75,75]-75;

mbeac_pos = [
    250,100;
    -150,-350;
    -400,400];

% mbeac_pos = [
%     0,100;
%     50*sqrt(2),-50*sqrt(2);
%     -50*sqrt(2),-50*sqrt(2)];
%     50,100;
%     100,50];

% for aa = 1:size(mbeac_pos,1)-1
%     beac_pos = squeeze(mbeac_pos(aa:aa+1,:));
    beac_pos = mbeac_pos;
    z = zeros(size(y,2),size(x,2));
    
	for i = 1:size(beac_pos,1)
        truedist(i) = sqrt((truepos(1)-beac_pos(i,1))^2 + (truepos(2)-beac_pos(i,2))^2);
	end
	
	for i = 1:size(x,2)
        for j = 1:size(y,2)
            for k = 1:size(beac_pos,1) %for each beacon
                z(j,i) = z(j,i) - normpdf(sqrt((x(i)-beac_pos(k,1))^2+(y(j)-beac_pos(k,2))^2), truedist(k), 14);
            end
        end
	end
    
    [answ(1,:),resnorm(1)] = LSQNONLIN(@nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,truedist);
    [answ(2,:),resnorm(2)] = LSQNONLIN(@minus_gauss_nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,truedist);
    
% 	figure;
% % 	meshc(x,y,z)
% 	surf(z)
% 	shading interp
% 	hold on
% 	[c ch] = contour3(z,200); set(ch,'edgecolor','b')
% 	[u v] = gradient(z);
% 	h = streamslice(-u,-v); 
% 	set(h,'color','k')
% 	for i=1:length(h); 
%         zi = interp2(z,get(h(i),'xdata'),get(h(i),'ydata'));
%         set(h(i),'zdata',zi);
% 	end
% %     plot(answ(1,1),answ(1,2),z(floor(answ(1,1)),floor(answ(1,2))),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
% %     plot(answ(2,1),answ(2,2),z(floor(answ(2,1)),floor(answ(2,2))),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',12);
% 	
% 	figure;
% 	contour(x,y,z,200); hold on;
% 	for i=1:size(beac_pos,1)
%         plot(beac_pos(i,1),beac_pos(i,2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
% 	end
% 	plot(truepos(1),truepos(2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',12);
% end