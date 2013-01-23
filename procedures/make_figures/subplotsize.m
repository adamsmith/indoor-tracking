function [x,y] = subplotsize(inp)
x=1;
y=1;
while x*y<inp
    if x==y
        y=y+1;
    else
        x=x+1;
    end
end
if (x==1) & (y==2) %special case to make things pretty
    x=2;
    y=1;
end