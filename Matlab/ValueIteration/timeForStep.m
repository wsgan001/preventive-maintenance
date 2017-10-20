

function [time] = timeForStep(step,timeStep)
time = timeStep.*(step-1);
end