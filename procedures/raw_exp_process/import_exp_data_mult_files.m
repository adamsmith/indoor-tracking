expq_b1_1 = sortrows(csvread('c:\exp_data\expq_b1_1.txt'),1);
expq_b2_1 = sortrows(csvread('c:\exp_data\expq_b2_1.txt'),1);
expq_b3_1 = sortrows(csvread('c:\exp_data\expq_b3_1.txt'),1);
expq_b4_1 = sortrows(csvread('c:\exp_data\expq_b4_1.txt'),1);
% expq_b5_1 = sortrows(csvread('c:\exp_data\expq_b5_1.txt'),1);
expq_b6_1 = sortrows(csvread('c:\exp_data\expq_b6_1.txt'),1);

expq_1 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_1,1) - 3
        expq_1(1,i,:) = expq_b1_1(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_1,1) - 3
        expq_1(2,i,:) = expq_b2_1(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_1,1) - 3
        expq_1(3,i,:) = expq_b3_1(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_1,1) - 3
        expq_1(4,i,:) = expq_b4_1(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_1,1)
%         expq_1(5,i,:) = expq_b5_1(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_1,1) - 3
        expq_1(5,i,:) = expq_b6_1(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_1,1)
%     higher = 0;
%     for j=2:size(expq_1,2)-2
%         if expq_1(i,j,3) > 0 % dist > 0
%             if expq_1(i,j-1,2) - higher > 30000
%                 if (expq_1(i,j,2) < 15000) & (expq_1(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_1(i,j,2) = expq_1(i,j,2) + higher;
%         end
% 	end
% end


expq_b1_2 = sortrows(csvread('c:\exp_data\expq_b1_2.txt'),1);
expq_b2_2 = sortrows(csvread('c:\exp_data\expq_b2_2.txt'),1);
expq_b3_2 = sortrows(csvread('c:\exp_data\expq_b3_2.txt'),1);
expq_b4_2 = sortrows(csvread('c:\exp_data\expq_b4_2.txt'),1);
% expq_b5_2 = sortrows(csvread('c:\exp_data\expq_b5_2.txt'),1);
expq_b6_2 = sortrows(csvread('c:\exp_data\expq_b6_2.txt'),1);

expq_2 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_2,1) - 3
        expq_2(1,i,:) = expq_b1_2(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_2,1) - 3
        expq_2(2,i,:) = expq_b2_2(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_2,1) - 3
        expq_2(3,i,:) = expq_b3_2(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_2,1) - 3
        expq_2(4,i,:) = expq_b4_2(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_2,1)
%         expq_2(5,i,:) = expq_b5_2(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_2,1) - 3
        expq_2(5,i,:) = expq_b6_2(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_2,1)
%     higher = 0;
%     for j=2:size(expq_2,2)-2
%         if expq_2(i,j,3) > 0 % dist > 0
%             if expq_2(i,j-1,2) - higher > 30000
%                 if (expq_2(i,j,2) < 15000) & (expq_2(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_2(i,j,2) = expq_2(i,j,2) + higher;
%         end
% 	end
% end


expq_b1_3 = sortrows(csvread('c:\exp_data\expq_b1_3.txt'),1);
expq_b2_3 = sortrows(csvread('c:\exp_data\expq_b2_3.txt'),1);
expq_b3_3 = sortrows(csvread('c:\exp_data\expq_b3_3.txt'),1);
expq_b4_3 = sortrows(csvread('c:\exp_data\expq_b4_3.txt'),1);
% expq_b5_3 = sortrows(csvread('c:\exp_data\expq_b5_3.txt'),1);
expq_b6_3 = sortrows(csvread('c:\exp_data\expq_b6_3.txt'),1);

expq_3 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_3,1) - 3
        expq_3(1,i,:) = expq_b1_3(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_3,1) - 3
        expq_3(2,i,:) = expq_b2_3(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_3,1) - 3
        expq_3(3,i,:) = expq_b3_3(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_3,1) - 3
        expq_3(4,i,:) = expq_b4_3(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_3,1)
%         expq_3(5,i,:) = expq_b5_3(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_3,1) - 3
        expq_3(5,i,:) = expq_b6_3(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_3,1)
%     higher = 0;
%     for j=2:size(expq_3,2)-2
%         if expq_3(i,j,3) > 0 % dist > 0
%             if expq_3(i,j-1,2) - higher > 30000
%                 if (expq_3(i,j,2) < 15000) & (expq_3(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_3(i,j,2) = expq_3(i,j,2) + higher;
%         end
% 	end
% end



expq_b1_4 = sortrows(csvread('c:\exp_data\expq_b1_4.txt'),1);
expq_b2_4 = sortrows(csvread('c:\exp_data\expq_b2_4.txt'),1);
expq_b3_4 = sortrows(csvread('c:\exp_data\expq_b3_4.txt'),1);
expq_b4_4 = sortrows(csvread('c:\exp_data\expq_b4_4.txt'),1);
% expq_b5_4 = sortrows(csvread('c:\exp_data\expq_b5_4.txt'),1);
expq_b6_4 = sortrows(csvread('c:\exp_data\expq_b6_4.txt'),1);

expq_4 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_4,1) - 3
        expq_4(1,i,:) = expq_b1_4(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_4,1) - 3
        expq_4(2,i,:) = expq_b2_4(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_4,1) - 3
        expq_4(3,i,:) = expq_b3_4(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_4,1) - 3
        expq_4(4,i,:) = expq_b4_4(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_4,1)
%         expq_4(5,i,:) = expq_b5_4(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_4,1) - 3
        expq_4(5,i,:) = expq_b6_4(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_4,1)
%     higher = 0;
%     for j=2:size(expq_4,2)-2
%         if expq_4(i,j,3) > 0 % dist > 0
%             if expq_4(i,j-1,2) - higher > 30000
%                 if (expq_4(i,j,2) < 15000) & (expq_4(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_4(i,j,2) = expq_4(i,j,2) + higher;
%         end
% 	end
% end


expq_b1_5 = sortrows(csvread('c:\exp_data\expq_b1_5.txt'),1);
expq_b2_5 = sortrows(csvread('c:\exp_data\expq_b2_5.txt'),1);
expq_b3_5 = sortrows(csvread('c:\exp_data\expq_b3_5.txt'),1);
expq_b4_5 = sortrows(csvread('c:\exp_data\expq_b4_5.txt'),1);
% expq_b5_5 = sortrows(csvread('c:\exp_data\expq_b5_5.txt'),1);
expq_b6_5 = sortrows(csvread('c:\exp_data\expq_b6_5.txt'),1);

expq_5 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_5,1) - 3
        expq_5(1,i,:) = expq_b1_5(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_5,1) - 3
        expq_5(2,i,:) = expq_b2_5(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_5,1) - 3
        expq_5(3,i,:) = expq_b3_5(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_5,1) - 3
        expq_5(4,i,:) = expq_b4_5(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_5,1)
%         expq_5(5,i,:) = expq_b5_5(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_5,1) - 3
        expq_5(5,i,:) = expq_b6_5(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_5,1)
%     higher = 0;
%     for j=2:size(expq_5,2)-2
%         if expq_5(i,j,3) > 0 % dist > 0
%             if expq_5(i,j-1,2) - higher > 30000
%                 if (expq_5(i,j,2) < 15000) & (expq_5(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_5(i,j,2) = expq_5(i,j,2) + higher;
%         end
% 	end
% end


expq_b1_6 = sortrows(csvread('c:\exp_data\expq_b1_6.txt'),1);
expq_b2_6 = sortrows(csvread('c:\exp_data\expq_b2_6.txt'),1);
expq_b3_6 = sortrows(csvread('c:\exp_data\expq_b3_6.txt'),1);
expq_b4_6 = sortrows(csvread('c:\exp_data\expq_b4_6.txt'),1);
% expq_b5_6 = sortrows(csvread('c:\exp_data\expq_b5_6.txt'),1);
expq_b6_6 = sortrows(csvread('c:\exp_data\expq_b6_6.txt'),1);

expq_6 = zeros(5,30000,6);

counter=1;
for i=1:size(expq_b1_6,1) - 3
        expq_6(1,i,:) = expq_b1_6(i,:); counter = counter + 1;
end
for i=1:size(expq_b2_6,1) - 3
        expq_6(2,i,:) = expq_b2_6(i,:); counter = counter + 1;
end
for i=1:size(expq_b3_6,1) - 3
        expq_6(3,i,:) = expq_b3_6(i,:); counter = counter + 1;
end
for i=1:size(expq_b4_6,1) - 3
        expq_6(4,i,:) = expq_b4_6(i,:); counter = counter + 1;
end
% for i=1:size(expq_b5_6,1)
%         expq_6(5,i,:) = expq_b5_6(i,:); counter = counter + 1;
% end
for i=1:size(expq_b6_6,1) - 3
        expq_6(5,i,:) = expq_b6_6(i,:); counter = counter + 1;
end

% timer_higher
% for i=1:size(expq_6,1)
%     higher = 0;
%     for j=2:size(expq_6,2)-2
%         if expq_6(i,j,3) > 0 % dist > 0
%             if expq_6(i,j-1,2) - higher > 30000
%                 if (expq_6(i,j,2) < 15000) & (expq_6(i,j+1,2) < 15000)
%                     higher = higher + 65536;
%                 end
%             end
%             expq_6(i,j,2) = expq_6(i,j,2) + higher;
%         end
% 	end
% end




% 
% 
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:5
%     for j=1:30000
%         if expq_1(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_1(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_1 = tmp;
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:6
%     for j=1:30000
%         if expq_2(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_2(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_2 = tmp;
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:6
%     for j=1:30000
%         if expq_3(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_3(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_3 = tmp;
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:6
%     for j=1:30000
%         if expq_4(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_4(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_4 = tmp;
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:6
%     for j=1:30000
%         if expq_5(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_5(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_5 = tmp;
% 
% tmp = zeros(30000,6);
% counter = 1;
% for i=1:6
%     for j=1:30000
%         if expq_6(i,j,3) > 0 %dist > 0
%             tmp(counter,:) = expq_6(i,j,:);
%             counter = counter + 1;
%         end
%     end
% end
% expq_6 = tmp;
% clear tmp; clear counter;
% 
% 
% 
% 
% 
% myend = 1;
% for i=1:30000
%     if expq_1(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_1 = sortrows(expq_1(1:myend,:),2);
% 
% myend = 1;
% for i=1:30000
%     if expq_2(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_2 = sortrows(expq_2(1:myend,:),2);
% 
% myend = 1;
% for i=1:30000
%     if expq_3(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_3 = sortrows(expq_3(1:myend,:),2);
% 
% myend = 1;
% for i=1:30000
%     if expq_4(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_4 = sortrows(expq_4(1:myend,:),2);
% 
% myend = 1;
% for i=1:30000
%     if expq_5(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_5 = sortrows(expq_5(1:myend,:),2);
% 
% myend = 1;
% for i=1:30000
%     if expq_6(i,2) == 0
%         myend = i - 1;
%         break
%     end
% end
% expq_6 = sortrows(expq_6(1:myend,:),2);
% clear myend;
% 

% speed, beacon, record, [entries]

expq = zeros(6,5,30000,6);
expq(1,:,:,:) = expq_1;
expq(2,:,:,:) = expq_2;
expq(3,:,:,:) = expq_3;
expq(4,:,:,:) = expq_4;
expq(5,:,:,:) = expq_5;
expq(6,:,:,:) = expq_6;

tmp = zeros(6,5,30000,5);
for i=1:6
    for j=1:5
        for k=1:30000
            if expq(i,j,k,3) > 0 % dist > 0
                if expq(i,j,k,1) > 200
                    a=1;
                end
                expq(i,j,k,2) = expq(i,j,k,2) + expq(i,j,k,1) * 2^16;
            end
            tmp(i,j,k,:) = [expq(i,j,k,2),expq(i,j,k,4),expq(i,j,k,3),expq(i,j,k,6),expq(i,j,k,5)];
            if tmp(i,j,k,1) > 4e+9
                a=1;
            end
        end
    end
end
expq = tmp;

mtmp = zeros(6,30000,5);
for i=1:6
    tmp = zeros(30000,5);
	counter = 1;
	for j=1:5
        for k=1:30000
            if expq(i,j,k,3) > 0 %dist > 0
                tmp(counter,:) = expq(i,j,k,:);
                counter = counter + 1;
            end
        end
	end
    myend = 1;
	for j=1:30000
        if tmp(j,3) == 0
            myend = j - 1;
            break
        end
	end
	tmp = sortrows(tmp(1:myend,:),1);
    for j=1:size(tmp,1)
        mtmp(i,j,:) = tmp(j,:);
    end
end
expq = mtmp;