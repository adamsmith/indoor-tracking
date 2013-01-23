%this is one norm

function [err,J] = nonlin_err(x,nonlin_err_points,nonlin_err_dists)
if size(nonlin_err_points,1) ~= max(size(nonlin_err_dists))
    error('Number of points not equal to number of distances!');
end
for i=1:size(nonlin_err_points,1)
    theo_dist = sqrt((nonlin_err_points(i,1)-x(1))^2+(nonlin_err_points(i,2)-x(2))^2+(nonlin_err_points(i,3)-x(3))^2);
    err(i) = abs(nonlin_err_dists(i) - theo_dist);
    if nargout > 1   % Two output arguments
        for j=1:3
            J(i,j) = -1*((theo_dist-nonlin_err_dists(i))/abs((theo_dist-nonlin_err_dists(i))))*(nonlin_err_points(i,j)-x(j))/theo_dist;     % Jacobian of the function evaluated at x
        end
	end
end