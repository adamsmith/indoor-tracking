% NE43-518: .0343 - 118.1147
% Stata, expn: 0.0360  -93.4406
% Stata, expp: 0.0332 -107.8962
% Stata, expq: 0.0368 -100.0910

form = [0.0368 -100.0910];

for i=1:size(expq,1)
    for j=1:size(expq,2)
        if expq(i,j,3) > 0
            expq(i,j,3) = polyval(form,expq(i,j,3));
        end
    end
end


% for i=1:size(expq,1)
%     for j=1:size(expq,3)
%         if expq(i,3,j) > 0
%             expq(i,3,j) = polyval(form,expq(i,3,j));
%         end
%     end
% end