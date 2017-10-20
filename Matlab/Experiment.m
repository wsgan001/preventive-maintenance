function [ results ] = Experiment( lambda0,lambda1,total,numExperiments )
%Experiment
results = zeros(numExperiments);
for e=1:numExperiments
    time=0;
    time0=0;
    while time<total
       period0 = -log(1-rand())/lambda0;
       if (time+period0>total)
           time0 = time0+ total-time;
       else
           time0 = time0 + period0;
       end
       time = time + period0;
       period1 = -log(1-rand())/lambda1;
       time = time + period1;
    end
    results(e) = time0;
end
end

