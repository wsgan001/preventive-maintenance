% Simple1: simple fluid model with rate 1 and jump 0.5
simple1Generator = [-1,1;1,-1];
simple1Rates = [1;1];
simple1Jumps = [0,0.5;0.5,0];

% Simple2: simple fluid model with rate 0.5 and jump 1
simple2Generator = [-0.5,0.5;0.5,-0.5];
simple2Rates = [1;1];
simple2Jumps = [0,1;1,0];

% Mmfm1: MMFM three state cycle with transition rates 1, fluid rates 1, 2 
% and 3 and a jump between s3 and s1 with size 5
mmfm1Generator = [-1,1,0;0,-1,1;1,0,-1];
mmfm1Rates = [1;2;3];
mmfm1Jumps = [0,0,0;0,0,0;3,0,0];

% Mmfm2: MMFM two states with transitions to each other with rate 2 and
% jump size 1, both have fluid rate 1. There is also a third state with 
% fluid rate 3 with an incoming edge from the one state and an outgoing 
% edge to the other both with edges without jumps and with rate 1. This 
% state has fluid rate 1.
mmfm2Generator = [-2,2,0;2,-3,1;1,0,-1];
mmfm2Rates = [1;1;3];
mmfm2Jumps = [0,1,0;1,0,0;0,0,0];

% Distributions: Weibull(20/sqrt(pi),2) (so that it has mean 10) and Erlang(5,1/2)
weibull=makedist('Weibull','a',20/sqrt(pi),'b',2);
gamma=makedist('Gamma','a',5,'b',2);

% Problem parameters: 
% P1 (c=1,a=100,cDiscount=1)
p1c=1;
p1a=100;
p1cDiscount=1;
% P2 (c=1,a=1, cDiscount=1)
p2c=1;
p2a=5;
p2cDiscount=1;
% P3 (c=1,a=100,cDiscount=0.5)
p3c=1;
p3a=100;
p3cDiscount=0.5;
% P4 (c=1,a=100,cDiscount=2)
p4c=1;
p4a=100;
p4cDiscount=2;

cs = [p1c, p2c, p3c, p4c];
as = [p1a, p2a, p3a, p4a];
cDiscounts = [p1cDiscount, p2cDiscount, p3cDiscount, p4cDiscount];
dists = [weibull, gamma];
distLabels = ["Weibull$(20/\\\\pi,2)$","Gamma$(2,5)$"];

% Do age-based
fage = fopen( 'AgeBasedComputations.txt', 'wt' );
for p=1:4
    for dist=1:2
        [policy, tdc] = CustomIteration(1,1,cs(p),as(p),cDiscounts(p),@(x)pdf(dists(dist),x),@(x)cdf(dists(dist),x),@(x) pdf(dists(dist),x)./(1e-10+1-cdf(dists(dist),x)),20);
        fprintf( fage, '$%i$ & $%i$ & $%.1f$ & %s & $%.3f$ & $%.3f$ \\\\ \n', cs(p), as(p), cDiscounts(p), distLabels(dist), policy(20), tdc(20));
    end
end
fclose(fage);



generators = {simple1Generator, simple2Generator};
rates = {simple1Rates, simple2Rates};
jumps = {simple1Jumps, simple2Jumps};

fsimple = fopen( 'SimpleFluidComputations.txt', 'wt' );
for s=1:2
    lambda = generators{s}(1,2);
    J=jumps{s}(1,2);
    for p=1:4
        for dist=1:2
            [policy, tdc] = TwoStateJumpIteration( 1,1,cs(p),as(p),cDiscounts(p),lambda,J,@(x)pdf(dists(dist),x),@(x)cdf(dists(dist),x),@(x) pdf(dists(dist),x)./(1e-10+1-cdf(dists(dist),x)),20);
            fprintf( fsimple, '$%i$ & $%i$ & $%.1f$ & %s & $%.1f$ & $%.1f$ & $%.3f$ & $%.3f$ \\\\ \n', cs(p), as(p), cDiscounts(p), distLabels(dist), lambda, J, policy(20), tdc(20));
        end
    end
end
fclose(fsimple);

generators = {mmfm1Generator, mmfm2Generator};
rates = {mmfm1Rates, mmfm2Rates};
jumps = {mmfm1Jumps, mmfm2Jumps};

fmmfm = fopen( 'MmfmComputations.txt', 'wt' );
for m=1:2
    for p=1:4
        for dist=1:2
            PDF =@(x) pdf(dists(dist),x);
            CDF =@(x) cdf(dists(dist),x);
            %hazard=@(x) pdf(dists(dist),x)./(1e-10+1-cdf(dists(dist),x));
            
            [simplePolicy,simpleTdc]=MmfmSimpleIteration(generators{m}, rates{m}, jumps{m}, PDF, CDF, cs(p), as(p), cDiscounts(p), 0, ones(length(rates{m}),1),40);
            [uniformPolicy, uniformTdc]=MmfmUniformIteration(generators{m}, rates{m}, jumps{m}, PDF, CDF, cs(p), as(p), cDiscounts(p), 0, ones(length(rates{m}),1),40);
            [exactPolicy, exactTdc]=MmfmExactIteration(generators{m}, rates{m}, jumps{m}, PDF, CDF, cs(p), as(p), cDiscounts(p), 0, ones(length(rates{m}),1),40);
            
            fprintf( fmmfm, '$%i$ & $%i$ & $%.1f$ & %s & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ \\\\ \n', cs(p), as(p), cDiscounts(p), distLabels(dist), exactPolicy(1,41), exactPolicy(2,41), exactPolicy(3,41), exactTdc(41),uniformPolicy(41), uniformTdc(41),simplePolicy(1,41),simplePolicy(2,41),simplePolicy(3,41),simpleTdc(41));
        end
    end
end
fclose(fmmfm);
