for i=1:12
    for j=1:15231
        if sensor(i,j)==11
            if sensor(i,j+1)==198
                a=sensor(i,j-3:j+3);
                a
                i
            end
        end
    end
end