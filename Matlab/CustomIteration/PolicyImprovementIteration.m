function [x_next,v_next] = PolicyImprovementIteration(x,v,c,a,discount,pdf,cdf,hazard)
%hazard = @(t) pdf(t) / (1-integral(pdf,0,t));
x_next = fzero(@(t) hazard(t)-(c+v).*discount/a,x);
v_next = (1-cdf(x_next)).*exp(-discount.*x_next).*(c+v)+integral(@(t) pdf(t).*exp(-discount.*t),0,x_next).*(c+a+v);
%v_next = ((1-cdf(x_next)).*exp(-discount.*x_next).*(c)+integral(@(t) pdf(t).*exp(-discount.*t),0,x_next).*(c+a))/(1-integral(@(t) pdf(t).*exp(-discount.*t),0,x_next)-(1-cdf(x_next)).*exp(-discount.*x_next));
end