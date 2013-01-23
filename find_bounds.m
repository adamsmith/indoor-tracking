function bounds = find_bounds(x)
% input (x) should be ax5, where a is the number of records

bounds = zeros(1,3); % return 1x3
for j=1:size(x,1)
    if x(j,2) > 0
        bounds(1) = j;
        break
    end
end
for j=bounds(1)+1:size(x,1)
    if x(j,1) == 0
        bounds(3) = j-1;
        break
    end
end
if bounds(3) == 0 % we didn't find trailing zero-rows
    bounds(3) = size(x,1);
end
for j=bounds(1)+1:size(x,1)
    if x(j,2) == x(bounds(3),2)
        bounds(2) = j-1;
        break
    end
end
