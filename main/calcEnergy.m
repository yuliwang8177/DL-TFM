function energy = calcEnergy(trac,dspl,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energy = calcEnergy(trac,dspl,brdx,brdy,cutoff)
%
% Description:
%   calculate the strain energy for traction vectors that are above a
%   specified percentile cutoff
%
% Input:
%   trac: traction stress field
%   dspl: the resulting displacement field
%   brdx,brdy: x and y coordinates of the cell border
%   cutoff (optional): the cutoff percentile, e.g. 95 means energy
%     generated by the top 5% of the traction stress
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parse input
warning('off','all');
if nargin == 5
    cutoff = varargin{1};
else
    cutoff = 0;
end

pgn = polyshape(brdx,brdy);
[ydim,xdim,~] = size(trac);
[Y,X] = meshgrid(1:xdim,1:ydim);
interior = isinterior(pgn,X(:),Y(:));
interior = reshape(interior,ydim,xdim);

tracX = trac(:,:,1);
tracX = tracX.*interior;
tracY = trac(:,:,2);
tracY = tracY.*interior;

if cutoff>0
    tracMag = sqrt(tracX.^2+tracY.^2);
    threshold = prctile(tracMag(interior),cutoff);
    tracX(tracMag<threshold)=0;
    tracY(tracMag<threshold)=0;
end
    
dsplX = dspl(:,:,1).*interior;
dsplY = dspl(:,:,2).*interior;

energy = sum(tracX.*dsplX+tracY.*dsplY,'all');
end