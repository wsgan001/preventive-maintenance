% Requires StateLifetimes.csv to be imported
transitionTimes = zeros(2000,56);
for i=1:35
    transitionTimes(1:2000,i)=table2array(StateLifetimes(1:2000,i));
end
% row 36 contains NA
for i=37:57
    transitionTimes(1:2000,i-1)=table2array(StateLifetimes(1:2000,i));
end
expFit=[];
for i=1:56
   expFit=[expFit,fitdist(transitionTimes(1:2000,i),'Exponential')];
end

for i=6:10
    figure
    [ecdf,pts]=ksdensity(transitionTimes(1:2000,i));
    plot(pts,ecdf,pts,expFit(i).pdf(pts));
    legend('observed','estimated')
end