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

convergenceProfile = zeros(1,51);

for i=1:50
    [x,v] = CustomIteration(x,v,c,a,discount,pdf,cdf,hazard);
    convergenceProfile(i) = v;
end

plot(convergenceProfile)

%tdc = TotalDiscountedCost(1,100,1,density);
%fplot(tdc,[10 100]);
%limit = fminbnd(tdc,0,100);
%minimum = tdc(limit);