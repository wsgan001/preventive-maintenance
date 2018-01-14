function [ policy ] = MmfmGetUniformPolicy(  CDF, PDF, hazard, tdc, cDiscount, c, a, generator, discountGenerator,rates, policy_prev )
%MMFMGETUNIFORMPOLICY Summary of this function goes here
%   Detailed explanation goes here
unit=eye(length(rates));
unit = unit(1,:);
if unit*discountGenerator*ones(length(rates),1)>0
    disp('?');
end
policy=fzero(@(t) a.*hazard(t)+unit*discountGenerator*ones(length(rates),1).*(c+tdc),max(1e-10,min(100,policy_prev(1))));
policy = max(1e-10,policy).*ones(length(rates),1);
end