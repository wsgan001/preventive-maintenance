function [hazard, pts] = HazardRatesFromLifetimes(lifetimes) 
pts = zeros(101,1);
MIN = min(lifetimes);
MAX = max(lifetimes);
for i=1:length(pts)
   pts(i) = MIN+(i-1)*(MAX-MIN)/100;
end

[PDF, x] = ksdensity(lifetimes,pts);

[ECDF,x] = ecdf(lifetimes);

% find CDF at same points as PDF
CDF = zeros(length(pts),1);
ecdfIndex = 1;
for cdfIndex=1:length(pts)
    while x(ecdfIndex) < pts(cdfIndex)
        ecdfIndex= ecdfIndex+1;
    end
    CDF(cdfIndex) = ECDF(ecdfIndex);
end

hazard = PDF ./ (ones(length(pts),1)-CDF);

end