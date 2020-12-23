function dsplToTxt(dspl,fttcFn,spacing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dsplToTxt(dspl,fttcFn,spacing)
%
% Description:
%   convert a displacement tensor into a text file suitable for input into
%     the FTTC plugin of ImageJ
%
% Input:
%   dspl: the displacement tensor
%   fttcFn: full path of the text file for input into FTTC
%   spacing: factor of size conversion from the displacement field into
%     the image used FTTC 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen(fttcFn,'w');
format = "%d\t%d\t%4.6f\t%4.6f\r\n";
xdim = size(dspl,1);
ydim = size(dspl,2);
for i=1:xdim
    for j=1:ydim
        fprintf(fileID,format,(i-1)*spacing,(j-1)*spacing,dspl(i, ...
            ydim-j+1,1)*spacing,dspl(i,ydim-j+1,2)*spacing);
    end
end
fclose(fileID);
end