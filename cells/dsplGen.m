clear; clc;
warning('off','all');
spacing=7;
xmax=727;
ymax=727;
xdim=floor((xmax+1)/spacing);
ydim=floor((ymax+1)/spacing);

for i=1:14
    try
        brdfn=sprintf('data/brd%03d.txt',i);
        brd=load(brdfn);
        pivfn=sprintf('data/PIV_Stack%03d.txt',i);
        piv=load(pivfn);
    catch
        continue;
    end
    
    brdx=floor(brd(1:2:end)/spacing)+1;
    brdy=floor(brd(2:2:end)/spacing)+1;
    brdy=ydim-brdy+1;
    
    piv=piv(:,1:4);
    piv(:,1)=floor((piv(:,1))/spacing)+1;
    piv(:,2)=floor((piv(:,2))/spacing)+1;
    piv(:,2)=ydim-piv(:,2)+1;
    piv=piv(:,1:4);
    
    dspl=zeros(xdim,ydim,2);
    for j=1:length(piv)
        dspl(piv(j,1),piv(j,2),1)=piv(j,3)/spacing;
        dspl(piv(j,1),piv(j,2),2)=-piv(j,4)/spacing;
    end
    
    dspl=filtDspl(dspl,brdx,brdy,25,5,9);
    
    fn=sprintf('dspl/MLData%03d.mat',i);
    save(fn,'dspl','brdx','brdy');
end


