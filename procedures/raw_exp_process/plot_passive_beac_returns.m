for i=1:1%size(exph,1)
    input_series = i;
    rawdata = squeeze(exph(input_series,:,:));
    data_type = type_passive_beacon;
    
	process_expt
    
	figure; cdfplot(exp_passive_cnt);
end