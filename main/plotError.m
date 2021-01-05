function plotError(fld,fldGT,brdx,brdy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotError(fld,fldGT,brdx,brdy)
%
% Description:
%   render the error between a measureed field and ground truth as heat
%   map
%
% Input:
%   fld: measured field
%   fldGT: ground truth field
%   brdx,brdy: x and y coordinates of the cell border 
%
% Output:
%   heat map of the magnitude of error vectors within the cell border
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% data preparation
warning('off','all');

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

%fldMag = (sqrt(fldX.^2+fldY.^2)+sqrt(fldGTX.^2+fldGTY.^2))/2;
fldGTMag = sqrt(fldGTX.^2+fldGTY.^2);
errorMag = sqrt((fldX-fldGTX).^2+(fldY-fldGTY).^2);

% normalize by the magnitude of the field
fldErr = errorMag./fldGTMag;
fldErr(isnan(fldErr)|isinf(fldErr)) = 0;

%% render heat map
figure;
pc = pcolor(fldErr');
pc.LineStyle = 'none';
pc.FaceColor = 'interp';
xlim([0 xdim]);
xticks(0:10:xdim);
ylim([0 ydim]);
yticks(0:10:ydim);

%colormap(parula)
colormap(jet)
colorbar;
hold on

plot(brdx,brdy,'--w');
hold off
daspect([1 1 1]);