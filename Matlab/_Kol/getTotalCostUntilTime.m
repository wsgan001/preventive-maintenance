function [cost] = getTotalCostUntilTime(dist, mu, T, cp, cc, beta)
%
%   Gets the total cost up until time T given the parameters.
%

    % the state is composed of lifetime of the equipment and already payed
    % cost
    
    % in which slot of the lifetime we are in, between 1 and mu inclusively
    x.lifetime = 1;
    % the total cost up until now, start with 0
    x.cost = 0;
    
    
    for (t=1:T)
        % we are at the beginning of the t-th slot
        
        pFailure = dist.Hazard(x.lifetime);
        failure = false;
        if (rand() <= pFailure)
            failure = true;
        end
        
        if (x.lifetime == mu)
            % we hit the replacement limit
            % we start a first slot in a new machine
            x.lifetime = 1;
            % we pay a discounted cost corresponding to the end the current cycle
            x.cost = x.cost + cp*exp(-beta*(t));
        else        
            % no replacement was done
            % check if failure occurs here
            if (failure)
                % failure
                % we start a first slot in a new machine
                x.lifetime = 1;
                % we pay a discounted cost corresponding to the end time cycle
                x.cost = x.cost + cc*exp(-beta*(t));
            else
                % no failure
                % no failure no limit
                x.lifetime = x.lifetime + 1;
                % cost is not changed
            end
        end
        % check if we should replace at the end of the slot
    end
    
    cost = x.cost;

end