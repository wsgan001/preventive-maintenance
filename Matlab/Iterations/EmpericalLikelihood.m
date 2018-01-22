function [ el ] = EmpericalLikelihood( mmfm, PDF )
%EMPERICALLIKELIHOOD Computes the emperical likelihood of the parameters
%given in mmfm.
el=sum(log(PDF(InitialLevels(mmfm))));
end

