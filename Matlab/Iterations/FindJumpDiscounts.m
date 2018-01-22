function [jumpDiscounts,discountGenerator] = FindJumpDiscounts(generator, jumpQuantities, rates, cDiscount)
% FINDJUMPDISCOUNTS Computes the jump discounts and the discount generator
% matrix by successive approximation given problem parameters.
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

end