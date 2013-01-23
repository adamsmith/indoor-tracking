graphdatacount = sum(graphs(1,:));
errcount = 1;
dims = size(graphs);
errdata = 0;
for i=2:xmaxcnt
    for j=1:dims(2)
        if graphs(i,j) == 1
            graphdatacount = graphdatacount+1;
            if j == 1
                for k=1:graphsize
                    errdata(errcount,k) = graphdata(graphdatacount,k);
                end
                errcount = errcount+1;
            end
        end
    end
end
if subplotx > 0
    subplot(subplotx,subploty,subplotcounter);
    subplotcounter = subplotcounter + 1;
else
    figure
end
plot(errdata');