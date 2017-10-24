function [lifetime] = MmfmLifetime(generator, fluidRates, fluidJumps, maxLifetime)
% Generates a positive random variable corresponding to the lifetime of a
% Markov Modulated Fluid Model.
% generator should be a square matrix with negative values on the diagonal
% and nonnegative values outside of the diagonal. All rows should sum to
% zero. fluidRates should be a vector of positive values. fluidJumps should 
% be a square matrix with zeros on the diagonal and positive values
% elsewhere. fluidJumps(i,j) should be the fluid jump when transitioning
% from state i to state j. maxLifetime is an optional argument for the
% maximum lifetime that we will simulate. Its default is Inf.
    function [nextState] = simulateNextState(lastState)
       r = rand(1);
       sumProbs = 0;
       for i=1:length(generator)
           if i~=lastState
               sumProbs = sumProbs -generator(lastState,i)/generator(lastState,lastState);
               if sumProbs>=r
                   nextState = i;
                   return;
               end
           end
       end
    end

if ~exist('maxLifetime','var')
   maxLifetime = Inf(1); 
end

lifetime = 0;
fluidLevel = 100;
currentState = 1;
while fluidLevel > 0 && lifetime < maxLifetime
    transitionTime = exprnd(-generator(currentState,currentState));
    if fluidLevel < transitionTime*fluidRates(currentState)
        lifetime = lifetime + fluidLevel / fluidRates(currentState);
        fluidLevel = 0;
    else
        lifetime = lifetime + transitionTime;
        nextState = simulateNextState(currentState);
        fluidLevel = fluidLevel - transitionTime*fluidRates(currentState)...
            + fluidJumps(currentState,nextState);
        currentState = nextState;
    end
end
end