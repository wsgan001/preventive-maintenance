generator = [-1,1,0;0,-1,1;1,0,-1];
rates = [1;2;3];
jumps = [0,0,0;0,0,0;0.3,0,0];
c=1;
a=10;
cDiscount=1;
dist=makedist('Weibull','a',20/sqrt(pi),'b',2);
CDF=@(t) dist.cdf(t);
PDF=@(t) dist.pdf(t);
hazard = @(t) dist.pdf(t)./(1+1e-10-dist.cdf(t));
[jumpDiscounts, discountGenerator]=FindJumpDiscounts(generator, jumps, rates, cDiscount);
numStates=length(rates);

policy=[8;4;4.6];
fluid=6;
numSimulations=10000;
startingState=1;

lifetimes=1:numSimulations;
repairedIn=1:numSimulations;
ednrs=[];
ednr=0;
eds=1:numSimulations;
edHitCL=zeros(numStates,1);
edAfterCL=0;
probNotRepaired=0;
costs=1:numSimulations;
for i=1:numSimulations
    [lifetimes(i),repairedIn(i),path]=MmfmLifetime(generator, rates, jumps, fluid, policy, startingState, 1000);
    eds(i)=exp(-cDiscount*lifetimes(i));
    if repairedIn(i)<0
        costs(i)=exp(-cDiscount*lifetimes(i))*(c+a);
        ednrs=[ednrs exp(-cDiscount*lifetimes(i))];
        probNotRepaired=probNotRepaired+1/numSimulations;
        ednr=ednr+exp(-cDiscount*lifetimes(i))/numSimulations;
    else
        costs(i)=exp(-cDiscount*lifetimes(i))*c;
    end
end
[costDens, pts]=ksdensity(costs);
plot(pts,costDens);

mean(costs)/(1-mean(eds))

% Compare with numerical
theoreticalEdHitCL=arrayfun(@(s) MmfmExpectedDiscount( discountGenerator, policy+1e-10, policy(s), startingState, s ),1:3);
theoreticalEdnr= MmfmExpectedDiscountNotRepaired( discountGenerator, policy, fluid, startingState );
theoreticalEdAfterCL=integral(@(q) GetDiscountedRepairRate( discountGenerator,policy,q, startingState ),min(policy),max(policy));

%[dens,pts]=ksdensity(lifetimes);
%plot(pts,dens)