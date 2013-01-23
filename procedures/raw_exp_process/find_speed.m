speed = zeros(6,1);
for i=1:6
    dist = meta_single_exp_data(i,metabounds(1,i,2),2) * (circum / counter_max);
    time = (meta_single_exp_data(i,metabounds(1,i,2)) - meta_single_exp_data(i,metabounds(1,i,1)) )*256/8000000;
    speed(i) = dist / time;
end