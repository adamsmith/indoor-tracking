x(1,:) = [rand(1,3)*100-50,rand(1,3)-0.5];


for i=1:m
    myrand = rand;
	for mycnt=1:sensor_count
        if myrand < sensor_probability(mycnt)
            mysensor = mycnt;
            break
        end
	end
	mysample = sensor(mysensor,floor(rand*sensor_size(mysensor))+1); %pick a sample from the samples we have for 'mysensor'
	z(1,i) = mysample * (getrealdist(i,c,x(1,1:3)) / sensor_mode(mysensor)); %return realdist with some error seeded by the sample error
    for j=2:xmaxcnt
        z(j,i) = z(1,i);
    end
end


for i=1:xmaxcnt
    for j=1:bufsize(i)
        zage(i,j) = j;
    end
    for j=bufsize(i)+1:m
        zage(i,j) = 0;
    end
end


[x(2,1),x(2,2),x(2,3)] = initpos(c,z(1,:),1,2,3,4);

for i=3:18
    if xvisible(i) > 0
        x(i,:)=x(2,:);
    end
end