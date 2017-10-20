shape = 2;
rate = 2;
pdf = @(t) wblpdf(t,rate,shape);
cdf = @(t) wblcdf(t,rate,shape);
hazard = @(t)  (shape/rate) .*(t/rate).^(shape-1);
c=1;
a=100;
discount = 5;
x=1;
v=1;

convergenceProfile = [];

for i=1:50
    [x,v] = PolicyImprovementIteration(x,v,c,a,discount,pdf,cdf,hazard);
    convergenceProfile = [convergenceProfile x];
end

plot(convergenceProfile)

%tdc = TotalDiscountedCost(1,100,1,density);
%fplot(tdc,[10 100]);
%limit = fminbnd(tdc,0,100);
%minimum = tdc(limit);