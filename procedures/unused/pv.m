% PV model

% Time interval
dT = 1;
% # of beacons
m = 5;

% Define arbitrary system noise covariance matrix
Q = [1,0,0;0,1,0;0,0,1];

% Define beacons
c = rand(m,3);

% Define real listener position
p = [0,0,0];

function dist = getranddist(m)
% Returns new "reading" w/ 10% error for beacon 'm'
dist = getrealdist(m) * (rand/5-.1);

function dist = getrealdist(m)
% Returns real distance to beacon 'm'
dist = sqrt((c(m,1)-p(1))^2+(c(m,2)-p(2))^2+(c(m,3)-p(3))^2);


function [x,y,z] = initpos(c,d)
% Finds good initial guess based on four distances
% c is (m x 3) and d is (m x 1)
