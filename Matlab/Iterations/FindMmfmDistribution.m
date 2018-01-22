% Empirically finds the lifetime distribution of a MMFM with a certain
% initial fluid distribution.

generator = [-0.1,0.1;0.1,-0.1];
fluidJumps = [0,2;2,0];
fluidRates = [1;1];

numExperiments = 10000;
dataWithJumps = zeros(numExperiments,1);
dataWeibullInitial = zeros(numExperiments,1);
for i=1:numExperiments
    dataWithJumps(i) = MmfmLifetime(generator,fluidRates, fluidJumps,fluidJumps(1,2));
    dataWeibullInitial(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2));
end

[hazardWithJumps,pdfWithJumps,cdfWithJumps] = HazardRatesFromLifetimes(dataWithJumps);
[hazardWeibull,pdfWeibull,cdfWeibull] = HazardRatesFromLifetimes(dataWeibullInitial);


empericalED = sum(arrayfun(@(t) exp(-discount*t),dataWithJumps))/numExperiments;

%figure
plot((30:1:150),hazardWeibull(30:1:150));
legend('Weibull Initial')
xlabel('Time')
ylabel('Hazard Rate')

