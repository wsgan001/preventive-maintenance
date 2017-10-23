% Set distribution
shape = 2;
rate = 2;
pdf = @(t) wblpdf(t,rate,shape);
cdf = @(t) wblcdf(t,rate,shape);
hazard = @(t)  (shape/rate) .*(t/rate).^(shape-1);

% Set other problem parameters
c = 1;
a = 100;
cDiscount= 5;

% Get the corresponding total discounted cost
tdc = TotalDiscountedCost( c,a,cDiscount,pdf);

% Set numerical parameters
numIterations = 200;
timeStep = 0.01;
discount=exp(-cDiscount.*timeStep);
numSteps = 100;
x_init = 0.001;
v_init = tdc(x_init);
initValue = zeros(numSteps+1,1);
initValue(1) = v_init+a;
valueAt = @(x) exp(cDiscount.*x).*(v_init-(c+a+v_init).*integral(@(t) exp(-cDiscount.*t).*pdf(t),0,x))/(1-cdf(x));
for i=2:numSteps+1
   initValue(i) = valueAt((i-2).*timeStep);
end

% Execute the iterations
[customX, customV] = CustomIteration(x_init,v_init,c,a,cDiscount,pdf,cdf,hazard,numIterations);
[improvementX, improvementV] = PolicyImprovement(pdf,cdf,c,a,cDiscount,numIterations,x_init);
[valueX, valueV] = ValueIteration(cdf, timeStep, discount,numIterations,c,a,initValue);