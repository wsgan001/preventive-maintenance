DTMC = dlmread('UniformizedCTMCWithUnuniformizedClusters.txt');
figure
% Raise to a small power to make small values more visible
bar3(DTMC.^0.25)
axis([0 57 0 57 0 1])
xlabel('To'); ylabel('From');zlabel('Probability');