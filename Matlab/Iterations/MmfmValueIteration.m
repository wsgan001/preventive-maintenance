function [ policy,costs ] = MmfmValueIteration( cdf,generator, rates, jumps, numTimeSteps, discount,maxT,maxL0,maxLC,c,a,stationary )
%MMFMVALUEITERATION Performs value iteration on the MMFM problem.
% rates must be integer.

    % Failure probability in one timestep
    function [probability] = failProbability(level,state)
        p_now=cdf(level.*timeStep);
        p_next=cdf(level.*timeStep+timeStep.*rates(state));
        probability = (p_next-p_now)/(1-p_now);
    end

    function [action, cost] =  calculatePolicy(t,l0,lc,s)
        if t==numTimeSteps
            % Terminal cost is zero
            action = 0;
            cost = 0;
        elseif lc==numTimeSteps
            % When lc is very large, cost will be zero
            action=0;
            cost = 0;
        elseif l0==numTimeSteps
            % When l0 is very large, repair will be chosen.
            action=1;
            cost = c+discountFactor.*costs(t+dt,1,1,1);
        elseif lc>1
            % We neglect the possibility lc<rates(s) for simplicity. lc
            % will then become zero.
            action = 0;
            cost = 0;
            for newState=1:numStates
               cost = cost + transitionProbabilities(s,newState).*discountFactor.*costs(t+dt,l0,min(max(lc+jumps(s,newState)/timeStep-rates(s),1),maxLC/timeStep),newState,1); 
            end
        else
            repairCost = c+discountFactor*costs(t+dt,1,1,1);
            
            % The cost of not repairing. First calculate without failures
            waitCostNoFail = 0;
            for newState=1:numStates
               waitCostNoFail = waitCostNoFail + transitionProbabilities(s,newState)*discountFactor*costs(t+dt,min(l0+rates(s),maxL0/timeStep),min(lc+jumps(s,newState)/timeStep,maxLC/timeStep),newState); 
            end
            
            % Take failures into account
            fail = failProbability(l0,s);
            waitCost = (1-fail).*waitCostNoFail + fail.*(c+a+discountFactor.*costs(t+dt,1,1,1));
            
            % Decide
            if repairCost<waitCost
                action = 1;
                cost = repairCost;
            else
                action = 0;
                cost = waitCost;
            end
        end
    end



% stationary is false by default
if ~exist('stationary','var')
   stationary = false; 
end

% Set time steps to 0 for stationary iteration
dt=1;
if stationary
    dt=0;
end

timeStep = maxT/numTimeSteps;
discountFactor = exp(-timeStep*discount);
numStates = length(rates);
transitionProbabilities=zeros(numStates);
for from=1:numStates
    for to=1:numStates
        if from==to
           transitionProbabilities(from,from) = exp(generator(from,from)*timeStep); 
        else
           transitionProbabilities(from,to)= -(1-exp(generator(from,from)*timeStep))*generator(from,to)/generator(from,from);
        end
    end
end

% Fill the array
if stationary
    policy = zeros(1,maxL0/timeStep,maxLC/timeStep,numStates);
    costs = zeros(1,maxL0/timeStep,maxLC/timeStep,numStates);
    % Still do it numIterations times
    for t=floor(maxT/timeStep):-1:1
        for l0=1:floor(maxL0/timeStep)
            for lc=1:floor(maxLC/timeStep)
                for s=1:numStates
                   [policy(1,l0,lc,s),costs(1,l0,lc,s)] = calculatePolicy(1,l0,lc,s);
                end
            end
        end
    end
else
    policy = zeros(numTimeSteps,maxL0/timeStep,maxLC/timeStep,numStates);
    costs = zeros(numTimeSteps,maxL0/timeStep,maxLC/timeStep,numStates);
    for t=floor(maxT/timeStep):-1:1
        for l0=1:floor(maxL0/timeStep)
            for lc=1:floor(maxLC/timeStep)
                for s=1:numStates
                   [policy(t,l0,lc,s),costs(t,l0,lc,s)] = calculatePolicy(t,l0,lc,s);
                end
            end
        end
    end
end
end
