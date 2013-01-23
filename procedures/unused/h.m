function ret = h(x,c,m)
% h(x), returns (m x 1) matrix of theoretical distances to beacons
% based on x, a (3 x 1) matrix containing the listener coordinates
ret = zeros(m,1);
for i=1:m
    ret(i) = getrealdist(i,c,x);
end