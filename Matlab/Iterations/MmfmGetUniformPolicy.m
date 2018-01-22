function [ policy ] = MmfmGetUniformPolicy(  CDF, PDF, hazard, tdc, cDiscount, c, a, generator, discountGenerator,rates, policy_prev )
%MMFMGETUNIFORMPOLICY Finds the uniform control limit that minimizes the
%tdc in this iteration.
unit=eye(length(rates));
unit = unit(1,:);
policy=fzero(@(t) a.*hazard(t)+unit*discountGenerator*ones(length(rates),1).*(c+tdc),min(99,policy_prev(1)));
if isnan(policy)
    policy = Inf;
end
policy = max(1e-10,policy).*ones(length(rates),1);
end