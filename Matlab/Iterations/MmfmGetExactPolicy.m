function [ policy ] = MmfmGetExactPolicy( CDF, PDF, hazard, tdc, cDiscount, c, a, generator, discountGenerator,rates, policy_prev, v_remain )
%MMFMGETEXACTPOLICY Summary of this function goes here
%   Detailed explanation goes here
if ~exist('policy_prev','var')
    policy_prev = ones(length(rates),1);
end

numStates = length(rates);

policy = zeros(numStates,1);
% Go through the states and calculate for each state the optimal control
% limit for that state, with fixed control limits for other states and tdc.
for i=1:numStates
    transitionTerm = discountGenerator(i,:)*v_remain(:,i);
    policy(i)=fzero(@(t) a.*hazard(t)+transitionTerm, min(policy_prev(i),1000));
    if isnan(policy(i))
        policy(i)=Inf;
    end
end
end

