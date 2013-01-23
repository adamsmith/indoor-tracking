% overwrite counter values
newcnter = [95;122;126;129;134;153;158;162;166;170;193;232;256+15;256+35;256+40;256+44;256+47;256+50;256+54;256+71;256+75;256+78;256+80;256+83;256+86];

for i=1:size(expf_p,1)
    for j=1:size(expf_p,2)
        if expf_p(i,j,3) > 0
            expf_p(i,j,2) = newcnter(i);
        end
    end
end