function [jumpDiscounts,discountGenerator] = FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount)

numStates=length(rates);

% We start with iDkm = I(k==m)
jumpDiscounts=zeros(numStates,numStates,numStates);
for i=1:numStates
    jumpDiscounts(i,:,:)=eye(numStates);
end

% Compute successive approximations.
discountGenerator=eye(numStates);
for i=1:10
   discountGenerator =  GetDiscountGenerator( cDiscount, rates,generator,jumpDiscounts );
   jumpDiscounts = GetJumpDiscounts( discountGenerator, jumpQuantities );
end

% To compare results with the simple two-state jump case. Note that since in
% that simple case it does not matter in which state you end, we need to
% sum over the two states in which you can end.
% ed=ExpectedDiscount(jumpQuantities(1,2),generator(1,2),cDiscount);
% newEstimate = jumpDiscounts(1,2,2)+jumpDiscounts(1,2,1);

end