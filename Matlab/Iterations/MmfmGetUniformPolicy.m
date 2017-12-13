function [ policy ] = MmfmGetUniformPolicy(  CDF, PDF, hazard, tdc, cDiscount, c, a, generator, discountGenerator,rates, policy_prev )
%MMFMGETUNIFORMPOLICY Summary of this function goes here
%   Detailed explanation goes here
unit=eye(length(rates));
unit = unit(1,:);
policy=fzero(@(t) a.*hazard(t)+unit*discountGenerator*ones(length(rates),1).*(c+tdc),policy_prev(1));
policy = policy.*ones(length(rates),1);
end

