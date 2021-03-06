function [ policy_convergence, v_convergence ] = MmfmSimpleIteration( generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, v_init, policy_init, numIterations )
%MMFMSIMPLEITERATION Finds the heuristic policy by assuming no jump will
%occur before the next failure.
[jumpDiscounts, discountGenerator]=FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount);
hazard = @(t)  PDF(t)/(1-CDF(t));
numStates = length(rates);

    function [policy_next, v_next] =  SimpleIterate(policy_prev, v_prev)
       policy_next = MmfmGetSimplePolicy( hazard, v_prev, cDiscount, c, a, rates, policy_prev );
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
   [policy_temp,v_temp] = SimpleIterate(policy_convergence(:,i),v_convergence(i));
   policy_convergence(:,i+1) = policy_temp;
   v_convergence(i+1) = v_temp;
end
end

