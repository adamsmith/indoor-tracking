%this is minus one norm

function err = minus_nonlin_err2d(x,nonlin_err_points,nonlin_err_dists)
if size(nonlin_err_points,1) ~= max(size(nonlin_err_dists))
    error('Number of points not equal to number of distances!');
end
for i=1:size(nonlin_err_points,1)
    theo_dist = sqrt((nonlin_err_points(i,1)-x(1))^2+(nonlin_err_points(i,2)-x(2))^2);
    err(i) = 1 / normpdf(theo_dist, nonlin_err_dists(i), 14);
end