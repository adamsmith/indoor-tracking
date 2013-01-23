% %... (load up 'yo' with expdata(2:4))
% 
% for i=1:4273
%     yo(i,1) = mod(yo(i,1),344);
% end
% 
% for i=1:4273
%     yo_pts(i,:) = pdata(yo(i,1));
% end
% 
% for i=1:4273
%     myind = find(FNid==yo(i,3));
%     yo_expdist(i) = sqrt((yo_pts(i,1)-c(myind,1))^2+(yo_pts(i,2)-c(myind,2))^2+(yo_pts(i,3)-c(myind,3))^2);
% end
% 
% for i=1:4273
%     yo_diff(i) = yo_expdist(i) - yo(i,2);
% end
% 
% cdfplot(yo_diff);
% 
% myind=1;
% for i=1:4273
%     if yo_diff(i) < sqrt(10^4)
%         yo_no_outers(myind) = yo_diff(i);
%         yo_no_outers_expdist(myind) = yo_expdist(i);
%         myind = myind + 1;
%     end
% end
% 
% cdfplot(yo_yo_outers);
% 
% yo_ordered_err = sortrows([yo_expdist(:),yo_diff(:)]);
% figure; plot(yo_ordered_err(:,1),yo_ordered_err(:,2));

% ints=275:5:475;
% bins = zeros(max(size(ints)),5000);
% pointer = ones(max(size(ints)),1);
% for i=1:4273
%     if yo_expdist(i) > 275 & yo_expdist(i) < 475
%         for j=1:41
%             if yo_expdist(i) < ints(j)
%                 bins(j,pointer(j)) = yo_diff(i);
%                 pointer(j) = pointer(j)+1;
%             end
%         end
%     end
% end
% meds = zeros(max(size(ints)),1);
% for i=2:max(size(ints))
%     meds(i) = cov(bins(i,1:pointer(i)-1));
% end
% plot(ints(2:max(size(ints))),meds(2:max(size(ints))));

ints=275:5:475;
bins = zeros(max(size(ints)),5000);
pointer = ones(max(size(ints)),1);
for i=1:max(size(yo_no_outers))
    if yo_no_outers_expdist(i) > 275 & yo_no_outers_expdist(i) < 475
        for j=1:41
            if yo_no_outers_expdist(i) < ints(j)
                bins(j,pointer(j)) = yo_no_outers(i);
                pointer(j) = pointer(j)+1;
            end
        end
    end
end
meds = zeros(max(size(ints)),1);
for i=2:max(size(ints))
    meds(i) = cov(bins(i,1:pointer(i)-1));
end
figure;plot(ints(2:max(size(ints))),meds(2:max(size(ints))));