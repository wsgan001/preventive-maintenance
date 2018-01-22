function [fHazard,fPDF, fCDF] = HazardRatesFromLifetimes(lifetimes) 
% HAZARDRATESFROMLIFETIMES Finds the hazard rate from the lifetimes.
pts = zeros(101,1);
MIN = min(lifetimes);
MAX = max(lifetimes);
for i=1:length(pts)
   pts(i) = MIN+(i-1)*(MAX-MIN)/100;
end

[PDF, x] = ksdensity(lifetimes,pts);
fPDF = griddedInterpolant(x,PDF);

[ECDF,y] = ecdf(lifetimes);

% Remove duplicates
[y,ECDF]=RemoveDuplicates(y,ECDF);
fCDF = griddedInterpolant(y,ECDF);

fHazard = @(t) fPDF(t) ./ (1-fCDF(t));
end