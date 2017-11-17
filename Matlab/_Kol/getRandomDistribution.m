function [dist] = getRandomDistribution(K)
%
%   Gets a random discrete distribution over the support [1, ... K].
%
%   p_k means that the machine will fail at the end of the k-th slot.
%
%

    p = zeros(1, K);
    
    % get K uniform points in 
    p = drchrnd(ones(1, K)); 
    
    % get CDF
    
    dist.p = p;
    dist.CDF = cumsum(p);
    shifedCDF = [0 dist.CDF(1:K-1)];
    dist.Hazard = p./(1-shifedCDF); % failure probability at the beginning of the k-t step condition that we lived to the end of k-1.
    dist.K = K;
    
end

function r = drchrnd(a)
% take a sample from a dirichlet distribution
% a = a_1, a_2, ..., a_K the parameters of the Dirichelt distribution
K = length(a);
r = gamrnd(repmat(a,1,1),1,1,K);
r = r ./ repmat(sum(r,2),1,K);
end