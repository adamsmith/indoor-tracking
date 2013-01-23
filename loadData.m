if error_type ~= error_exp
    error('Expecting exp error format');
end

if data_type == type_active_beacon
    load('C:\MATLAB\work\exp1_data\active_beac\active_beac.mat');
elseif data_type == type_passive_beacon
    load('C:\MATLAB\work\exp1_data\passive_beac\passive_beac.mat');
else
    error('Unknown data_type');
end

if enable_hybrid > 0
    load('C:\MATLAB\work\exp1_data\hybrid_data\hybrid_data.mat');
end

rawdata = squeeze(exp_in(input_series,:,:));

process_expt