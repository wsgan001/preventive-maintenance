function [mu, costcurve] = getOptimalControlLimitForAverageCost(dist, cp, cc)
%
%   Gets the optimal control limit for the given distribution using the
%   average cost.
%
%   Preventive cost cp, corrective cost cc.
%

    if (cp >= cc)
        error('Preventive cost should be lower.');
    end

    costcurve = zeros(1, dist.K);
    
    minavg = inf;
    for k=1:dist.K
        avgk = getAverageCost(k, dist, cp, cc);
        costcurve(k) = avgk;
        if (avgk < minavg)
            mu = k;
            minavg = avgk;
        end
    end
end

