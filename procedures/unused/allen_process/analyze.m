realcoord = [427,183,0;
             0,122,0;
             244,244,0;
             61,61,0;
             61,488,0;
             0,305,0;
             427,305,0;
             366,61,0;
             244,366,0;
             366,427,0;
             122,366,0;
             183,0,0];
listcoord = [122,254,183];

% for i=1:12
%     for j=1:3
%         realcoord(i,j) = realcoord(i,j) / 100;
%     end
% end
% for i=1:3
%     listcoord(i) = listcoord(i) / 100;
% end

realdist = zeros(12,1);
modedist = zeros(12,1);
% modeavgdist = zeros(12,1);
for i=1:12
    realdist(i) = sqrt((realcoord(i,1)-listcoord(1))^2+(realcoord(i,2)-listcoord(2))^2+(realcoord(i,2)-listcoord(2))^2);
    modedist(i) = (sensor_mode(i)-35) * 2.2809917;
end










lowerb=1;
upperb=12;

outliers_ratio = zeros(upperb-lowerb+1,1);

[subplotx,subploty] = subplotsize(upperb-lowerb+1);
for i=lowerb:upperb
    sensor2 = zeros(1,1);
    counter=1;
    counter2=0;
    for j=1:14503
        if sensor(i,j) > 0
            if (sensor(i,j) > sensor_mode(i) - 14) & (sensor(i,j) < sensor_mode(i) + 14)
                sensor2(counter) = sensor(i,j);
                counter = counter+1;
            else
                counter2=counter2+1;
            end
        end
    end
    
    modeavgdist(i) = (mean(sensor2)-35) * 2.2809917;
    
%     outliers_ratio(i-lowerb+1) = counter2/counter;
%     
%     vars(i) = var(sensor2);
%     
%     [n,x] = hist(sensor2,1000);
%     figure(1)%i-lowerb+1)
%     subplot(subplotx,subploty,i-lowerb+1);
%     bar(x,n)
    
%     disp(['Beacon ' num2str(i)])
%     disp(['Mean: ' num2str(mean(sensor2))])
%     disp(['Geo mean: ' num2str(geomean(sensor2))])
%     disp(['Std dev: ' num2str(std(sensor2))])
%     disp(['IQR: ' num2str(iqr(sensor2))])
%     disp(['MAD: ' num2str(mad(sensor2))])
%     disp(['Variance: ' num2str(var(sensor2))])
%     disp([' '])
end
% disp(['Average variance after removal of "outliers:"  ' num2str(mean(vars))])
% disp(['Average ratio of "outliers" to non-outliers:"  ' num2str(mean(outliers_ratio))])





error1 = zeros(12,1);
error2 = zeros(12,1);
for i=1:12
    error1(i) = (realdist(i) - modedist(i));
    error2(i) = (realdist(i) - modeavgdist(i));
end

figure
plot(1:12,realdist,1:12,modedist,1:12,modeavgdist)
figure
plot(1:12,error1,1:12,error2)







% NOTE: You can use 'normfit' and just square the sigma it returns to get the same results of the 'var' call above.  For example, try:

% [mu,sigma,muci,sigmaci] = normfit(sensor2)