function dspl = pivToDspl(pivFn,size,spacing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dspl = pivToDspl(pivFn,size,spacing)
%
% Description:
%   convert the output of ImageJ PIV to a displacement tensor
%
% Input:
%   pivFn: full path of text file generated by the PIV plugin of ImageJ
%   size: image size for PIV 
%   spacing: factor of size conversion from image used in PIV to 
%     image used in deep learning (104, 160, or 256) 
%
% Output: 
%   dspl: tensor of displacement
%
% Notes: see files PIV_parameters XXX.pdf for example parameters for the 
%   PIV plugin where XXX is 104, 160, or 256 indicating the image size
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

piv = load(pivFn);
piv = piv(:,1:4);
piv(:,1) = floor(piv(:,1))/spacing+1;
piv(:,2) = floor(piv(:,2))/spacing+1;
piv(:,2) = size-piv(:,2);

dim = floor(size/spacing);
dspl = zeros(dim,dim,2);
for i=1:size
    dspl(piv(i,1),piv(i,2),1) = piv(i,3)/spacing;
    dspl(piv(i,1),piv(i,2),2) = -piv(i,4)/spacing;
end
end
