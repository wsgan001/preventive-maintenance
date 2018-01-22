function [lifetime,repairedInState,path] = MmfmLifetime(generator, fluidRates, fluidJumps, fluidLevel, controlLimits, startingState, maxLifetime)
% Generates a positive random variable corresponding to the lifetime of a
% Markov Modulated Fluid Model.
% generator should be a square matrix with negative values on the diagonal
% and nonnegative values outside of the diagonal. All rows should sum to
% zero.
% fluidRates should be a vector of positive values. fluidJumps should 
% be a square matrix with zeros on the diagonal and positive values
% elsewhere. fluidJumps(i,j) should be the fluid jump when transitioning
% from state i to state j.
% maxLifetime is an optional argument for the maximum lifetime that we will
% simulate. Its default is Inf.
% controlLimits is an optional vector with positive control limits. Its
% default is infinity in each state.
% fluidLevel is the initial fluid level, i.e. the level at which the
% machine fails. Its default is 100.

    % Generates the next state randomly
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

% use startingState 1 if it is not set
if ~exist('startingState','var')
   startingState = 1; 
end

% use maxLifetime infinity if it is not set
if ~exist('maxLifetime','var')
   maxLifetime = Inf(1); 
end

% use controlLimits at infinity if it is not set
if ~exist('controlLimits','var')
   controlLimits = Inf(length(fluidRates)); 
end

% Use default value of 100 for initial fluid level
if ~exist('fluidLevel','var')
    fluidLevel = 100;
end

lifetime = 0;
currentState = startingState;
L0=0; % Consumed initial fluid
Lc=0; % Buffer level
path = [];
repairedInState = -1; % The state at which the control limit is reached in this run. -1 for failure.
while fluidLevel > 0 && lifetime < maxLifetime
    transitionTime = exprnd(-1/generator(currentState,currentState));
    timeInState = 0;
    
    % Decrease buffer
    if transitionTime*fluidRates(currentState)<=Lc
        % Fluid decrease before next jump lower than the buffer
        Lc = Lc - transitionTime*fluidRates(currentState);
        lifetime = lifetime + transitionTime;
        timeInState = transitionTime;
        transitionTime = 0;
    else
        % Fluid decrease before next jump drains the whole buffer
        lifetime = lifetime + Lc/fluidRates(currentState);
        timeInState = Lc/fluidRates(currentState);
        transitionTime = transitionTime - Lc/fluidRates(currentState);
        Lc = 0;
    end
    
    % Check whether we will fail or preventively repair before the next jump
    if fluidLevel < controlLimits(currentState) && transitionTime*fluidRates(currentState)>fluidLevel-L0
        % Fail
        timeUntilFailure = (fluidLevel-L0)/fluidRates(currentState);
        lifetime = lifetime + timeUntilFailure;
        
        % Update path
        timeInState = timeInState + timeUntilFailure;
        path = [path; [currentState, timeInState]];
        return;
    elseif transitionTime*fluidRates(currentState)>controlLimits(currentState)-L0
       % Repair
        timeUntilRepair = max(0,(controlLimits(currentState)-L0)/fluidRates(currentState));
        lifetime = lifetime + timeUntilRepair;
        repairedInState = currentState;
        
        % Update path
        timeInState = timeInState + timeUntilRepair;
        path = [path; [currentState, timeInState]];
        return;
    else % Nothing happens
        % Increase consumed initial fluid
        lifetime = lifetime + transitionTime;
        L0 = L0 + transitionTime*fluidRates(currentState);
        
        % Update path
        timeInState = timeInState+transitionTime;
        path = [path; [currentState, timeInState]];
    end
    
    % Update state and add jump quantity
    nextState = simulateNextState(currentState);
    Lc = Lc + fluidJumps(currentState,nextState);
    currentState = nextState;
end
end