function errorT = errorTrac(trac,tracGT,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% errorT = errorTrac(trac,tracGT,brdx,brdy,cutoff)
%
% Description:
%   calculate error of traction stress field relative to the ground truth, 
%   as normalized root mean squared error, for cell interior only;
%   if cutoff > 0 then calculate only the error of vectors > cutoff, 
%   including positions where only ground truth is > cutoff
%
% Input:
%   trac: traction stress field
%   tracGT: ground truth traction stress field
%   brdx,brdy: x and y coordinates of the cell border
%   cutoff(optional); cutoff percentile for inclusion, e.g. 95 means 
%      caloulating only the error of top 5% vectors 
%
% Output: 
%   error against ground truth, as root mean squared error
%   divided by root mean squared magnitude
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define the region within the cell for calculating the error
warning('off','all');
if nargin==4
    cutoff = 0;
elseif nargin==5
    cutoff = varargin{1};
else
    disp('Error')
end
pgn = polyshape(brdx,brdy);
[ydim,xdim,~] = size(trac);
[X,Y] = meshgrid(1:xdim,1:ydim);
interior = isinterior(pgn,Y(:),X(:));
interior = reshape(interior,ydim,xdim);

trac(:,:,1) = trac(:,:,1).*interior;
trac(:,:,2) = trac(:,:,2).*interior;
tracGT(:,:,1) = tracGT(:,:,1).*interior;
tracGT(:,:,2) = tracGT(:,:,2).*interior;

tracMag = sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
tracGTMag = sqrt(tracGT(:,:,1).^2+tracGT(:,:,2).^2);

if cutoff>0
    threshold = prctile(tracGTMag(interior),cutoff);
    I = tracMag>threshold | tracGTMag>threshold;
    trac(:,:,1) = trac(:,:,1).*I;
    trac(:,:,2) = trac(:,:,2).*I;
    tracGT(:,:,1) = tracGT(:,:,1).*I;
    tracGT(:,:,2) = tracGT(:,:,2).*I;
else
    I = ones(ydim,xdim);
end

mse = sum((trac(:,:,1)-tracGT(:,:,1)).^2 + (trac(:,:,2)-tracGT(:,:,2)).^2,'all')/nnz(interior.*I);
rmse = sqrt(mse);
msm = sum(tracGT(:,:,1).^2+tracGT(:,:,2).^2,'all')/nnz(interior.*I);
rmsm = sqrt(msm);
errorT = rmse/rmsm;

end