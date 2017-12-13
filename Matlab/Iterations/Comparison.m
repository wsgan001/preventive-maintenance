% Set distribution
shape = 2;
scale = 10;
PDF = @(t) wblpdf(t,scale,shape);
CDF = @(t) wblcdf(t,scale,shape);
hazard = @(t)  (shape/scale) .*(t/scale).^(shape-1);
%PDF = @(t) pdf('Gamma',t,2,2);
%CDF = @(t) cdf('Gamma',t,2,2);
%hazard = @(t) PDF(t)/(1-CDF(t));

% Set other problem parameters
c = 1;
a = 100;
cDiscount= 0.2;

% Get the corresponding total discounted cost
tdc = TotalDiscountedCost( c,a,cDiscount,PDF);

% Set numerical parameters
numIterations = 50;
timeStep = 0.01;
discount=exp(-cDiscount.*timeStep);
numSteps = 1000;
x_init = 10;
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

% Two state
[twoStateX, twoStateV] = TwoStateJumpIteration(x_init,v_init,c,a,cDiscount,3,0.1,PDF,CDF,hazard,numIterations);

% Plot results
X=1:(numIterations+1);
figure
plot(X,customX,X,improvementX,X,valueX,TwoState);
legend('Custom Iteration','Policy Improvement','Value Iteration')
xlabel('Iterations')
ylabel('Control Limit')

figure
plot(X,customV,X,improvementV,X,valueV);
legend('Custom Iteration','Policy Improvement','Value Iteration')
xlabel('Iterations')
ylabel('Total Discounted Cost')
