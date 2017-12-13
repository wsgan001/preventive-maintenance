function [ drr ] = GetDiscountedRepairRate( discountGenerator,policy,fluid, from )
%GETDISCOUNTEDREPAIRRATE Summary of this function goes here
%   Detailed explanation goes here
if length(fluid)>1
    drr= arrayfun(@(q) GetDiscountedRepairRate( discountGenerator,policy,q ),fluid);
    return;
end

if ~exist('from','var')
    from=1;
end

numStates = length(policy);
drr=0;
for i=1:numStates
    if policy(i)>=fluid
        d=MmfmExpectedDiscount(discountGenerator,policy,fluid,from,i); 
        repairRates=0;
        for j=1:numStates
            if policy(j)<fluid
                repairRates = repairRates + discountGenerator(i,j);
            end
        end
        drr = drr + d.*repairRates;
    end
end
end

