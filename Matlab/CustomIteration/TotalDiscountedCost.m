function [ tdc ] = TotalDiscountedCost( c,a,discount,density )
tdc = @(limit) (integral(density, limit, Inf(1)).*exp(-discount.*limit)+integral(@(t) density(t).*exp(-discount.*t),0,limit).*(c+a))/(1-integral(density, limit, Inf(1)).*exp(-discount.*limit)-integral(@(t) density(t).*exp(-discount.*t),0,limit));
end
