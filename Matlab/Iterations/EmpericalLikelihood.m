function [ el ] = EmpericalLikelihood( mmfm, PDF )
%EMPERICALLIKELIHOOD Summary of this function goes here
%   Detailed explanation goes here

el=sum(log(PDF(InitialLevels(mmfm))));

end

