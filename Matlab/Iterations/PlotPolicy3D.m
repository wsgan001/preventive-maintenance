function [  ] = PlotPolicy3D( costs,policy,state,timeStep )
%PLOTPOLICY3D Plots result from value iteration on a 3D plot.
arraySize=size(costs);

%RGB color
C=zeros(arraySize(1),arraySize(2),3);
C(:,:,1)=policy(:,:,1,state);
C(:,:,2)=ones(arraySize(1),arraySize(2))-policy(:,:,1,state);
[X,Y]=meshgrid(1:arraySize(2),1:arraySize(1));

h=surf(timeStep.*X,timeStep.*Y,costs(:,:,1,state),C);
set(h,'LineStyle','none');
xlabel('L0');
ylabel('Time');
zlabel('Expected Total Discounted Cost');
end

