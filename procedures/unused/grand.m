function [y1,y2] = grand()
x1 = 2.0 * rand - 1.0;
x2 = 2.0 * rand - 1.0;
w = x1 * x1 + x2 * x2;
while w>=1.0
    x1 = 2.0 * rand - 1.0;
    x2 = 2.0 * rand - 1.0;
    w = x1 * x1 + x2 * x2;
end

w = sqrt( (-2.0 * log( w ) ) / w );
y1 = x1 * w;
y2 = x2 * w;