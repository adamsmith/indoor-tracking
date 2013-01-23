% DEFINE CONSTANTS, NOT PARAMETERS THAT CAN CHANGE
% These numbers are arbitrary except no duplicates are allowed within groups

% Run mode
batchmode = 1;
simmode = 2;

% Define model types, more specifically how a model should ACT given certain inputs
% Do nothing <=> 0 (default)
model_Pmodel = 1;
model_LinLS = 2;
model_PVmodel_standard = 3;
model_min_kalman = 4;
model_minP_kalman = 7;
model_multi = 8;
model_multi2 = 9;
model_bls = 5;
model_real = 6;

% Error types
error_gaussian = 1;
error_gaussian_with_outliers = 3;
error_real = 2;
error_real2 = 4;
error_exp = 5;

% Data types
type_active_beacon = 1;
type_passive_beacon = 2;