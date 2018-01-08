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

% Try with censored data to maybe avoid the problem that the lifetimes are
% probably from two distributions.
%censoredLifetimes=transpose(min([transpose(lifetimes);6*ones(1,length(lifetimes))]));
%isCensored = censoredLifetimes>=6;
%censGammaFit=fitdist(censoredLifetimes,'Lognormal','Censoring',isCensored);