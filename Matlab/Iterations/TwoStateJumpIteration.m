function [ x_convergence,v_convergence ] = TwoStateJumpIteration( x_init,v_init,c,a,cDiscount,lambda,J,pdf,cdf,hazard,numIterations )
%TWOSTATEJUMPITERATION Summary of this function goes here
%   Detailed explanation goes here
D=ExpectedDiscount(J,lambda,cDiscount);
beta=cDiscount+lambda.*(1-D);
[x_convergence,v_convergence]=CustomIteration(x_init,v_init,c,a,beta,pdf,cdf,hazard,numIterations);
end

