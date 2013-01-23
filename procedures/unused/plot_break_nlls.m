ss = 1;
bound = 150;
x = 0:ss:bound; %let each unit be a cm
y = x;
z = zeros(size(y,2),size(x,2));
z2 = zeros(size(y,2),size(x,2));
answ = zeros(2,2);
resnorm = zeros(2,1);

x0 = [ 84.7581 , 145.3749 ];
truepos = [120.4510,12.5822];
truedist = [ 93.4414   96.7594  108.4276   40.7781 ]; % this isn't "true" distance, but has error
beac_pos = [
    100,100;
    50,50;
    50,100;
    100,50];
	
	for i = 1:size(x,2)
        for j = 1:size(y,2)
            for k = 1:size(beac_pos,1) %for each beacon
                z(j,i) = z(j,i) - normpdf(sqrt((x(i)-beac_pos(k,1))^2+(y(j)-beac_pos(k,2))^2), truedist(k), 14);
                z2(j,i) = z2(j,i) + 1/normpdf(sqrt((x(i)-beac_pos(k,1))^2+(y(j)-beac_pos(k,2))^2), truedist(k), 14);
            end
        end
	end
    
    [answ(1,:),resnorm(1)] = LSQNONLIN(@nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,truedist);
    [answ(2,:),resnorm(2)] = LSQNONLIN(@minus_gauss_nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,truedist);
    
	figure;
    
    contour(z2,200);
    hold on
    for i=1:size(beac_pos,1)
        plot(beac_pos(i,1),beac_pos(i,2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
        circle(truedist(i),beac_pos(i,1),beac_pos(i,2));
	end
    plot(truepos(1),truepos(2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b','MarkerSize',12);
    plot(answ(1,1),answ(1,2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',12);
    plot(answ(2,1),answ(2,2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','y','MarkerSize',12);
    plot(x0(1),x0(2),'-ro','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',12);
    
%   meshc(z);
    
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
    

% GOOD ONE where minus one doesn't work but L1 does
% x0 = [ 84.7581 , 145.3749 ];
% truepos = [120.4510,12.5822];
% truedist = [ 93.4414   96.7594  108.4276   40.7781 ]; % this isn't "true" distance, but has error
% beac_pos = [
%     100,100;
%     50,50;
%     50,100;
%     100,50];