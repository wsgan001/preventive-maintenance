function [ expr ] = TraceExpression( totalTimeInState, numJumps, lambda, k )
%TRACELIKELIHOOD Let f be the density of a weibull distributed variable,
% this computes f'(x)/f(x) for x initial fluid level.
initial = FindInitialLevel(totalTimeInState, numJumps);
expr = @(rates,jumpQuantities) (k-1)/initial(rates,jumpQuantities)-k.*initial(rates,jumpQuantities).^(k-1)/(lambda.^k);
end

