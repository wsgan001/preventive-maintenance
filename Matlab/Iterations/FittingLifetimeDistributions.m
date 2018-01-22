% For fitting a distribution over the lifetime data

% needs lifetimes array
wblFit=fitdist(lifetimes,'Weibull');
gammaFit=fitdist(lifetimes,'Gamma');
logNormalFit=fitdist(lifetimes,'Lognormal');
birnbaumFit=fitdist(lifetimes,'BirnbaumSaunders');
inverseGaussianFit=fitdist(lifetimes,'InverseGaussian');
logLogFit=fitdist(lifetimes,'Loglogistic');
burrFit=fitdist(lifetimes,'Burr');
plot(pts,PDF,pts,gammaFit.pdf(pts),pts,logNormalFit.pdf(pts));
legend('Observed','Gamma','Log-Normal');
xlabel('Lifetime (d)');
ylabel('Probability density');