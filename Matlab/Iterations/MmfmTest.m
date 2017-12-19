% MMFM
generator = [-1,1;1,-1];%[-2,1,1;1,-1,0;0,2,-2];%[-1,1;1,-1];
rates = [2;1];%[2,1,1];%[1;1];
jumpQuantities = [0,0.25;0.25,0];%[0,0,0.4;0,0,0;0,0.8,0];

% Other parameters
c=1;
a=100;
cDiscount=1;
numStates = length(rates);

% Find jump discounts and discountGenerator
[jumpDiscounts, discountGenerator]=FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount);

% Initial distribution
shape = 2;
scale = 10;
PDF = @(t) wblpdf(t,scale,shape);
CDF = @(t) wblcdf(t,scale,shape);
hazard = @(t)  PDF(t)/(1-CDF(t));

% For comparison with the two-state solution
twoStateCDF = @(t) CDF(rates(1)*t);
twoStatePDF = @(t) rates(1).*PDF(rates(1)*t);
twoStateHazard = @(t) rates(1).*hazard(rates(1)*t);


%[ x_convergence,v_convergence ] = TwoStateJumpIteration( 1,0,c,a,cDiscount,generator(1,2),jumpQuantities(1,2),twoStatePDF,twoStateCDF,twoStateHazard,100 );
%twoStatePolicy = x_convergence(100);
%twoStateCost = v_convergence(100);

% Comparison with 'blind' solution
[eHazard,ePDF,eCDF]=SimulateDistribution(generator, rates, jumpQuantities, CDF, 1000);
[customX, customV] = CustomIteration(1,0,c,a,cDiscount,ePDF,eCDF,eHazard,100);

%result = MmfmTotalDiscountedCost( discountGenerator,twoStateCost,c,a,CDF,PDF, [twoStatePolicy;twoStatePolicy] )
%MmfmExpectedDiscount(discountGenerator,[twoStatePolicy;twoStatePolicy],twoStatePolicy)

% Cost for no repair and no terminal cost
%noRepairCost=integral(@(t) PDF(t).*exp(-(cDiscount+generator(1,2).*(1-ExpectedDiscount(jumpQuantities(1,2),generator(1,2),cDiscount))).*t),0,Inf).*(c+a)
%MmfmTotalDiscountedCost( discountGenerator,0,c,a,CDF,PDF, [Inf;Inf] )

[simplePolicies, simpleCosts]=MmfmSimpleIteration(generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, 0, ones(numStates,1));
simplePolicies(:,100), simpleCosts(100)

[uniformPolicies, uniformCosts]=MmfmUniformIteration( generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, 0, ones(numStates,1) );
uniformPolicies(:,100), uniformCosts(100)
[exactPolicies, exactCosts]=MmfmExactIteration( generator, rates, jumpQuantities, PDF, CDF, c, a, cDiscount, 0, ones(numStates,1), 20 );
exactPolicies(:,20), exactCosts(20)