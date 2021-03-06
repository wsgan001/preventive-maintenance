scale = 10;
shape = 2;
%generator = [-0.2,0.1,0.1;0,-0.1,0.1;0.2,0,-0.2];
%rates = [1;3;2];
%jumps = [0,10,0;0,0,0;3,0,0];
generator = [-3,3;3,-3];
rates = [1;1];
jumps = [0,0.25;0.25,0];
numTimeSteps = 400;
discount = 0.2;
maxT = 25;
maxL0 = 10;
global maxLC
maxLC =10;
c=1;
a=100;
cdf = @(t) wblcdf(t,scale,shape);
[policy,costs]=MmfmValueIteration(cdf,generator,rates,zeros(2),numTimeSteps,discount,maxT,maxL0,maxLC,c,a,false);
%relevantPolicy = policy(:,:,1,1);
%relevantCosts = costs(:,:,1,1);
%arraySize=size(costs);
%firstCostSlice = zeros(arraySize(2),arraySize(3));
%firstCostSlice(:,:) = costs(1,:,:,1);

PlotPolicy3D(costs,policy,1,maxT/numTimeSteps)

