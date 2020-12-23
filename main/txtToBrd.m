function [brdx,brdy] = txtToBrd(brdFn,spacing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [brdx,brdy] = txtToBrd(brdFn)
%
% Description:
%   generate x and y border coordinates from a text file
%
% Input:
%   brdFn: full path of text file containing the zero-origined coordinates 
%     as alternating x and y coordinates separated by spaces
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
% read every other number since x and y coordinates are interspersed
brdx = floor(brd(1:2:end)/spacing)+1; 
brdy = floor(brd(2:2:end)/spacing)+1;
brdy = dimy-brdy+1;
end