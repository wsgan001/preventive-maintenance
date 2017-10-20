function [ cdf ] = CDF( lambda0,lambda1,total )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
cdf = @(t) integral(PDF(lambda0,lambda1,total),0,t);
end

