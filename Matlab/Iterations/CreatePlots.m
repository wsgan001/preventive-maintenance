% Creates the plots used in the report.
% First import TraceLifetimes.csv as a table TraceLifetimes
addpath('../matlab2tikz/src/');
lifetimes = table2array(TraceLifetimes)./(1000*3600*24); % From ms to days
MIN=min(lifetimes);
MAX=max(lifetimes);
[ECDF,pts]=ecdf(lifetimes);
PDF=ksdensity(lifetimes,pts);
hazard = PDF./(1-ECDF);
plot(pts,ECDF)
xlabel('Lifetime (d)');
ylabel('Probability');
matlab2tikz('lifetimesECDF.tex', 'width', '\fwidth' )
plot(pts,PDF)
xlabel('Lifetime (d)');
ylabel('Probability density');
matlab2tikz('lifetimesPDF.tex', 'width', '\fwidth' )
plot(pts,hazard)
xlabel('Lifetime (d)');
ylabel('Hazard rate');
matlab2tikz('lifetimesHazard.tex', 'width', '\fwidth' )

% Plot fits
%wblFit=fitdist(lifetimes,'Weibull');
gammaFit=fitdist(lifetimes,'Gamma');
logNormalFit=fitdist(lifetimes,'Lognormal');
%birnbaumFit=fitdist(lifetimes,'BirnbaumSaunders');
%inverseGaussianFit=fitdist(lifetimes,'InverseGaussian');
%logLogFit=fitdist(lifetimes,'Loglogistic');
%burrFit=fitdist(lifetimes,'Burr');
plot(pts,PDF,pts,gammaFit.pdf(pts),pts,logNormalFit.pdf(pts));
legend('Observed','Gamma','Log-Normal');
xlabel('Lifetime (d)');
ylabel('Probability density');
matlab2tikz('lifetimesFits.tex', 'width', '\fwidth' )

% Plots for transition times
% We add a random value between 0 and 1 because the transition times seem
% to be rounded down and this causes a huge spike for the ksdensity.
transitionTimes=3600*table2array(TransitionTimes(1:2000,[15,20]))+rand(2000,2);
[density1,pts]=ksdensity(transitionTimes(:,1),'Support','positive');
density2=ksdensity(transitionTimes(:,2),pts,'Support','positive');
expFit=fitdist(transitionTimes(:,1),'Exponential');
plot(pts,density1,pts,expFit.pdf(pts));
legend('Observed','Exponential fit');
xlabel('Transition time (s)');
ylabel('Probability density');
matlab2tikz('transitionTimesFitGood.tex', 'width', '\fwidth' )
expFit2=fitdist(transitionTimes(:,2),'Exponential');
plot(pts,density2,pts,expFit2.pdf(pts));
legend('Observed','Exponential fit');
xlabel('Transition time (s)');
ylabel('Probability density');
ylim([0 0.001])
xlim([0 2000])
matlab2tikz('transitionTimesFitBad.tex', 'width', '\fwidth' )

ps=1:36;
hs=1:36;
tT=3600*table2array(TransitionTimes(1:2000,1:20))+rand(2000,20);
for i=1:20
    [h(i),p(i)]=adtest(tT(:,i),'Distribution','exp')
end

% Plot for Q,L0,Lc for chapter 4
pts = [0 1.5 1.51 3.5 3.51 7.5 11];
Q = [5 3.5 6.5 4.5 7.5 3.5 0];
L0 = [0 1.5 1.5 1.5 1.5 1.5 5];
Lc = [0 0 3 1 4 0 0];
plot(pts,Q,pts,L0,pts,Lc);
xlabel('Time');
ylabel('Fluid');
legend('Fluid','Lower','LowerC');
matlab2tikz('MmfmExample.tex', 'width', '\fwidth' )

% Plot for Q,L0,Lc for chapter 5
pts = [0 1 1.01 1.5 2  3 5];
Q = [5 4 7 5 4 2 0];
L0 = [0 1 1 1 1 3 5];
Lc = [0 0 3 1 0 0 0];
plot(pts,Q,pts,L0,pts,Lc);
xlabel('Time');
ylabel('Fluid');
legend('Fluid','Lower','LowerC');
matlab2tikz('MmfmExample.tex', 'width', '\fwidth' )