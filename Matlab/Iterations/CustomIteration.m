function [x_convergence,v_convergence] = CustomIteration(x_init,v_init,c,a,cDiscount,pdf,cdf,hazard,numIterations)
    function [x_next,v_next] = Iterate(x_prev,v_prev,c,a,discount,pdf,cdf,hazard)
        x_next = fzero(@(t) hazard(t)-(c+v_prev).*discount/a,x_prev);
        v_next = (1-cdf(x_next)).*exp(-discount.*x_next).*(c+v_prev)+integral(@(t) pdf(t).*exp(-discount.*t),0,x_next).*(c+a+v_prev);
        % Alternatively, we could also calculate the exact total discounted
        % cost for this control limit. This results in faster convergence
        % without much more computation. The downside is that this approach
        % is probably not very extensible as for the MMFM case, there
        % probably isn't such an easy expression for the total discounted
        % cost. For the simple case, one can calculate it as follows:
        %v_next = ((1-cdf(x_next)).*exp(-discount.*x_next).*(c)+integral(@(t) pdf(t).*exp(-discount.*t),0,x_next).*(c+a))/(1-integral(@(t) pdf(t).*exp(-discount.*t),0,x_next)-(1-cdf(x_next)).*exp(-discount.*x_next));
    end
x_convergence = zeros(1,1+numIterations);
v_convergence = zeros(1,1+numIterations);
x_convergence(1) = x_init;
v_convergence(1) = v_init;
for i=1:numIterations
   [x_temp,v_temp] = Iterate(x_convergence(i),v_convergence(i),c,a,cDiscount,pdf,cdf,hazard);
   x_convergence(i+1) = x_temp;
   v_convergence(i+1) = v_temp;
end
end