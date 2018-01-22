function [ tdc ] = MmfmTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy )
%MMFMTOTALDISCOUNTEDCOST Computes the expected total discounted cost for
%the MMFM problem with the given policy.

% Just pass the call to the general function
tdc = MmfmRemainingTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy, 1, 0 );
end

