function [ x,y ] = RemoveDuplicates( x,y )
%REMOVEDUPLICATES Given f(x)=y at points x, this removes duplicate x's and
%corresponding y's.
%   Detailed explanation goes here
last=x(1);
numRemoved=0;
for i=2:length(x)
    if x(i-numRemoved)==last
        x(i-numRemoved)=[];
        y(i-numRemoved)=[];
        numRemoved = numRemoved+1;
    else
        last = x(i-numRemoved);
    end
end

end

