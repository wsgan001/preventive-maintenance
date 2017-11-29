generator = [-3, 1, 2; 1, -2, 1; 0,1,-1];
fluidJumps = [0,0,5;0,0,0;0,0,0];
fluidRates = [1;2;3];
controlLimits = [150;150;120];

numExperiments = 10000;
dataNoJumps = zeros(numExperiments,1);
dataWithJumps = zeros(numExperiments,1);
dataWeibullInitial = zeros(numExperiments,1);
dataWeibullControlLimits = zeros(numExperiments,1);
for i=1:numExperiments
    dataNoJumps(i) = MmfmLifetime(generator,fluidRates, zeros(3));
    dataWithJumps(i) = MmfmLifetime(generator,fluidRates, fluidJumps);
    dataWeibullInitial(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2));
    dataWeibullControlLimits(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2),controlLimits);
end

[hazardNoJumps, ptsNoJumps] = HazardRatesFromLifetimes(dataNoJumps);
[hazardWithJumps, ptsWithJumps] = HazardRatesFromLifetimes(dataWithJumps);
[hazardWeibullInitial, ptsWeibullInitial] = HazardRatesFromLifetimes(dataWeibullInitial);
[hazardWeibullControlLimits, ptsWeibullControlLimits] = HazardRatesFromLifetimes(dataWeibullControlLimits);

figure
plot(ptsWithJumps, hazardWithJumps,ptsNoJumps,hazardNoJumps, ptsWeibullInitial, hazardWeibullInitial, ptsWeibullControlLimits, hazardWeibullControlLimits);
legend('With Jumps','Without Jumps', 'Weibull Initial', 'Weibull with control limits')
xlabel('Time')
ylabel('Hazard Rate')

