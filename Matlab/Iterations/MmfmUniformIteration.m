function [ policy_convergence, v_convergence ] = MmfmUniformIteration( generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, v_init, policy_init, numIterations )
%MMFMEXACTITERATION Summary of this function goes here
%   Detailed explanation goes here
[jumpDiscounts, discountGenerator]=FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount);
hazard = @(t)  PDF(t)/(1-CDF(t));
numStates = length(rates);

    function [policy_next, v_next] =  UniformIterate(policy_prev, v_prev)
       policy_next = MmfmGetUniformPolicy( CDF, PDF, hazard, v_prev, cDiscount, c, a, generator, discountGenerator,rates, policy_prev );
       v_next =  (c+a+v_prev)*integral(@(x) PDF(x).*MmfmExpectedDiscount( discountGenerator, Inf(numStates,1), x, 1, 1:numStates ),0,policy_next(1)) + (c+v_prev)*(1-CDF(policy_next(1)))*MmfmExpectedDiscount( discountGenerator, Inf(numStates,1), policy_next(1), 1, 1:numStates );
       %MmfmTotalDiscountedCost( discountGenerator,v_prev,c,a,CDF,PDF, policy_next );
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
   [policy_temp,v_temp] = UniformIterate(policy_convergence(:,i),v_convergence(i));
   policy_convergence(:,i+1) = policy_temp;
   v_convergence(i+1) = v_temp;
end

end

