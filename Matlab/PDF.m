function [ pdf ] = PDF( lambda0,lambda1,total )
%PDF Summary of this function goes here
%   Detailed explanation goes here
pdf = @(t)Density(lambda0,lambda1,t,total,100);
end

