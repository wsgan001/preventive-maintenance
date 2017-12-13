function [ tdc ] = MmfmTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy )
%MMFMTOTALDISCOUNTEDCOST Summary of this function goes here
%   Detailed explanation goes here

% Just pass the call to the general function
tdc = MmfmRemainingTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy, 1, 0 );
return;

% OLD CODE

% Discounts for failing runs
failDiscounts=integral(@(x) PDF(x).*MmfmExpectedDiscountNotRepaired(discountGenerator,policy,x,1),0,max(policy));


% Discounts from being in a state when the control limit is reached.
repairDiscounts = sum(arrayfun(@(p,i) (1-CDF(p)).*MmfmExpectedDiscount(discountGenerator,policy,p,1,i),policy,transpose([1:length(policy)])));

% Discounts from moving to a state where the control limit is already
% passed.
repairDiscounts = repairDiscounts + integral(@(q) (1-CDF(q)).*GetDiscountedRepairRate(discountGenerator,policy,q),min(policy),max(policy));

% Add them up
if isnan(repairDiscounts)
    tdc=(c+a+V).*failDiscounts;
else
    tdc = (c+a+V).*failDiscounts + (c+V).*repairDiscounts;
end
end

