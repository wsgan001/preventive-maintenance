function [ ev ] = EmpiricalVariance( mmfm )
%EMPERICALVARIANCE Computes the empirical variance of the parameters given
%by mmfm.
global numExperiments averageInitialLevel;
ev=sum((InitialLevels(mmfm)-averageInitialLevel).^2)/numExperiments;
end

