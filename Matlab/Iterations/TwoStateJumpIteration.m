function [ x_convergence,v_convergence ] = TwoStateJumpIteration( x_init,v_init,c,a,cDiscount,lambda,J,pdf,cdf,hazard,numIterations )
%TWOSTATEJUMPITERATION Finds the optimal policy and corresponding total
%discounted cost for the simple fluid problem by reducing the computations
%to the age-based problem.
D=ExpectedDiscount(J,lambda,cDiscount);
% Compute adjusted discount factor
beta=cDiscount+lambda.*(1-D);
[x_convergence,v_convergence]=CustomIteration(x_init,v_init,c,a,beta,pdf,cdf,hazard,numIterations);
end

