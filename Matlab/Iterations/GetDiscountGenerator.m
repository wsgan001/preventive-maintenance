function [ discountGenerator ] = GetDiscountGenerator( cDiscount, rates,generator,jumpDiscounts )
%GETDISCOUNTITERATOR Summary of this function goes here
%   Detailed explanation goes here
numStates = length(rates);
discountGenerator = zeros(numStates);
for i=1:numStates
    for m=1:numStates
        discountGenerator(i,m)=generator(i,:)*transpose(jumpDiscounts(i,:,m))/rates(i);
    end
end
discountGenerator=discountGenerator-cDiscount.*eye(numStates)/diag(rates);
end

