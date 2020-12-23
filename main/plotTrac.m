function plotTrac(trac,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Description:
%   render traction stress field as both quiver vector plot and heat map
%
% Input:
%   trac: traction stress field
%   brdx (optional): x coordinates of the border to be superimposed on the plot
%   brdy (optional): y coordinates of the border to be superimposed on the plot
%   scale (optional): relative length of quiver vectors, default = 0.002
%   thinning (optional): number of quiver vectors to skip to avoid over 
%      crowding, default = 0
%
% Output:
%  figures of quiver plot and heat map (pseudocolor rendering of the 
%  magnitude)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parsing input
if nargin==1
    scale = 0.002; 
    thinning = 1; % plot every n vectors in quiver plot
elseif nargin==5
    brdx = varargin{1};
    brdy = varargin{2};    
    scale = varargin{3};
    thinning = varargin{4}+1;
elseif nargin==3
    if numel(varargin{1})==1 && numel(varargin{2})==1
        scale = varargin{1};
        thinning = varargin{2}+1;
    else
        
        brdx = varargin{1};
        brdy = varargin{2};
        scale = 0.002;
        thinning = 1;
    end
else
    disp("Error");
    exit;
end

% to modify or skip (scalebar = 0) as appropriate
scalebar = 4000;
scalebarx = 5;
scalebary = 12;

color = [0 0.5 0.5];
qvwidth = 1; 
brdwidth = 1; 

%% data preparation
mag = sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
if scalebar>0
   trac(scalebarx,scalebary,1) = scalebar;
   trac(scalebarx,scalebary,2) = 0;
end

[J,I] = meshgrid(1:size(trac,2),1:size(trac,1));
indx = ceil(1:thinning:numel(I));
D1 = trac(:,:,1);
D1 = D1(indx);
I = I(indx);

indx = ceil(1:thinning:numel(J));
D2 = trac(:,:,2);
D2 = D2(indx);
J = J(indx);

%% draw quiver vector map of stresses
figure('name','Stress Vectors');
q = quiver(I,J,D1*scale,D2*scale,0);
q.Color = color;
q.LineWidth = qvwidth;
xlim([0 size(trac,1)]);
xticks(0:10:size(trac,1));
ylim([0 size(trac,2)]);
yticks(0:10:size(trac,2));
if scalebar>0
    lgd = sprintf('%d Pascals',scalebar);
    text(5,5,lgd);
end
if exist('brdx','var') && exist('brdy','var')
    hold on
    plot(brdx,brdy,'--b','LineWidth',brdwidth);
    hold off;
end
daspect([1 1 1]);

%% draw heat map of stress magnitudes
figure('name','Stress Heat Map');
pc = pcolor(mag');
pc.LineStyle = 'none';
pc.FaceColor = 'interp';
xlim([0 size(trac,1)]);
xticks(0:10:size(trac,1));
ylim([0 size(trac,2)]);
yticks(0:10:size(trac,2));
colormap(jet)
colorbar;
if exist('brdx','var') && exist('brdy','var')
    hold on
    plot(brdx, brdy, '--w','LineWidth',brdwidth);
    hold off;
end
daspect([1 1 1]);
end
