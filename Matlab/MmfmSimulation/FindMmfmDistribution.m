%generator = [-3, 1, 2; 1, -2, 1; 0,1,-1];
%fluidJumps = [0,0,5;0,0,0;0,0,0];
%fluidRates = [1;2;3];
%controlLimits = [150;150;120];
generator = [-0.1,0.1;0.1,-0.1];
fluidJumps = [0,2;2,0];
fluidRates = [1;1];

numExperiments = 10000;
%dataNoJumps = zeros(numExperiments,1);
dataWithJumps = zeros(numExperiments,1);
dataWithJumps2 = zeros(numExperiments,1);
%dataWeibullInitial = zeros(numExperiments,1);
%dataWeibullControlLimits = zeros(numExperiments,1);
for i=1:numExperiments
    %dataNoJumps(i) = MmfmLifetime(generator,fluidRates, zeros(3));
    dataWithJumps(i) = MmfmLifetime(generator,fluidRates, fluidJumps,fluidJumps(1,2));
    dataWithJumps2(i) = MmfmLifetime(generator,fluidRates, fluidJumps,2*fluidJumps(1,2));
    %dataWeibullInitial(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2));
    %dataWeibullControlLimits(i) = MmfmLifetime(generator,fluidRates,fluidJumps, wblrnd(100,2),controlLimits);
end

%[hazardNoJumps, ptsNoJumps] = HazardRatesFromLifetimes(dataNoJumps);
%[hazardWithJumps, ptsWithJumps] = HazardRatesFromLifetimes(dataWithJumps);
%[hazardWeibullInitial, ptsWeibullInitial] = HazardRatesFromLifetimes(dataWeibullInitial);
%[hazardWeibullControlLimits, ptsWeibullControlLimits] = HazardRatesFromLifetimes(dataWeibullControlLimits);
empericalED = sum(arrayfun(@(t) exp(-discount*t),dataWithJumps))/numExperiments
empericalED2 = sum(arrayfun(@(t) exp(-discount*t),dataWithJumps2))/numExperiments;
sqrt(empericalED2)
%plot(ptsWithJumps, hazardWithJumps,ptsNoJumps,hazardNoJumps, ptsWeibullInitial, hazardWeibullInitial, ptsWeibullControlLimits, hazardWeibullControlLimits);
theoreticalED = (generator(1,2)+discount)*exp(-(generator(1,2)+discount)*fluidJumps(1,2))/(discount+generator(1,2)*exp(-(generator(1,2)+discount)*fluidJumps(1,2)))

%figure
%plot(ptsWithJumps, hazardWithJumps,ptsNoJumps,hazardNoJumps, ptsWeibullInitial, hazardWeibullInitial, ptsWeibullControlLimits, hazardWeibullControlLimits);
%legend('With Jumps','Without Jumps', 'Weibull Initial', 'Weibull with control limits')
%xlabel('Time')
%ylabel('Hazard Rate')

