% Finds parameters for MMFM by minimizing the variance of the initial fluid
% distribution.
global traceData numExperiments numStates averageInitialLevel varInitialLevel;

% Set parameters for generating data
generator = [-1.001,1,0.001;1,-2,1;0.001,1,-1.001];
fluidJumps=[0,0,0;1,0,0;0,1,0];
fluidRates = [2;5;1];
lambda = 100;
k=3;
PDF = @(x)wblpdf(x,lambda,k);
numExperiments = 10000;

averageInitialLevel = lambda*gamma(1+1/k);
varInitialLevel = lambda.^2*(gamma(1+2/k)-gamma(1+1/k).^2);
numStates = length(fluidRates);

% Generate data
traceData = cell(numExperiments,2);
initialLevels = wblrnd(lambda,k,numExperiments,1);
for i=1:numExperiments
    [a,b,trace] = MmfmLifetime(generator,fluidRates,fluidJumps, initialLevels(i));
    % Store for each trace the amount of time it has spent in each state
    % and the number of times each jump has occurred.
    [traceData{i,1},traceData{i,2}] = InspectTrace(trace,length(fluidRates));
end

% Use fmincon to find a solution. Bounds could be set such that each
% initial fluid level was positive. (or that it was positive before each
% jump).
A=[];
b=[];
Aeq=[];
beq=[];
lb=zeros(numStates);
ub=10*ones(numStates);
[mmfm,initialVariance]=fmincon(@(X) EmpiricalVariance(X),eye(numStates),A,b,Aeq,beq,lb,ub);
%[mmfmL,ll]=fminunc(@(X) -EmpericalLikelihood(X,PDF),eye(numStates));

% Extract resulted jump quantities and rates
rates = Diagonal(mmfm);
jumps=mmfm-diag(rates);
