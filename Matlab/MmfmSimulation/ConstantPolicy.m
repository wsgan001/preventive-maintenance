function [ policy ] = ConstantPolicy( controlLimits )
% Returns a constant policy of repairing when L0 has reached
% controlLimits(state) in state.
%   Detailed explanation goes here
policy = @(state,L0,Lc) controlLimits(state);
end

