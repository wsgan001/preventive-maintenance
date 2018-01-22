function [ tdc, ec, ed ] = MmfmSimulateRemainingTdc(generator, rates, jumps, c, a, cDiscount, CDF, l0, startingState, policy)
%MMFMSIMULATEREMAININGTDC Computes the remaining tdc by simulation.

numSimulations=2000;

% Condition on the fluid level being larger than l0
newCDF = @(t) (CDF(l0+t)-CDF(l0))/(1-CDF(l0));
    function [fluid] =  generateFluid()
        r=rand();
        % fzero instead of inversing the CDF.
        fluid = fzero(@(t) r-newCDF(t),l0);
    end

% Update policy
newPolicy = max(0,policy-l0);

eds=1:numSimulations;
costs=1:numSimulations;
for simulation=1:numSimulations
    [lifetime,repairedInState]=MmfmLifetime(generator,rates,jumps, generateFluid(), newPolicy, startingState);
    eds(simulation)=exp(-cDiscount*lifetime);
    costs(simulation)=c*eds(simulation);
    if repairedInState<0
        costs(simulation)=costs(simulation)+a*eds(simulation);
    end
end

ed=mean(eds);
ec=mean(costs);
tdc=ec/(1-ed);
end

