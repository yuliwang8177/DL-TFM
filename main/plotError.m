function plotError(fld,fldGT,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotError(fld,fldGT,brdx,brdy,cutoff)
%
% Description:
%   render the error between a measureed field and ground truth as heat
%   map
%
% Input:
%   fld: measured field
%   fldGT: ground truth field
%   brdx,brdy: x and y coordinates of the cell border 
%   cutoff (optional): percentile threshold, errors are not rendered if the
%      magnitude of the stress falls below the cutoff percentile
%
% Output:
%   heat map of the magnitude of error vectors within the cell border
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% data preparation
warning('off','all');
if nargin==5
    cutoff = varargin{1};
else
    cutoff = 0;
end
pgn = polyshape(brdx,brdy);
[ydim,xdim,~] = size(fld);
[Y,X] = meshgrid(1:xdim,1:ydim);
interior = isinterior(pgn,X(:),Y(:));
interior = reshape(interior,ydim,xdim);

fldX = fld(:,:,1);
fldGTX = fldGT(:,:,1);
fldX = fldX.*interior;
fldGTX = fldGTX.*interior;

fldY = fld(:,:,2);
fldGTY = fldGT(:,:,2);
fldY = fldY.*interior;
fldGTY = fldGTY.*interior;

fldMag = sqrt(fldX.^2+fldY.^2);
fldGTMag = sqrt(fldGTX.^2+fldGTY.^2);
errorMag = sqrt((fldX-fldGTX).^2+(fldY-fldGTY).^2);

threshold = prctile(fldMag(interior),cutoff);
errorMag(fldMag<threshold) = 0;
% normalize by the magnitude of the field
fldErr = errorMag./(fldMag+fldGTMag)*2;
fldErr(isnan(fldErr)) = 0;

%% render heat map
figure;
pc = pcolor(fldErr');
pc.LineStyle = 'none';
xlim([0 xdim]);
xticks(0:10:xdim);
ylim([0 ydim]);
yticks(0:10:ydim);

%colormap(parula)
colormap(hot)
colorbar;
hold on

plot(brdx,brdy,'--w');
hold off
daspect([1 1 1]);