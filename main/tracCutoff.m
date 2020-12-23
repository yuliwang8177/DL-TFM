function cutoffT = tracCutoff(trac,dspl,brdx,brdy,prc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cutoffT = tracCutoff(trac,dspl,brdx,brdy,prc)
%
% Description:
%   determine the threshold traction stress where the resulting strain energy
%   accounts for prc percent of the total strain energy
%
% Input:
%   trac: traction stress field
%   dspl: resulting displacement field
%   brdx,brdy: x and y coordinates of the cell border
%   prc: cutoff percentile 
%
% Output: the threshold traction stress for generating the prc percent of
%   the strain energy, e.g. 95 means the threshold such that stress magnitude
%   > threshold generates 95% of the strain energy
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% use solver of nonlinear equation to determine the point where the energy
% equals the specified percentage
cutoffT = fzero(@(c) energyPrc(c,trac,dspl,brdx,brdy,prc),93);
end

function d = energyPrc(cutoff,trac,dspl,brdx,brdy,prc)
e0 = calcEnergy(trac,dspl,brdx,brdy);
e = calcEnergy(trac,dspl,brdx,brdy,cutoff);
d = e/e0 - prc/100;
end