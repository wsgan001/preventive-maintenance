% Set distribution
shape = 2;
rate = 2;
%PDF = @(t) wblpdf(t,rate,shape);
%CDF = @(t) wblcdf(t,rate,shape);
%hazard = @(t)  (shape/rate) .*(t/rate).^(shape-1);
PDF = @(t) pdf('Gamma',t,3.5,3.5);
CDF = @(t) cdf('Gamma',t,3.5,3.5);
hazard = @(t) PDF(t)/(1-CDF(t));

% Set other problem parameters
c = 1;
a = 100;
cDiscount= 3;

% Get the corresponding total discounted cost
tdc = TotalDiscountedCost( c,a,cDiscount,PDF);

% Set numerical parameters
numIterations = 50;
timeStep = 0.1;
discount=exp(-cDiscount.*timeStep);
numSteps = 1000;
x_init = 0.1;
v_init = tdc(x_init);
initValue = zeros(numSteps+1,1);
initValue(1) = v_init+a;
initValue(2) = v_init;
valueAt = @(x) exp(cDiscount.*x).*(v_init-(c+a+v_init).*integral(@(t) exp(-cDiscount.*t).*PDF(t),0,x))/(1-CDF(x));
for i=3:(numSteps+1)
    if (i-1)*timeStep < x_init
        initValue(i) = valueAt((i-1).*timeStep);
    else
        initValue(i) = v_init;
    end
end

% Execute the iterations
[customX, customV] = CustomIteration(x_init,v_init,c,a,cDiscount,PDF,CDF,hazard,numIterations);
[improvementX, improvementV] = PolicyImprovement(PDF,CDF,c,a,cDiscount,numIterations,x_init);
[valueX, valueV] = ValueIteration(CDF, timeStep, discount,numIterations,c,a,initValue, x_init);

% Plot results
X=1:(numIterations+1);
plot(X,customX,X,improvementX,X,valueX);