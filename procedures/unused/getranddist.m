% function dist = getranddist(realdist,sensor_count)
% Returns new "reading" w/ 10% error (+/- 5%) for beacon 'm'

%dist = realdist + normrnd(0,1);


%choose one of our beacon data sets, weighted by the amount of samples we have for that one

myrand = rand;
for mycnt=1:sensor_count
    if myrand < sensor_probability(mycnt)
        mysensor = mycnt;
        break
    end
end
mysample = sensor(mysensor,floor(rand*sensor_size(mysensor))+1); %pick a sample from the samples we have for 'mysensor'
dist = mysample * (realdist / sensor_mode(mysensor)); %return realdist with some error seeded by the sample error