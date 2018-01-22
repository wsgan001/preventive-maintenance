function [ ed ] = MmfmExpectedDiscountNotRepaired( discountGenerator, policy, fluid, from )
% MMFMEXPECTEDDISCOUNTNOTREPAIRED Discounted probability of not having
% repaired when L0 reaches fluid.

% Vectorization
if length(fluid)>1
    ed= arrayfun(@(q) MmfmExpectedDiscountNotRepaired( discountGenerator, policy, q, from ),fluid);
    return;
end

to=[];
for i=1:length(policy)
   if policy(i)>=fluid
       to=[to,i];
   end
end
ed=MmfmExpectedDiscount( discountGenerator, policy, fluid, from, to );
end