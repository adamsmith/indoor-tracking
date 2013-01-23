circum = 0;
for i=1:size(pdata)-1
    circum = circum + sqrt((pdata(i,1)-pdata(i+1,1))^2+(pdata(i,2)-pdata(i+1,2))^2);
end
circum = circum + sqrt((pdata(max(size(pdata)),1)-pdata(1,1))^2+(pdata(max(size(pdata)),2)-pdata(1,2))^2);