function [ policy ] = MmfmGetExactPolicy( CDF, PDF, hazard, tdc, cDiscount, c, a, generator, discountGenerator,rates, policy_prev )
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
    transitionTerm = @(t) sum(arrayfun(@(j)discountGenerator(i,j).*max(c+tdc,MmfmRemainingTotalDiscountedCost( discountGenerator,tdc,c,a,CDF,PDF, policy_prev, j, t )),[1:(i-1),(i+1):numStates]));
    policy(i)=fzero(@(t) a.*hazard(t)+transitionTerm(t)+(c+tdc).*discountGenerator(i,i),min(policy_prev(i),1000));
end
end

