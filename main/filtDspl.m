function dsplFilt = filtDspl(dspl,brdx,brdy,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dsplFilt = filtDspl(dspl,brdx,brdy,buffer,range,medNear,medFar,threshold)
%
% Description:
%   filter displacement vectors, first correct residual alignment errors,
%   then apply a stronger median filter to vectors far away from the cell  
%   and a weak median filter to vectors around the cell, finally
%   replace vectors that has too large a normalized derivative against the
%   neighbors
%
% Input:
%   dspl: displacement field to filter
%   brdx,brdy: x and y coordinates of the cell border 
%   buffer (optional): buffer zone around the cell to avoid filtering
%   range (optional): distance from the cell of near and far 
%     exterior regions; must be specified if med1 and med2 are specified
%   medNear,medFar (optional): window size of median filter to be applied  
%     to near and far exterior regions, defaults to 0 and 9 respectively
%   threshold (optional): upper threshold of normalized derivatives; vectors with a
%     normalized derivative > threshold are replaced with local average,
%     default = 4
%
% Output: filtered displacement field
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parse input
warning('off','all');
buffer = 3;
range = 20;
medNear = 0;
medFar = 9;
threshold = 4;
if nargin==5
    buffer = varargin{1};
    range = varargin{2};
elseif nargin==7
    buffer = varargin{1};
    range = varargin{2};
    medNear = varargin{3};
    medFar = varargin{4};
elseif nargin==8
    buffer = varargin{1};
    range = varargin{2};
    medNear = varargin{3};
    medFar = varargin{4};
    threshold = varargin{5};
else
    disp("Error");
    exit;
end    

%% define cellular region and far exterior region
[ydim,xdim] = size(dspl, [1 2]);
[Y,X] = meshgrid(1:xdim,1:ydim);

%% define regions
% define interior region
pgnIn = polyshape(brdx,brdy);
% include buffer zone
pgnIn = polybuffer(pgnIn,buffer);
% define near exterior
pgnNear = polybuffer(pgnIn,range);
pgnNear = xor(pgnNear,pgnIn);
near = isinterior(pgnNear,X(:),Y(:));
% define far exterior region
pgnFar = polybuffer(pgnIn,range);
pgnFar = xor(pgnFar,polyshape([1 1 xdim xdim],[ydim 1 1 ydim])); 
far = isinterior(pgnFar,X(:),Y(:));

% median filter displacements for near exterior
if medNear>0
    dsplNearX = medfilt2(dspl(:,:,1),[medNear,medNear]);
    dsplNearY = medfilt2(dspl(:,:,2),[medNear,medNear]);
end
% median filter displacements for far exterior
if medFar>0
    dsplFarX = medfilt2(dspl(:,:,1),[medFar,medFar]);
    dsplFarY = medfilt2(dspl(:,:,2),[medFar,medFar]);
end

% calculate residual displacements in far exterior
dsplX = dsplFarX(:);
dsplX = dsplX(far);
dsplY = dsplFarY(:);
dsplY = dsplY(far);
residualX = mean(dsplX);
residualY = mean(dsplY);

%% perform corrections
%replace far displacements with median filtered displacements
for i=1:numel(X)
    if far(i)
        dspl(X(i),Y(i),1) = dsplFarX(X(i),Y(i));
        dspl(X(i),Y(i),2) = dsplFarY(X(i),Y(i));
    elseif near(i) && medNear>0
        dspl(X(i),Y(i),1) = dsplNearX(X(i),Y(i));
        dspl(X(i),Y(i),2) = dsplNearY(X(i),Y(i));
    end
end

% correct displacements by residual displacements
dsplC(:,:,1) = dspl(:,:,1)-residualX;
dsplC(:,:,2) = dspl(:,:,2)-residualY;
dsplFiltX=dsplC(:,:,1);
dsplFiltY=dsplC(:,:,2);

%% replace vectors with a large normalized derivative
if threshold>0
    % kernel for LaPlace filter
    k1=[-0.5 -1 -0.5;-1 6 -1;-0.5 -1 -0.5];
    % kernel for averaging neighbors
    k2=[0.5 1 0.5;1 0 1;0.5 1 0.5]/6;
    
    % calculate derivatives
    df(:,:,1)=conv2(dsplC(:,:,1),k1,'same');
    df(:,:,2)=conv2(dsplC(:,:,2),k1,'same');
    
    % normalize against the magnitude of displacement
    mag=sqrt(dsplC(:,:,1).^2+dsplC(:,:,2).^2);
    df=df./mag;
    dfmag=sqrt(df(:,:,1).^2+df(:,:,2).^2);
    
    % values for replacement where the normalized derivative is too large
    rep1=conv2(dsplC(:,:,1),k2,'same');
    rep2=conv2(dsplC(:,:,2),k2,'same');
    
    dsplFiltX(dfmag>threshold)=rep1(dfmag>threshold);
    dsplFiltY(dfmag>threshold)=rep2(dfmag>threshold);
end

dsplFilt(:,:,1)=dsplFiltX;
dsplFilt(:,:,2)=dsplFiltY;
end
