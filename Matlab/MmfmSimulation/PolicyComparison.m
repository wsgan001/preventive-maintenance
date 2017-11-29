generator = [-3, 1, 2; 1, -2, 1; 0,1,-1];
fluidJumps = [0,0,5;0,0,0;0,0,0];
fluidRates = [1;2;3];
controlLimits = [150;150;150];
numExperiments = 10000;

discountExponent=1;
repairCost = 1;
correctiveCost = 100;

data = zeros(numExperiments,2);
dataNoPreventive = zeros(numExperiments,2);
for i=1:numExperiments
    data(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2),controlLimits);
    dataNoPreventive(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2));
end

discountPreventive = AverageTotalDiscountedCost( data, discountExponent, repairCost, correctiveCost );
discountNoPreventive = AverageTotalDiscountedCost( dataNoPreventive, discountExponent, repairCost, correctiveCost );
avgPreventive = LongTermAverageCost( data, repairCost, correctiveCost );
avgNoPreventive = LongTermAverageCost( dataNoPreventive, repairCost, correctiveCost );