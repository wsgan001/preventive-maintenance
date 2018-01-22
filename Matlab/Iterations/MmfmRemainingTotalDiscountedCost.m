function [ tdc ] = MmfmRemainingTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy, state, fluid )
%MMFMREMAININGTOTALDISCOUNTEDCOST Computes the expected remaining
%discounted cost using policy if the process is in CTMC-state state with
%L0 given by fluid.

% update PDF, CDF and policy
conditionedPDF = @(t) PDF(t+fluid)/(1-CDF(fluid));
conditionedCDF = @(t) (CDF(t+fluid)-CDF(fluid))/(1-CDF(fluid));

% policies may never be negative
remainingPolicy = max(policy-fluid,0);

numStates=length(remainingPolicy);

% Discounts for failing runs
failDiscounts=integral(@(x) conditionedPDF(x).*MmfmExpectedDiscountNotRepaired(discountGenerator,remainingPolicy,x,state),0,max(remainingPolicy));

% Discounts from being in a state when the control limit is reached.
%repairDiscounts = sum(arrayfun(@(p,i) (1-conditionedCDF(p)).*MmfmExpectedDiscount(discountGenerator,remainingPolicy,p,state,i),remainingPolicy,transpose(1:length(remainingPolicy))));
repairDiscounts = 0;
for i=1:numStates
    if ~isinf(remainingPolicy(i))
        repairDiscounts = repairDiscounts+(1-conditionedCDF(remainingPolicy(i))).*MmfmExpectedDiscount(discountGenerator,remainingPolicy,remainingPolicy(i),state,i);
    end
end


% Discounts from moving to a state where the control limit is already
% passed.
if ~isinf(min(remainingPolicy(i)))
    repairDiscounts = repairDiscounts + integral(@(q) (1-conditionedCDF(q)).*GetDiscountedRepairRate(discountGenerator,remainingPolicy,q,state),min(remainingPolicy),max(remainingPolicy));
end

% Add them up
tdc = (c+a+V).*failDiscounts + (c+V).*repairDiscounts;
end

