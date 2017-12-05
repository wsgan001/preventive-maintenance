function [ ed ] = ExpectedDiscount( J,lambda,cDiscount )
%EXPECTEDDISCOUNT Summary of this function goes here
%   Detailed explanation goes here
eds=ones(1000,1);
for i=2:length(eds)
    eds(i) = exp(-(cDiscount+lambda*(1-eds(i-1)))*J);
end
ed=eds(1000);
end

