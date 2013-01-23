expq_r0_1 = csvread('c:\exp_data\expq_r0_1.txt');
expq_r0_2 = csvread('c:\exp_data\expq_r0_2.txt');
expq_r0_3 = csvread('c:\exp_data\expq_r0_3.txt');
expq_r0_4 = csvread('c:\exp_data\expq_r0_4.txt');
expq_r0_5 = csvread('c:\exp_data\expq_r0_5.txt');
expq_r0_6 = csvread('c:\exp_data\expq_r0_6.txt');

expq_r1_1 = csvread('c:\exp_data\expq_r1_1.txt');
expq_r1_2 = csvread('c:\exp_data\expq_r1_2.txt');
expq_r1_3 = csvread('c:\exp_data\expq_r1_3.txt');
expq_r1_4 = csvread('c:\exp_data\expq_r1_4.txt');
expq_r1_5 = csvread('c:\exp_data\expq_r1_5.txt');
expq_r1_6 = csvread('c:\exp_data\expq_r1_6.txt');

expq_r2_1 = csvread('c:\exp_data\expq_r2_1.txt');
expq_r2_2 = csvread('c:\exp_data\expq_r2_2.txt');
expq_r2_3 = csvread('c:\exp_data\expq_r2_3.txt');
expq_r2_4 = csvread('c:\exp_data\expq_r2_4.txt');
expq_r2_5 = csvread('c:\exp_data\expq_r2_5.txt');
expq_r2_6 = csvread('c:\exp_data\expq_r2_6.txt');

expq_r3_1 = csvread('c:\exp_data\expq_r3_1.txt');
expq_r3_2 = csvread('c:\exp_data\expq_r3_2.txt');
expq_r3_3 = csvread('c:\exp_data\expq_r3_3.txt');
expq_r3_4 = csvread('c:\exp_data\expq_r3_4.txt');
expq_r3_5 = csvread('c:\exp_data\expq_r3_5.txt');
expq_r3_6 = csvread('c:\exp_data\expq_r3_6.txt');

expq_r = zeros(4,10000,7);
counter = 1;
for i=1:size(expq_r0_1,1)
        expq_r(1,counter,:) = expq_r0_1(i,:); counter = counter + 1;
end
for i=1:size(expq_r0_2,1)
        expq_r(1,counter,:) = expq_r0_2(i,:); counter = counter + 1;
end
for i=1:size(expq_r0_3,1)
        expq_r(1,counter,:) = expq_r0_3(i,:); counter = counter + 1;
end
for i=1:size(expq_r0_4,1)
        expq_r(1,counter,:) = expq_r0_4(i,:); counter = counter + 1;
end
for i=1:size(expq_r0_5,1)
        expq_r(1,counter,:) = expq_r0_5(i,:); counter = counter + 1;
end
for i=1:size(expq_r0_6,1)
        expq_r(1,counter,:) = expq_r0_6(i,:); counter = counter + 1;
end


counter = 1;
for i=1:size(expq_r1_1,1)
        expq_r(2,counter,:) = expq_r1_1(i,:); counter = counter + 1;
end
for i=1:size(expq_r1_2,1)
        expq_r(2,counter,:) = expq_r1_2(i,:); counter = counter + 1;
end
for i=1:size(expq_r1_3,1)
        expq_r(2,counter,:) = expq_r1_3(i,:); counter = counter + 1;
end
for i=1:size(expq_r1_4,1)
        expq_r(2,counter,:) = expq_r1_4(i,:); counter = counter + 1;
end
for i=1:size(expq_r1_5,1)
        expq_r(2,counter,:) = expq_r1_5(i,:); counter = counter + 1;
end
for i=1:size(expq_r1_6,1)
        expq_r(2,counter,:) = expq_r1_6(i,:); counter = counter + 1;
end


counter = 1;
for i=1:size(expq_r2_1,1)
        expq_r(3,counter,:) = expq_r2_1(i,:); counter = counter + 1;
end
for i=1:size(expq_r2_2,1)
        expq_r(3,counter,:) = expq_r2_2(i,:); counter = counter + 1;

end
for i=1:size(expq_r2_3,1)
        expq_r(3,counter,:) = expq_r2_3(i,:); counter = counter + 1;
end
for i=1:size(expq_r2_4,1)
        expq_r(3,counter,:) = expq_r2_4(i,:); counter = counter + 1;
end
for i=1:size(expq_r2_5,1)
        expq_r(3,counter,:) = expq_r2_5(i,:); counter = counter + 1;
end
for i=1:size(expq_r2_6,1)
        expq_r(3,counter,:) = expq_r2_6(i,:); counter = counter + 1;
end


counter = 1;
for i=1:size(expq_r3_1,1)
        expq_r(4,counter,:) = expq_r3_1(i,:); counter = counter + 1;
end
for i=1:size(expq_r3_2,1)
        expq_r(4,counter,:) = expq_r3_2(i,:); counter = counter + 1;
end
for i=1:size(expq_r3_3,1)
        expq_r(4,counter,:) = expq_r3_3(i,:); counter = counter + 1;
end
for i=1:size(expq_r3_4,1)
        expq_r(4,counter,:) = expq_r3_4(i,:); counter = counter + 1;
end
for i=1:size(expq_r3_5,1)
        expq_r(4,counter,:) = expq_r3_5(i,:); counter = counter + 1;
end
for i=1:size(expq_r3_6,1)
        expq_r(4,counter,:) = expq_r3_6(i,:); counter = counter + 1;
end



for i=1:4
    for j=1:10000
        expq_r(i,j,4) = expq_r(i,j,7);
    end
end