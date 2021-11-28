function [brdx,brdy] = txtToBrd(brdFn,sz,spacing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [brdx,brdy] = txtToBrd(brdFn,sz,spacing)
%
% Description:
%   generate x and y border coordinates from a text file
%
% Input:
%   brdFn: full path of text file containing the zero-origined coordinates 
%     as either a vector with alternating x and y coordinates separated by
%     spaces, or a two column matrix with x and y coordinates in the first
%     and cecond column respectively
%   sz: size of the image where the border was drawn 
%   spacing: factor of conversion from input coordinates into output 
%     coordinates, e.g. 5 if 800x800 is rescaled as 160x160   
%
% Output: 
%   brdx,brdy: x and y coordinates of the cell border
%
% Notes: the border must be contained within a space of 104x104, 160x160,
%   or 256x256
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

brd = load(brdFn);
if length(brd)==numel(brd)
   % read every other number since x and y coordinates are interspersed
   brdx = floor(brd(1:2:end)/spacing)+1; 
   brdy = floor(brd(2:2:end)/spacing)+1;
elseif size(brd,2)==2
   % read x from the first column and y from the second column
   brdx = floor(brd(:,1)'/spacing)+1;
   brdy = floor(brd(:,2)'/spacing)+1;
end
sz = floor(sz/spacing);
brdy = sz-brdy+1;
end