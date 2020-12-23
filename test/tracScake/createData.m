clc;clear;
S=160;

mag=S/104.0;
E=10670; %Young's modulus 
v=0.45; %Possion ratio

% kernel for expanding point stress into patch
kernel=[0.4 0.6 0.4;0.6 1.0 0.6;0.4 0.6 0.4];

for p=1:55
    fn = sprintf('../generic/rawTestData/MLData%02d.mat',p);
    try
        ML=load(fn);
    catch
        continue;
    end
    MLData=ML.MLData;
    if max(abs(MLData(3,:)))<1
        MLData(3,:)=MLData(3,:)*10;
    end
    
    %%adjust strength
    %length of traction stress vectors, remove tiny vectors
    strength=MLData(3,:);
    strength(abs(strength)<1)=0;
    %balance active and passive forces
    %positive and negative along x
    sxp=-strength(strength>0) .* cos(MLData(1,strength>0)*pi/180);
    sxn=strength(strength<0) .* cos(MLData(1,strength<0)*pi/180);
    %positive and negative along yMLData(3,:)
    syp=-strength(strength>0) .* sin(MLData(1,strength>0)*pi/180);
    syn=strength(strength<0) .* sin(MLData(1,strength<0)*pi/180);
    %multiplication factor for negative components to match positive components
    adj = -(sum(sxp)+sum(syp))/(sum(sxn)+sum(syn));
    if adj==0 || isnan(adj)
        continue;
    end
    strength(strength<0)=strength(strength<0)*adj;
    MLData(3,:)=strength;

    %determine cell border
    [x,y]=pol2cart(MLData(1,:)*pi/180,MLData(2,:));
    %adjust the length of the longer dimension
    adj=64.0*mag/max(max(x)-min(x),max(y)-min(y));
    MLData(2,:)=MLData(2,:)*adj;
    [x,y]=pol2cart(MLData(1,:)*pi/180,MLData(2,:));
    x=ceil(x);
    y=ceil(y);
    %center the cell
    dx=ceil((S-max(x)+min(x))/2)-min(x);
    dy=ceil((S-max(y)+min(y))/2)-min(y);
    brdx=x+dx;
    brdy=y+dy;
    
    %distal ends of stress vectors
    [x,y]=pol2cart(MLData(1,:)*pi/180,MLData(2,:));
    x=ceil(x)+dx;
    y=ceil(y)+dy;
    
    trac = zeros(S,S,2);
    %lengths of stress vectors along x and y
    for i=1:360
        trac(x(i),y(i),1)=trac(x(i),y(i),1)-abs(MLData(3,i)).*cos(MLData(1,i)*pi/180);
        trac(x(i),y(i),2)=trac(x(i),y(i),2)-abs(MLData(3,i)).*sin(MLData(1,i)*pi/180);
    end
        
    xError=sum(trac(:,:,1),'all')/sum(abs(trac(:,:,1)),'all');
    yError=sum(trac(:,:,2),'all')/sum(abs(trac(:,:,2)),'all');
    if abs(xError)<0.1 && abs(yError)<0.1
        trac1 = zeros(S,S,2);
        
        thinning=2;
        %%move traction stress vectors by a random distance from the edge
        MLData1a=MLData(:,1:thinning:360);
        MLData1a(2,:)=MLData1a(2,:)-random('Poisson',1,[1,360/thinning])*mag;

        [x,y]=pol2cart(MLData1a(1,:)*pi/180,MLData1a(2,:)-3);
        x=ceil(x)+dx;
        y=ceil(y)+dy;
        
        %lengths of stress vectors along x and y
        for i=1:(360/thinning)
            trac1(x(i),y(i),1) = trac1(x(i),y(i),1)-abs(MLData1a(3,i)).*cos(MLData1a(1,i)*pi/180);
            trac1(x(i),y(i),2) = trac1(x(i),y(i),2)-abs(MLData1a(3,i)).*sin(MLData1a(1,i)*pi/180);
        end
        
        thinning=6;
        %%move traction stress vectors by a random distance from the edge
        MLData1b=MLData(:,1:thinning:360);
        MLData1b(2,:)=MLData1b(2,:)-random('Poisson',2,[1,360/thinning])*mag;
        
        [x,y]=pol2cart(MLData1b(1,:)*pi/180,MLData1b(2,:)-3);
        x=ceil(x)+dx;
        y=ceil(y)+dy;
        
        %lengths of stress vectors along x and y
        for i=1:(360/thinning)
            trac1(x(i),y(i),1) = trac1(x(i),y(i),1)-abs(MLData1b(3,i)).*cos(MLData1b(1,i)*pi/180);
            trac1(x(i),y(i),2) = trac1(x(i),y(i),2)-abs(MLData1b(3,i)).*sin(MLData1b(1,i)*pi/180);
        end
        
        thinning=10;
        %%move traction stress vectors by a random distance from the edge
        MLData2=MLData(:,1:thinning:360);
        MLData2(2,:)=MLData2(2,:)-random('Poisson',6,[1,360/thinning])*mag;

        [x,y]=pol2cart(MLData2(1,:)*pi/180,MLData2(2,:)-3);
        x=ceil(x)+dx;
        y=ceil(y)+dy;
  
        trac2=zeros(S,S,2);
        %lengths of stress vectors along x and y
        for i=1:(360/thinning)
            trac2(x(i),y(i),1) = trac2(x(i),y(i),1)-abs(MLData2(3,i)) .* cos(MLData2(1,i)*pi/180);
            trac2(x(i),y(i),2) = trac2(x(i),y(i),2)-abs(MLData2(3,i)) .* sin(MLData2(1,i)*pi/180);
        end        
        
        trac2(:,:,1)=conv2(trac2(:,:,1),kernel,'same');
        trac2(:,:,2)=conv2(trac2(:,:,2),kernel,'same');
        
        [G11, G12, G21, G22]=makeTensor(E,v,S);
        
        for magnitude=[1000 2000 4000 8000]
            trac=zeros(S,S,2);
            trac(:,:,1)=trac2(:,:,1)+trac1(:,:,1);
            trac(:,:,2)=trac2(:,:,2)+trac1(:,:,2);
            
            pgn=polyshape(brdx,brdy);
            [Y,X]=meshgrid(1:S,1:S);
            interior=isinterior(pgn,X(:),Y(:));
            tracmag=sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
            tracmagInterior=tracmag(interior);
            f=magnitude/max(tracmagInterior);
            trac(:,:,1)=trac(:,:,1)*f;
            trac(:,:,2)=trac(:,:,2)*f;
            
            dspl = zeros(S,S,2);
            D11=conv2(trac(:,:,1),G11,'same');
            D21=conv2(trac(:,:,2),G21,'same');
            D12=conv2(trac(:,:,1),G12,'same');
            D22=conv2(trac(:,:,2),G22,'same');
            dspl(:,:,1)=D11+D21; %x strain
            dspl(:,:,2)=D12+D22; %y strain
            
            fn1 = sprintf('testData/trac/MLData%04d-%d.mat',p,magnitude);
            fn2 = sprintf('testData/dspl/MLData%04d-%d.mat',p,magnitude);
            save(fn1,'trac','brdx','brdy');
            save(fn2,'dspl','brdx','brdy');
        end
    end
end

function [G11,G12,G21,G22]=makeTensor(E,v,S)
N=S-1; %odd number for matrix size
R=S/2; %matrix rad
G11 = zeros(N,N);
G12 = zeros(N,N);
G21 = zeros(N,N);
G22 = zeros(N,N);
for i=1:N
    for j=1:N
        r=sqrt((i-R)^2 + (j-R)^2);
        G11(i,j)=(1 + v)/(pi*E) * ((1-v)/r + v*(i-R)^2/r^3);
        G12(i,j)=(1 + v)/(pi*E) * (v*(i-R)*(j-R)/r^3);
        G21(i,j)=G12(i,j);
        G22(i,j)=(1 + v)/(pi*E) * ((1-v)/r + v*(j-R)^2/r^3);
    end
end
G11(R,R)=0.117*10/E;
G12(R,R)=0;
G21(R,R)=0;
G22(R,R)=G11(R,R);
end
