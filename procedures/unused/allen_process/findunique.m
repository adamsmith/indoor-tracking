for i=1:12
    abc = trimvec(sensor(i,:));
    
    %DOESN'T WORK
    
    
    
    for j=1:10 % give it 1000 tries
        pick = min(abc);
        for k=1:12
            if k == i
                
            else
                abc2 = trimvec(sensor(k,:));
                found = 0;
                if findvec(abc2,pick) > 0
                    found = 1;
                    break
                end
            end
        end
        if found == 0
            disp(['found!' num2str(pick) ' in ' num2str(i)])
            break
        else
            abc(findvec(abc,pick)) = 10000;
        end
    end
end