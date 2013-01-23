beac_pos = [
    100,100;
    50,50;
    50,100;
    100,50];

truepos = [120.4510,12.5822];
for i = 1:size(beac_pos,1)
    truedist(i) = sqrt((truepos(1)-beac_pos(i,1))^2 + (truepos(2)-beac_pos(i,2))^2);
end

runsmax = 100;

x0hist = zeros(runsmax,2);
measdisthist = zeros(runsmax,size(beac_pos,1));

for aa = 1:100
    x0 = [ rand*150 , rand*150 ];
    x0hist(aa,:) = x0;
    for i=1:size(beac_pos,1)
        measdist(i) = normrnd(truedist(i),14);
        measdisthist(aa,i) = measdist(i);
    end
    answ = zeros(2,2);
    resnorm = zeros(2,1);
    
    [answ(1,:),resnorm(1)] = LSQNONLIN(@nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,measdist);
    [answ(2,:),resnorm(2)] = LSQNONLIN(@minus_gauss_nonlin_err2d,x0,[],[],optimset('Display','off','Jacobian','off','MaxFunEvals',10^10),beac_pos,measdist);
    
    if abs(sqrt((answ(1,1)-truepos(1))^2+(answ(1,2)-truepos(2))^2) - sqrt((answ(2,1)-truepos(1))^2+(answ(2,2)-truepos(2))^2)) > 2
        disp(['DISPARITY: Norm one error is ' num2str(sqrt((answ(1,1)-truepos(1))^2+(answ(1,2)-truepos(2))^2)) ', norm minus one error is ' num2str(sqrt((answ(2,1)-truepos(1))^2+(answ(2,2)-truepos(2))^2))]);
    end
    
    disp([num2str(aa) ': Iterated, x0 = [' num2str(x0(1)) ' , ' num2str(x0(2)) ']']);
    
end


% screws up minus_gauss_... :
% x0 =
% 
%   120.4540   12.5822