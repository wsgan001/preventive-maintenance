cdf = @(t)wblcdf(t,2,2);
a=100;
c=1;
discount=exp(-0.5);
timeStep = 0.1;
numSteps = 100;
numIterations=50;
result = ValueIteration(cdf, timeStep, discount,numIterations,c,a,numSteps);