function y = move(list,ds,bound)
% input current position, direction of travel, length to travel, and
% boundary (scalar; assume room is same size in each direction)
% output new real position

newcompute = 1;
while newcompute == 1
    dirmag = mag(list(4:6));
    if dirmag == 0
        newcompute = 0;
        y = list(1:3);
        newdir = dir;
    else
        dirmag = ds / dirmag;
        newcompute = 0;
        for i=4:6
            list(i) = list(i)*dirmag; %preserves "direction" component
        end
        y = list(1:3) + list(4:6);
        for i=1:3
            if (abs(y(i)) > bound) & (newcompute == 0)
                newcompute = 1;
                for j=4:6
                    if j==i+3
                        list(j)=list(j)*-1;
                    else
                        list(j)=rand-.5;
                    end
                end
            end
        end
    end
end
y = [y list(4:6)];