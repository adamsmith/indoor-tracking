function x = filter(y,frac)
% filter out top (1-frac) of vector

mymax = max(y) * frac;
x = zeros(1,1);
xcnt = 1;

for i=1:max(size(y))
    if y(i) < mymax
        x(xcnt) = y(i);
        xcnt=xcnt+1;
    end
end