function [ d ] = Density( lambda0,lambda1,t,total,n )
%Density
d=0;
for k=1:n
    d= d+((lambda0.*lambda1.*t).^k).*((total-t).^(k-1))/(factorial(k).*factorial(k-1))+lambda0.^k.*((lambda1.*t.*(total-t)).^(k-1))/(factorial(k-1).^2);
end
d = d.*exp(-lambda0*t-lambda1*(total-t));
end

