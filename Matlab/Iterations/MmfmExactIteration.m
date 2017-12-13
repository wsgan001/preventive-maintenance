function [ policy_convergence, v_convergence ] = MmfmExactIteration( generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, v_init, policy_init, numIterations )
%MMFMEXACTITERATION Summary of this function goes here
%   Detailed explanation goes here
[jumpDiscounts, discountGenerator]=FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount);
hazard = @(t)  PDF(t)/(1-CDF(t));
numStates = length(rates);

    function [policy_next, v_next] =  ExactIterate(policy_prev, v_prev)
       policy_next = MmfmGetExactPolicy( CDF, PDF, hazard, v_prev, cDiscount, c, a, generator, discountGenerator,rates, policy_prev );
       v_next =  MmfmTotalDiscountedCost( discountGenerator,v_prev,c,a,CDF,PDF, policy_next );
    end

if ~exist('numIterations', 'var')
    numIterations = 100;
end

% Initialize
policy_convergence = zeros(numStates,1+numIterations);
v_convergence = zeros(1,1+numIterations);
policy_convergence(:,1) = policy_init;
v_convergence(1) = v_init;

% And iterate
for i=1:numIterations
   [policy_temp,v_temp] = ExactIterate(policy_convergence(:,i),v_convergence(i));
   policy_convergence(:,i+1) = policy_temp;
   v_convergence(i+1) = v_temp;
end

end

