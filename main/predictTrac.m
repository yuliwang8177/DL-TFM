function trac = predictTrac(dspl,E)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trac = predictTrac(dspl,E)
%
% Description:
%   calculate traction stress field trac from strain field dspl
%
% Input:
%   dspl = displacements, as a SxSx2 tensor where the two z channels 
%      contain x and y component of the displacement respectively
%   E = Young's modulus of the substrate in Pascals
%
% Output: 
%   trac = traction stress field trac as a SxSx2 tensor where the two z
%   channels contain x and y components of the traction stress respectively
%   in Pascals
%
% Requirement: mat file tracnetS.mat in the search path, containing 
%   trained neural network for SxS fields  
%
% Note: tracnet104.mat was trained for 10 Newtons/pixel, tracnet160.mat 
%   and tracnet256.mat were trained for 10/mag Newtons/pixel, where 
%   mag = S/104 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
S = length(dspl);
mag = S/104;
conversion = E/10*mag; % convert from Newons/pixel to Pa

fn = sprintf('tracnet%d.mat',S);
netmat = load(fn);
net = netmat.net;

% predict traction stress from preloaded displacements
trac = activations(net,dspl,'output')*conversion;

end

%% explanation of conversion
%   conversion factor from Newtons/pixel to Pascals = (pix/1e6)^2
%   where pix is the width/length of the square pixel in microns
%   E0 for the training set = 10/mag*(1e6/pix)^2 Pascals
%   Conversion for a different Young's modulus E = E/Eo = 
%   E/mag/(10/mag*(1e6/pix)^2)
%   Raw output is in Newtons/pix, conversion to Pascals = 
%   E/(10/mag*(1e6/pix)^2) * (pix/1e6)^2 = E/10*mag

