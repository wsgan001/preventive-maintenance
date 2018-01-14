function [ tdc ] = MmfmRemainingTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy, state, fluid )
%MMFMREMAININGTOTALDISCOUNTEDCOST Summary of this function goes here
%   Detailed explanation goes here

% update PDF, CDF and policy
conditionedPDF = @(t) PDF(t+fluid)/(1-CDF(fluid));
conditionedCDF = @(t) (CDF(t+fluid)-CDF(fluid))/(1-CDF(fluid));
remainingPolicy = policy-fluid;

% For the rest, the computation is similar, except for the fact that some
% control limits might already have been reached, but MmfmExpectedDiscount
% returns zero then.

% Discounts for failing runs
failDiscounts=integral(@(x) conditionedPDF(x).*MmfmExpectedDiscountNotRepaired(discountGenerator,remainingPolicy,x,state),0,max(0,max(remainingPolicy)));

if failDiscounts<0
   disp('?'); 
end

% Discounts from being in a state when the control limit is reached.
repairDiscounts = sum(arrayfun(@(p,i) (1-conditionedCDF(p)).*max(0,MmfmExpectedDiscount(discountGenerator,remainingPolicy,p,state,i)),remainingPolicy,transpose([1:length(remainingPolicy)])));

if repairDiscounts<0
   disp('?'); 
end

% Discounts from moving to a state where the control limit is already
% passed.
repairDiscounts = repairDiscounts + integral(@(q) (1-conditionedCDF(q)).*GetDiscountedRepairRate(discountGenerator,remainingPolicy,q,state),min(remainingPolicy),max(remainingPolicy));

if repairDiscounts<0
   disp('?'); 
end

% Add them up
if isnan(repairDiscounts)
    tdc=(c+a+V).*failDiscounts;
else
    tdc = (c+a+V).*failDiscounts + (c+V).*repairDiscounts;
end
end

