graphdatacount = sum(graphs(1,:));
eigcount = 1;
dims = size(graphs);
eigdata = 0;
for i=2:xmaxcnt
    for j=1:dims(2)
        if graphs(i,j) == 1
            graphdatacount = graphdatacount+1;
            if j == 8
                for k=1:graphsize
                    eigdata(eigcount,k) = graphdata(graphdatacount,k);
                end
                eigcount = eigcount+1;
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
plot(eigdata');