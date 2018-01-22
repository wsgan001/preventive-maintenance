function [ policy ] = MmfmGetSimplePolicy( hazard, tdc, cDiscount, c, a, rates, generator, policy_prev )
%MMFMGETSIMPLEPOLICY Finds the control limits for the heuristic policy
% based on the assumption that no jumps will occur before the next failure. 
if ~exist('policy_prev','var')
    policy_prev = ones(length(rates),1);
end

policy = zeros(length(rates),1);
for i=1:length(rates)
    policy(i)=fzero(@(t) rates(i).*hazard(t)-(c+tdc).*cDiscount/a,min(policy_prev(i),1000));
end
end