generator = [-3, 1, 2; 1, -2, 1; 0,1,-1];
fluidJumps = [0,0,5;0,0,0;0,0,0];
fluidRates = [1;2;3];

numExperiments = 10000;
dataNoJumps = zeros(numExperiments,1);
dataWithJumps = zeros(numExperiments,1);
for i=1:numExperiments
    dataNoJumps(i) = MmfmLifetime(generator,fluidRates, zeros(3));
    dataWithJumps(i) = MmfmLifetime(generator,fluidRates, fluidJumps);
end

[hazardNoJumps, ptsNoJumps] = HazardRatesFromLifetimes(dataNoJumps);
[hazardWithJumps, ptsWithJumps] = HazardRatesFromLifetimes(dataWithJumps);

figure
plot(ptsWithJumps, hazardWithJumps,ptsNoJumps,hazardNoJumps);
legend('With Jumps','Without Jumps')
xlabel('Time')
ylabel('Hazard Rate')

