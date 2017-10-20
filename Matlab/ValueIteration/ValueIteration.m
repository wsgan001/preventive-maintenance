function [valueFunction] = ValueIteration(cdf, timeStep, discount,numIterations,c,a,numSteps)
valueFunction = zeros(numSteps,1 );
count = 0;
while count<numIterations
    valueFunction = iterateValueIteration(cdf,timeStep,discount,c,a,valueFunction);
    count = count+1;
end
end


