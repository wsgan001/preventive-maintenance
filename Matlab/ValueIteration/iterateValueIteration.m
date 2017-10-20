function [newValueFunction] = iterateValueIteration(cdf,timeStep,discount,c,a,oldValueFunction)
repairCost = c+discount*oldValueFunction(2);
newValueFunction = zeros('like',oldValueFunction);
for i=1:length(oldValueFunction)
    if i==1
       newValueFunction(1) = c+a+discount.*oldValueFunction(2);
    else
        fail = failProbability(i,timeStep,cdf);
        waitCost = discount.*(fail.*(a+repairCost)+(1-fail).*oldValueFunction(min(i+1,length(oldValueFunction))));
        newValueFunction(i) = min(repairCost,waitCost);
    end
end
end