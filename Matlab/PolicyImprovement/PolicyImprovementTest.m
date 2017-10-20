cdf = @(t)wblcdf(t,2,2);
pdf = @(t)wblpdf(t,2,2);
a=100;
c=1;
cDiscount=5;
result = PolicyImprovement(pdf,cdf, c,a,cDiscount);
valueFunction = @(mu) (c.*(1-cdf(mu)).*exp(-cDiscount.*mu)+(c+a).*integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu))/(1-integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu)-(1-cdf(mu)).*exp(-cDiscount.*mu));
fplot(valueFunction,[0.1 10]);