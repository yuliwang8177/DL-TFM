function tracFilt = filtTrac(trac,tracGT,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tracFilt=filtTrac(trac,tracGT,brdx,brdy,buffer,cutoff)
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
%   buffer (optional): buffer zone around the cell treated like interior,
%      default = 10
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
buffer = 10;
cutoff = 0;
if nargin==6
    buffer = varargin{1};
    cutoff = varargin{2};
elseif nargin==5
    buffer = varargin{1};
end

[ydim,xdim,~] = size(trac);
[X,Y] = meshgrid(1:xdim,1:ydim);
pgnS = polyshape(brdx,brdy);
pgnL = polybuffer(pgnS,buffer);
pgnFar = polybuffer(pgnS,buffer);
pgnFar = xor(pgnFar,polyshape([1 1 xdim xdim],[ydim 1 1 ydim])); 
far = isinterior(pgnFar,X(:),Y(:));
tracFarX = trac(:,:,1);
tracFarX = tracFarX(far);
tracFarY = trac(:,:,2);
tracFarY = tracFarY(far);
tracFarMag = mean(sqrt(tracFarX.^2+tracFarY.^2));

interior = isinterior(pgnL,Y(:),X(:));
interior = reshape(interior,ydim,xdim);

% nullify traction stresses outside the border
trac(:,:,1) = trac(:,:,1).*interior;
trac(:,:,2) = trac(:,:,2).*interior;
tracGT(:,:,1) = tracGT(:,:,1).*interior;
tracGT(:,:,2) = tracGT(:,:,2).*interior;

% generate maps of magnitude
tracMag = sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
tracGTMag = sqrt(tracGT(:,:,1).^2+tracGT(:,:,2).^2);

% remove vectors smaller than those far away from the cell
tracX = trac(:,:,1).*(tracMag>tracFarMag);
tracY = trac(:,:,2).*(tracMag>tracFarMag);

if cutoff>0
    threshold = prctile(tracGTMag(:),cutoff);
    I = tracMag>=threshold | tracGTMag>=threshold;
    trac(:,:,1) = tracX.*I;
    trac(:,:,2) = tracY.*I;
end

tracFilt(:,:,1)=tracX;
tracFilt(:,:,2)=tracY;
end