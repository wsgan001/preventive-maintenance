function [ MLE ] = FluidRateMLE( data, state, lambda, k, numExperiments )
%FLUIDRATEMLE Summary of this function goes here
%   Detailed explanation goes here
expressions = cell(numExperiments,1);
dummy = zeros(numExperiments,1);
for i=1:numExperiments
    expressions{i}=TraceExpression(data{i,1},data{i,2},lambda,k);
    dummy(i)=i;
end
MLE=@(rates,jumpQuantities) sum(arrayfun(@(n) data{n,1}(state).*expressions{n,1}(rates,jumpQuantities),dummy));
end

