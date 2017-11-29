function [avgk] = getAverageCost(mu, dist, cp, cc)
%
%    Gets the average cost of the given control policy, life distribution
%    and cost model.
%

     if (mu < 1)
         error('the control limeit cannot be less than one unit');
     end

     %Replacement at the end of the mu-th slice gives mu+1 life
     % Expectted life with policy
     Elife = 0;
     
     for k=1:mu
         if (k <= dist.K)
            Elife = Elife + k*dist.p(k);
         else
             % this does not add to the expectation
         end
     end
     for k=mu+1:dist.K
         if (k <= dist.K)
            Elife = Elife + (mu)*dist.p(k);
         else
             % this does not add to the expectation
         end
     end
     
     Ecost = 0;
     % failure can occure at the latest before the replacement is done at
     % the end of mu-th section (epsilon before failure if that would happen at that slot)
     for k=1:(mu-1)
         if (k <= dist.K)
            Ecost = Ecost + cc*dist.p(k);
         else
             % this does not add to the expectation
         end
     end
     for k=mu:dist.K
         if (k <= dist.K)
            Ecost = Ecost + cp*dist.p(k);
         else
             % this does not add to the expectation
         end
     end
     
     avgk = Ecost/Elife;

end