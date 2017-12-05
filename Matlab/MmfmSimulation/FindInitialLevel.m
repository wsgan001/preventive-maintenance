function [ initialFluidLevel ] = FindInitialLevel( totalTimeInState, numJumps )
% Returns a function that gives the initial amount of fluid according to
% the amount of time spent in each state and the number of jumps.
initialFluidLevel = @(rates, jumpQuantities) totalTimeInState*rates-ones(1,length(totalTimeInState))*(numJumps.*jumpQuantities)*ones(length(totalTimeInState),1);
end

