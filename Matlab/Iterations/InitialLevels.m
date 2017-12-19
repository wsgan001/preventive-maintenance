function [ initialLevels ] = InitialLevels( mmfm )
%EMPERICALVARIANCE Summary of this function goes here
%   Detailed explanation goes here
global traceData numExperiments numStates;
initialLevels = zeros(length(traceData),1);

rates = Diagonal(mmfm);
jumpQuantities = mmfm-diag(rates);
for i=1:numExperiments
    initialLevels(i)=traceData{i,1}*rates-ones(1,numStates)*(traceData{i,2}.*jumpQuantities)*ones(numStates,1);
end

end

