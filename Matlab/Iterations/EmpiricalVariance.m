function [ ev ] = EmpiricalVariance( mmfm )
%EMPERICALVARIANCE Summary of this function goes here
%   Detailed explanation goes here
global numExperiments averageInitialLevel;
ev=sum((InitialLevels(mmfm)-averageInitialLevel).^2)/numExperiments;

end

