
function[failProbability] = failProbability(step,timeStep,cdf)
failProbability = (cdf(timeForStep(step+1,timeStep))-cdf(timeForStep(step,timeStep)))/(1-cdf(timeForStep(step,timeStep)));
end