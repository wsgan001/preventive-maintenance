function [ ed ] = ExpectedDiscount( J,lambda,cDiscount )
%EXPECTEDDISCOUNT Calculates the expected discount factor corresponding to
%the simple jump problem by successive approximation.
eds=ones(1000,1);
for i=2:length(eds)
    eds(i) = exp(-(cDiscount+lambda*(1-eds(i-1)))*J);
end
ed=eds(1000);
end

