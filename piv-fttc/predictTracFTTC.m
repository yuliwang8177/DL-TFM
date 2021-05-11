function trac = predictTracFTTC(dspl,E,L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trac = predictTracFTTC(dspl,E,L)
%
% Description:
%   calculate traction stress field trac from strain field dspl using FTTC
%   a simple wrapper to use US Schwarz's program reg_fourier_TFM in a 
%   similar syntax as that for deep learning predictTrac
%
% Input:
%   dspl = displacements, as a SxSx2 tensor where the two z channels 
%      contain x and y component of the displacement respectively
%   E = Young's modulus of the substrate in Pascals
%   v = Poisson ratio of the substrate
%   L = regularization factor
%
% Output: 
%   trac = traction stress field trac as a SxSx2 tensor where the two z
%   channels contain x and y components of the traction stress respectively
%   in Pascals
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
v = 0.45;
S = length(dspl);
[x,y] = meshgrid(1:1:S,1:1:S);
reg_grid = zeros(S,S,2);
reg_grid(:,:,1) = x';
reg_grid(:,:,2) = y';

% predict traction stress from preloaded displacements
[~ ,~ ,~ , ~ ,~ , trac] = reg_fourier_TFM(reg_grid, dspl, E, v, 1, 1, S, S, L);
end

