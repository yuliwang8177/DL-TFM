function cutoffT = tracEnergyCutoff(trac,E,brdx,brdy,prc,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cutoffT = tracEnergyCutoff(trac,E,brdx,brdy,prc,buffer)
%
% Description:
%   determine the threshold traction stress where the resulting strain 
%   energy accounts for prc percent of the total strain energy; 
%   displacements and energy are recalcuated based on the stress above 
%   the cutoff before calculating the energy
%
% Input:
%   trac: traction stress field
%   E: Young's Modulus
%   brdx,brdy: x and y coordinates of the cell border
%   prc: cutoff percentile 
%   buffer (optiona0); buffer zone around the cell, default = 0
%
% Output: the threshold traction stress for generating the prc percent of
%   the strain energy, e.g. 95 means the threshold such that stress magnitude
%   > threshold generates 95% of the strain energy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% use solver of nonlinear equation to determine the point where the energy
% equals the specified percentage
buffer = 0;
if nargin==6
    buffer = varargin{1};
end
cutoffT = fzero(@(c) energyPrc(c,trac,E,brdx,brdy,prc,buffer),prc);
end

function d = energyPrc(cutoff,trac,E,brdx,brdy,prc,buffer)
e0 = calcEnergy(trac,E,brdx,brdy,0,buffer);
e = calcEnergy(trac,E,brdx,brdy,cutoff,buffer);
d = e/e0 - prc/100;
end