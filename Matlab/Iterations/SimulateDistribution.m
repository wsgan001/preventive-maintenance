function [ hazard, PDF, CDF ] = SimulateDistribution( generator, fluidRates, fluidJumps, CDF, numExperiments )
%SIMULATEDISTRIBUTION Get the hazard function, pdf and cdf of a mmfm with
%given generator, rates, jumps and cdf of initial fluid level. The
%distribution is found by performing numExperiments simulations.

% Generate random numbers between 0 and 1
R=rand(numExperiments, 1);

% Invert CDF
xx = linspace( 0, 1000, 10000 );
yy = CDF(xx);
[yy,xx]=RemoveDuplicates(yy,xx);
inv = griddedInterpolant(yy, xx);

% Generate lifetimes
initialLevels = inv(R);

% Simulate
lifetimes = zeros(numExperiments,1);
for i=1:numExperiments
    lifetimes(i) = MmfmLifetime(generator,fluidRates, fluidJumps,initialLevels(i));
end

% Find distribution
[hazard, PDF, CDF] = HazardRatesFromLifetimes(lifetimes);
end

