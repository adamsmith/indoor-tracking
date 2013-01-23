last_time = cl_1a(1,1);
run = 0;
run_i = 0;
for  i=2:size(cl_1a,1)
    if run == 1
        if cl_1a(i,1) ~= last_time
            for j=1:(i-run_i-1)
                cl_1a(j+run_i,1) = last_time + j*floor(((cl_1a(i,1) - cl_1a(run_i-1,1)) / (i-run_i+1)));
            end
            run = 0;
        end
    else
        if cl_1a(i,1) == last_time
            run = 1;
            run_i = i-1;
        end
	end
    last_time = cl_1a(i,1);
end

last_time = cl_2a(1,1);
run = 0;
run_i = 0;
for i=2:size(cl_2a,1)
    if run == 1
        if cl_2a(i,1) ~= last_time
            for j=1:(i-run_i-1)
                cl_2a(j+run_i,1) = last_time + j*floor(((cl_2a(i,1) - cl_2a(run_i-1,1)) / (i-run_i+1)));
            end
            run = 0;
        end
    else
        if cl_2a(i,1) == last_time
            run = 1;
            run_i = i-1;
        end
	end
    last_time = cl_2a(i,1);
end

last_time = cl_3a(1,1);
run = 0;
run_i = 0;
for i=2:size(cl_3a,1)
    if run == 1
        if cl_3a(i,1) ~= last_time
            for j=1:(i-run_i-1)
                cl_3a(j+run_i,1) = last_time + j*floor(((cl_3a(i,1) - cl_3a(run_i-1,1)) / (i-run_i+1)));
            end
            run = 0;
        end
    else
        if cl_3a(i,1) == last_time
            run = 1;
            run_i = i-1;
        end
	end
    last_time = cl_3a(i,1);
end