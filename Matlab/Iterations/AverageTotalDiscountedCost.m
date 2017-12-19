function [ cost ] = AverageTotalDiscountedCost( data, discountExponent, repairCost, correctiveCost )
%AVERAGETOTALDISCOUNTEDCOST Computes the average total discounted cost of the policy
%based on experimental data
%   Data should contain the lifetime and end state of each run.
%   preventiveCost is the cost that is paid when the machine is repaired preventively.
%   correctiveCost is the cost that is paid when the machine is repaired correctively.


totalDiscountPerRun = 0;
totalDiscountFailingRun = 0;
numFailingRuns = 0;
for i=1:length(data)
    totalDiscountPerRun = totalDiscountPerRun + exp(-discountExponent.*data(i,1));
    if data(i,2)<0
        numFailingRuns = numFailingRuns +1;
        totalDiscountFailingRun = totalDiscountFailingRun + exp(-discountExponent.*data(i,1));
    end
end
% Prevent division by 0
if numFailingRuns < 1
    numFailingRuns = 1;
end
cost = (repairCost + correctiveCost.*(totalDiscountFailingRun/numFailingRuns)) / (1-totalDiscountPerRun/length(data));
end

