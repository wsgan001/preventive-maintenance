function [ totalTimeInState, numJumps ] = InspectTrace( trace, numStates )
%INSPECTTRACE Sums for each state the amount of time it has spent there and
%counts the number of jumps from each pair of states.
totalTimeInState = zeros(1,numStates);
numJumps = zeros(numStates,numStates);

% Do for the initial state
lastState = trace(1,1);
totalTimeInState(trace(1,1)) = trace(1,2);

if (size(trace,1)>1)
    for n=2:size(trace,1)
        totalTimeInState(trace(n,1)) = totalTimeInState(trace(n,1))+trace(n,2);
        numJumps(lastState,trace(n,1)) = numJumps(lastState,trace(n,1))+1;
        lastState = trace(n,1);
    end
end
end

