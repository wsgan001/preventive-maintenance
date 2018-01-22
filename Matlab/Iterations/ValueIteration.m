function [x_convergence,v_convergence] = ValueIteration(cdf, timeStep, discount,numIterations,c,a,initValue, x_init)
% VALUEITERATION Solves the age-based problem using value iteration.    

    function [limit,newValueFunction] = valueIterate(oldValueFunction)
    % Performs one value iteration
        function [time] = timeForStep(step)
            time = timeStep.*(step-1);
        end
        function[failProbability] = failProbability(step)
            failProbability = (cdf(timeForStep(step+1))-cdf(timeForStep(step)))/(1-cdf(timeForStep(step)));
        end
    limit = Inf(1);
    repairCost = c+discount*oldValueFunction(2);
    newValueFunction = zeros('like',oldValueFunction);
    for i=1:length(oldValueFunction)
        if i==1
           newValueFunction(1) = c+a+discount.*oldValueFunction(2);
        else
            fail = failProbability(i);
            waitCost = discount.*(fail.*(a+repairCost)+(1-fail).*oldValueFunction(min(i+1,length(oldValueFunction))));
            if (repairCost < waitCost)
                newValueFunction(i) = repairCost;
                limit = min(timeForStep(i),limit);
            else
                newValueFunction(i) = waitCost;
            end
            newValueFunction(i) = min(repairCost,waitCost);
        end
    end
    end
count = 0;
x_convergence = zeros(1,1+numIterations);
x_convergence(1) = x_init;
v_convergence = zeros(1,1+numIterations);
v_convergence(1) = initValue(2);
valueFunction = initValue;
for j=1:numIterations
    [limit,valueFunction] = valueIterate(valueFunction);
    count = count+1;
    v_convergence(j+1) = valueFunction(2);
    x_convergence(j+1) = min(limit,timeStep.*(length(valueFunction)-1));
end
end


