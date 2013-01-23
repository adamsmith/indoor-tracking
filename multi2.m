function x = multi2(multi_weights,multi_x)

%final model-conditioned error covariance can be computed but we don't have a use for it at this point

x = zeros(6,1);
multi_num = size(multi_weights,1);
multi_ps = zeros(multi_num,1);

if sum(multi_weights) == 0 % if all did outlier rejection (f_cov == 0) then just output first one
    x = multi_x(1,:);
    return
end

x = multi_x(find(multi_weights == max(multi_weights)),:);

% x = x';