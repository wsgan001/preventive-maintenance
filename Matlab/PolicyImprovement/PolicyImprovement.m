function [mu] = PolicyImprovement(pdf,cdf,c,a,cDiscount)
valueFunction = @(mu) (c.*(1-cdf(mu)).*exp(-cDiscount.*mu)+(c+a).*integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu))/(1-integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu)-(1-cdf(mu)).*exp(-cDiscount.*mu));
mu = 1;
muStep = 1;
oldDifference = 1;
numImprovements = 0;
oldValue = valueFunction(mu);
while numImprovements < 200
  mu = mu + muStep;
  newValue = valueFunction(mu);
  numImprovements = numImprovements + 1;  
  newDifference = newValue - oldValue;
  if (newDifference > 0)
     muStep = -muStep/2.1;
  end
  oldDifference = newDifference;
  oldValue = newValue;
end

end