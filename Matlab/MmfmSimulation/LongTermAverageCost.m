function [ cost ] = LongTermAverageCost( data, repairCost, correctiveCost )
%LONGTERMAVERAGECOST Computes the long term average cost of the policy
%based on experimental data
%   Data should contain the lifetime and end state of each run.
%   preventiveCost is the cost that is paid when the machine is repaired preventively.
%   correctiveCost is the cost that is paid when the machine is repaired correctively.

totalRunLengths = 0;
totalCosts = 0;
for i=1:length(data)
    totalRunLengths = totalRunLengths + data(i,1);
    if data(i,2)<0
        totalCosts = totalCosts + repairCost + correctiveCost;
    else
        totalCosts = totalCosts + repairCost;
    end
end

cost = totalCosts / totalRunLengths;
end

