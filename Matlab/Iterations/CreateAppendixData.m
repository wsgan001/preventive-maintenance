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
mmfm1Jumps = [0,0,0;0,0,0;5,0,0];

% Mmfm2: MMFM two states with transitions to each other with rate 2 and
% jump size 1, both have fluid rate 1. There is also a third state with 
% fluid rate 3 with an incoming edge from the one state and an outgoing 
% edge to the other both with edges without jumps and with rate 1. This 
% state has fluid rate 1.
mmfm2Generator = [-2,2,0;2,-3,1;1,0,-1];
mmfm2Rates = [1;2;3];
mmfm2Jumps = [0,1,0;1,0,0;0,0,0];

% Distributions: Weibull(20/sqrt(pi),2) (so that it has mean 10) and Erlang(2,1/5)
weibull=makedist('Weibull','a',20/sqrt(pi),'b',2);
gamma=makedist('Gamma','a',2,'b',5);

% Problem parameters: 
% P1 (c=1,a=100,cDiscount=1)
p1c=1;
p1a=100;
p1cDiscount=1;
% P2 (c=1,a=1, cDiscount=1)
p2c=1;
p2a=1;
p2cDiscount=1;
% P3 (c=1,a=100,cDiscount=0.5)
p3c=1;
p3a=100;
p3cDiscount=0.5;
% P4 (c=1,a=100,cDiscount=2)
p4c=1;
p4a=100;
p4cDiscount=2;

