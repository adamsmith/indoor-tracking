function x = percentile(y,frac)

y=squeeze(y);

if size(y) == 1
    y = y';
end

tmp = sort(y,1);

x = tmp(floor(size(y,1)*frac)+1);