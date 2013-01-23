function circle(radius,cx,cy)
hold on
yo=0:pi/500:2*pi;
x = cos(yo) * radius + cx;
y = sin(yo) * radius + cy;
plot(x,y);