reldata = zeros(graphcnt,graphsize);
means = zeros(graphcnt,1);

for j=1:graphcnt
    for k=2:graphsize
        reldata(j,k) = graphdata(j,k)/sum(graphdata(:,k));
    end
    means(j) = mean(reldata(j,:));
end