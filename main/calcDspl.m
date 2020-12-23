function dspl = calcDspl(trac,E,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dspl = calcDspl(trac,E,brdx,brdy)
%
% Description:
%   calculate displacement field from a stress field
%
% Input:
%   trac = stress field as a SxSx2 tensor 
%   E = Young's modulus of the hydrogel in Pascals
%   brdx,brdy: x and y coordinates of the cell border
%
% Output: strain field
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% parse input and set up parameters
warning('off','all');
if nargin == 4
    brdx = varargin{1};
    brdy = varargin{2};
elseif nargin ~= 2
    disp("Error");
    exit;
end

S = size(trac,1); % size of the image in pixels
N=S-1; %odd number for matrix size
R=S/2; %matrix rad
v = 0.45; % Possion ratio

%% force traction stress outside the cell to be zero
if nargin == 4
   pgn = polyshape(brdx,brdy);
   [ydim,xdim,~] = size(trac);
   [Y,X] = meshgrid(1:S,1:S);
   interior = isinterior(pgn,X(:),Y(:)); 
   interior = reshape(interior,ydim,xdim);
   
   tracIX = trac(:,:,1).*interior;
   tracIY = trac(:,:,2).*interior;
else
   tracIX = trac(:,:,1);
   tracIY = trac(:,:,2);
end

%% construct Boussinesq matrices
G11 = zeros(N,N);
G12 = zeros(N,N);
G21 = zeros(N,N);
G22 = zeros(N,N);
for i=1:N
    for j=1:N
        r = sqrt((i-R)^2 + (j-R)^2);
        G11(i,j) = (1 + v)/(pi*E) * ((1-v)/r + v*(i-R)^2/r^3);
        G12(i,j) = (1 + v)/(pi*E) * (v*(i-R)*(j-R)/r^3);
        G21(i,j) = G12(i,j);
        G22(i,j) = (1 + v)/(pi*E) * ((1-v)/r + v*(j-R)^2/r^3);
    end
end
% singular value calibrated to minimize the error using FTTC plgin of
% imageJ
G11(R,R) = 0.117*10/E;
G12(R,R) = 0;
G21(R,R) = 0;
G22(R,R) = G11(R,R);

%% calculate strain field dspl from traction stress field trac
dspl = zeros(S,S,2);
% define the matrices for Boussinesq equations using combined convolutions
D11 = conv2(tracIX,G11,'same');
D21 = conv2(tracIY,G21,'same');
D12 = conv2(tracIX,G12,'same');
D22 = conv2(tracIY,G22,'same');
dspl(:,:,1)=D11+D21; 
dspl(:,:,2)=D12+D22; 
end
