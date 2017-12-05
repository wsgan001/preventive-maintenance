function [ eq ] = Equation(r,c,A,data,lambda,k,numExperiments)
if r==c
    a=FluidRateMLE(data,r,lambda,k,numExperiments);
    eq = a(Diagonal(A),A);
else
    a=JumpQuantityMLE(data,r,c,lambda,k,numExperiments);
    eq = a(Diagonal(A),A);
end
end