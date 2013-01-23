function y = popular(x)
% returns most popular scalar in x, up to 2 dimensions
% if there's a tie then just return one

ballot = zeros(1,2);
ballot_cnt = 1;
for i=1:size(x,1)
    for j=1:size(x,2)
        ballot_pointer = find(ballot(:,1) == x(i,j));
        if isempty(ballot_pointer)
            ballot(ballot_cnt,:) = [x(i,j),1];
            ballot_cnt = ballot_cnt+1;
        else
            ballot(ballot_pointer,2) = ballot(ballot_pointer,2) + 1;
        end
    end
end

y = ballot(find(ballot(:,2) == max(ballot(:,2))),1);