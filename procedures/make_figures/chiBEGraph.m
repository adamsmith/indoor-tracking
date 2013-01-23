graphdatacount = 0;
chicount = 2;
dims = size(graphs);
maxchimax = 0;
chidata=0;
for k=1:graphsize
    chidata(1,k) = graphdata(1,k);
end
for i=1:xmaxcnt
    for j=1:dims(2)
        if graphs(i,j) == 1
            graphdatacount = graphdatacount+1;
            if j == 9
                for k=1:graphsize
                    chidata(chicount,k) = graphdata(graphdatacount,k)-chisuspect(i);
                end
                chicount = chicount+1;
                if chireject(i) > maxchimax
                    maxchimax = chisuspect(i);
                end
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
plot(chidata');%,'EraseMode','xor');
axis([0 graphsize -1*maxchimax 1000])
line([0 graphsize],[0 0],'Color','r')