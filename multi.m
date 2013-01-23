function x = multi(multi_weights,multi_x)

global enable_hybrid hybridused 

% if (enable_hybrid > 0) & (hybridused > 0)
%     x = multi_x(find(multi_x(:,4) > 0),:); % return PV model answer
% end
% 


%final model-conditioned error covariance can be computed but we don't have a use for it at this point

x = zeros(6,1);
multi_num = size(multi_weights,1);
multi_ps = zeros(multi_num,1);

if sum(multi_weights) == 0 % if all did outlier rejection (f_cov == 0) then just output first one
    x = multi_x(1,:);
    return
end

for i=1:multi_num
    multi_ps(i) = multi_weights(i) / sum(multi_weights);
end

for i=1:6
    for j=1:multi_num
        x(i) = x(i) + multi_ps(j) * multi_x(j,i);
    end
end

x = x';