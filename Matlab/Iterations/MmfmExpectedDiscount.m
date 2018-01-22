function [ ed ] = MmfmExpectedDiscount( discountGenerator, policy, fluid, from, to )
%MMFMEXPECTEDDISCOUNT The expected discount after L0 has increased an amount
%specified by fluid. From and to are optional arguments. 
% Assumes policy is nonnegative

% Vectorization
if length(fluid)>1
    ed= arrayfun(@(q) MmfmExpectedDiscount(discountGenerator,policy,q,from,to),fluid);
    return;
end

numStates = length(policy);

% When fluid is negative, the time to which we want to discount is in the
% past. Since we only consider costs in the future, we will return zero.
if fluid<0
    rows=numStates;
    columns=numStates;
    if exist('from','var')
        rows=1;
    end
    if exist('to','var')
        columns = 1;
    end
    ed=zeros(rows,columns);
    return;
end

sortedPolicy = sort(policy);

ed=eye(numStates);
discountedUntil=0;

% Find first positive control limit
i=1;
while i<=numStates && sortedPolicy(i)<0
    i=i+1;
end


% If not all control limits were negative
if i<= numStates
    ed=expm(GetDiscountGeneratorAtTime(discountGenerator,policy,discountedUntil).*min(fluid,sortedPolicy(i)));
    discountedUntil=min(fluid,sortedPolicy(i));
end

i=i+1;
while i<=numStates && sortedPolicy(i) <= fluid
    ed=ed*expm(GetDiscountGeneratorAtTime(discountGenerator,policy,sortedPolicy(i-1)).*(sortedPolicy(i)-discountedUntil));
    discountedUntil = sortedPolicy(i);
    i=i+1;
end

ed=ed*expm(GetDiscountGeneratorAtTime(discountGenerator,policy,fluid).*(fluid-discountedUntil));

% If no destination is specified, we simply return the whole row, else we
% sum over destinations.
if exist('to','var')
    toVector=zeros(numStates,1);
    for i=1:length(to)
        toVector(to(i))=1;
    end
    ed=ed*toVector;
end

% If an origin is specified, we only return the row corresponding to that
% origin.
if exist('from','var')
   ed = ed(from,:); 
end


