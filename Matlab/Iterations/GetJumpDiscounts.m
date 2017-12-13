function [ jumpDiscounts ] = GetJumpDiscounts( discountGenerator, jumpQuantities )
%GETJUMPDISCOUNTS Calculates iDkm=Dkm(Jim)
%   Detailed explanation goes here
numStates = size(discountGenerator,1);
jumpDiscounts = zeros(numStates,numStates,numStates);
for i=1:numStates
    for k=1:numStates
        iD=expm(discountGenerator.*jumpQuantities(i,k));
        for m=1:numStates
            jumpDiscounts(i,k,m)=iD(k,m);
        end
    end
end
end

