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
         Elife = Elife + (k-1)*dist.p(k);
     end
     for k=mu+1:dist.K
         Elife = Elife + (mu)*dist.p(k);
     end
     
     Ecost = 0;
     for k=1:mu
         Ecost = Ecost + cc*dist.p(k);
     end
     for k=mu+1:dist.K
         Ecost = Ecost + cp*dist.p(k);
     end
     
     avgk = Ecost/Elife;

end