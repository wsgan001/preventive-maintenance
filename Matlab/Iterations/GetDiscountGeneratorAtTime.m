function [ discountGeneratorAtTime ] = GetDiscountGeneratorAtTime( discountGenerator, policy, t )
%GETDISCOUNTGENERATORATTIME Summary of this function goes here
%   Detailed explanation goes here
numStates = length(policy);
discountGeneratorAtTime=zeros(numStates);
for i=1:numStates
    if policy(i)>t
        discountGeneratorAtTime(i,:)=discountGenerator(i,:);
    end
end
end

