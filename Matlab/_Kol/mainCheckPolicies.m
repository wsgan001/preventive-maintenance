

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

T = 1000000;
costcurve2 = costcurve*0;
for (muk = 1:length(costcurve))
    costcurve2(muk) = getTotalCostUntilTime(dist, muk, T, cp, cc, 0);
end

figure
hold on
plot(costcurve)
plot(costcurve2/T)
hold off






mu