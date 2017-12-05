


%generator = [-3, 1, 2; 1, -2, 1; 0,1,-1];
%fluidJumps = [0,0,5;0,0,0;0,0,0];
%fluidRates = [1;2;3];
generator = [-1,1;2,-2];
fluidJumps=[0,0;1,0];
fluidRates = [2;5];
lambda = 50;
k=3;
numExperiments = 100;

numStates = length(fluidRates);

% Generate data
data = cell(numExperiments,2);
initialLevels = wblrnd(lambda,k,numExperiments,1);
for i=1:numExperiments
    [a,b,trace] = MmfmLifetime(generator,fluidRates,fluidJumps, initialLevels(i));
    % Store for each trace the amount of time it has spent in each state
    % and the number of times each jump has occurred.
    [data{i,1},data{i,2}] = InspectTrace(trace,length(fluidRates));
end

% Hacky way to be able to access the row and column in arrayfun.
Row=zeros(numStates);
Column=zeros(numStates);
for i=1:numStates
    Row(i,:)=i;
    Column(:,i)=i;
end

% Set options for solve
options=optimset('MaxFunEvals',100000);
options=optimset(options,'MaxIter',10000);
options=optimset(options, 'disp','iter','LargeScale','off','TolFun',.001);

% Use fsolve to find a solution. To avoid negative results, the input
% matrix is squared. The input is one single matrix, with the fluid rates
% on the diagonal and the jump quantities outside the diagonal. The
% equations are stored in a matrix using arrayfun.
result = fsolve(@(A) arrayfun(@(r,c) Equation(r,c,A.^2,data,lambda,k,numExperiments),Row,Column),(diag(fluidRates)+fluidJumps).^0.5,options);
% Print result
result.^2

% Extract resulted jump quantities and rates
jumps = result.^2;
rates = Diagonal(jumps);

% Compute the initial fluid levels that were measured according to these
% rates and jump quantities. (For comparison)
inits = zeros(numExperiments,1);
for i=1:numExperiments
    init = FindInitialLevel(data{i,1},data{i,2});
    inits(i)=init(rates,jumps);
end
