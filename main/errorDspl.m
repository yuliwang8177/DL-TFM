function errorD = errorDspl(dspl,dsplGT,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% errorS = errorStrn(strn,strnGT,brdx,brdy,buffer)
%
% Description:
%   calculate error of displacements (calculated from traction stress) 
%   relative to the ground truth (measured)
%
% Input:
%   dspl: (calculated) displacement field
%   dsplGT: (measured) ground truth displacement field
%   brdx,brdy: x and y coordinates of the cell border
%   buffer (optional): distance of around the cell to be included in the 
%      calculation
%
% Output: 
%   error against ground truth, as root mean squared error
%   divided by root mean squared magnitude
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define the region for calculation
warning('off','all');
if nargin == 5
    buffer = varargin{1};
else
    buffer = 0;
end

pgn = polyshape(brdx,brdy);
pgn = polybuffer(pgn,buffer); 
[ydim,xdim,~] = size(dspl);
[Y,X] = meshgrid(1:xdim,1:ydim);
interior = isinterior(pgn,X(:),Y(:));
interior = reshape(interior,ydim,xdim);
dspl(:,:,1) = dspl(:,:,1).*interior;
dspl(:,:,2) = dspl(:,:,2).*interior;

dspl(:,:,1) = dspl(:,:,1).*interior;
dspl(:,:,2) = dspl(:,:,2).*interior;
dsplGT(:,:,1) = dsplGT(:,:,1).*interior;
dsplGT(:,:,2) = dsplGT(:,:,2).*interior;

dsplMag = sqrt(dspl(:,:,1).^2+dspl(:,:,2).^2);
dsplGTMag = sqrt(dsplGT(:,:,1).^2+dsplGT(:,:,2).^2);

mse = sum((dspl(:,:,1)-dsplGT(:,:,1)).^2+(dspl(:,:,2)-dsplGT(:,:,2)).^2,'all')/numel(dsplMag);
rmse = sqrt(mse); 
msm = sum(dsplGT(:,:,1).^2+dsplGT(:,:,2).^2,'all')/numel(dsplGTMag);
rmsm = sqrt(msm);
errorD = rmse/rmsm;
end


