function [ tdc ] = MmfmTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy )
%MMFMTOTALDISCOUNTEDCOST Summary of this function goes here
%   Detailed explanation goes here

% Just pass the call to the general function
tdc = MmfmRemainingTotalDiscountedCost( discountGenerator,V,c,a,CDF,PDF, policy, 1, 0 );
end

