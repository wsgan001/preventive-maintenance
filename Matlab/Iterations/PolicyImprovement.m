function [x_convergence, v_convergence] = PolicyImprovement(pdf,cdf,c,a,cDiscount,numIterations,x_init)
% POLICYIMPROVEMENT Implements a policy iteration approach for the
% age-based problem.
valueFunction = @(mu) (c.*(1-cdf(mu)).*exp(-cDiscount.*mu)+(c+a).*integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu))/(1-integral(@(t) pdf(t).*exp(-cDiscount.*t),0,mu)-(1-cdf(mu)).*exp(-cDiscount.*mu));
muStep = 1;
x_convergence = zeros(1,numIterations+1);
v_convergence = zeros(1,numIterations+1);
x_convergence(1) = x_init;
v_convergence(1) = valueFunction(x_init);
for i=1:numIterations
    % I've set 0.001 as the minimum value of x
    x_convergence(i+1) = max(0.001,x_convergence(i) + muStep);
    v_convergence(i+1) = valueFunction(x_convergence(i+1)); 
    difference = v_convergence(i+1) - v_convergence(i);
    if (difference > 0)
       muStep = -muStep*0.45;
    end
end
end