%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example code to generate a 160x160x2 displacement field, dspl160, from
% a displacement field dspl80 of 80x80x2 using interpolation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[x,y] = meshgrid(1:80);
[xx,yy] = meshgrid(0.5:0.5:80);
dspl160 = zeros(160, 160,2);
dspl160(:,:,1) = interp2(x, y, dspl80(:,:,1), xx, yy ,'spline');
dspl160(:,:,2) = interp2(x, y, dspl80(:,:,2), xx, yy, 'spline');


