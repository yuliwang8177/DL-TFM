function tracFilt = filtTrac(trac,tracGT,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tracFilt=filtTrac(trac,tracGT,brdx,brdy,cutoff)
%
% Description:
%   filter traction vectors, first determine the threshold magnitude
%   based on the cutoff percentile and ground truth, then remove all the 
%   extracellular stress vectors as well as intracellular vectors that are 
%   smaller in magnitude than the threshold
%
% Input:
%   trac: traction stress field to filter
%   tracGT: ground truth traction field, for determining the threshold
%   brdx,brdy: x and y coordinates of the cell border 
%   cutoff (optional): threshold for removal, 95 means keeping top 5
%      perdentile, 0 means keeping all intracellular vectors
%
% Output:
%   tracFilt: filtered traction stress field
%
% Notes: keep also vectors where either traction or ground truth is larger 
%   than the threshold 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parsing input
warning('off','all');
if nargin==5
    cutoff = varargin{1};
else
    cutoff = 0;
end

[ydim,xdim,~] = size(trac);
[X,Y] = meshgrid(1:xdim,1:ydim);
pgn = polyshape(brdx,brdy);
interior = isinterior(pgn,Y(:),X(:));
interior = reshape(interior,ydim,xdim);

% nullify traction stresses outside the border
trac(:,:,1) = trac(:,:,1).*interior;
trac(:,:,2) = trac(:,:,2).*interior;
tracGT(:,:,1) = tracGT(:,:,1).*interior;
tracGT(:,:,2) = tracGT(:,:,2).*interior;

% generate maps of magnitude
tracMag = sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
tracGTMag = sqrt(tracGT(:,:,1).^2+tracGT(:,:,2).^2);

if cutoff>0
    threshold = prctile(tracGTMag(:),cutoff);
    I = tracMag>=threshold | tracGTMag>=threshold;
    trac(:,:,1) = trac(:,:,1).*I;
    trac(:,:,2) = trac(:,:,2).*I;
end

tracFilt(:,:,1)=trac(:,:,1);
tracFilt(:,:,2)=trac(:,:,2);
end