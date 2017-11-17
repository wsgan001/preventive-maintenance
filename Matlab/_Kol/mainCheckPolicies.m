

startWithNewDistribution = false;
cp = 2;
cc = 50;

close all

if (startWithNewDistribution)
    [dist] = getRandomDistribution(50);
    save('dist', 'dist');
else
    load('dist', 'dist');
end

%figure
%plot(dist.Hazard)

EQ = sum(dist.p.*(0:dist.K-1));

[mu, costcurve] = getOptimalControlLimitForAverageCost(dist, cp, cc);

%figure
%plot(costcurve)





mu