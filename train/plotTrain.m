function plotTrain(S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotTrain(S)
%
% Description: view training dataset (without augmentation) as quiver plots
%
% Input: 
%   S: size of the neural network; must be multiples of 8 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear;clc;
scale = 4;
fdn = sprintf('trainData%d\\trac',S);
tracds = fileDatastore(fdn,'ReadFcn',@load,'FileExtensions','.mat');
fdn = sprintf('trainData%d\\dspl',S);
dsplds = fileDatastore(fdn,'ReadFcn',@load,'FileExtensions','.mat');
for i = 1:numel(tracds.Files)
    tracData=load(tracds.Files{i});
    trac=tracData.trac;
    brdx=tracData.brdx;
    brdy=tracData.brdy;
    dsplData=load(dsplds.Files{i});
    dspl=dsplData.dspl;
    [~,fn,~]=fileparts(tracds.Files{i});
    if ~contains(fn,'-00') && ~contains(fn,'-08')
        continue;
    end
    display(fn);
    tracmag=sqrt(trac(:,:,1).^2+trac(:,:,2).^2);
    dsplmag=sqrt(dspl(:,:,1).^2+dspl(:,:,2).^2);
    
    figure(1);
    pc = pcolor(tracmag');
    pc.LineStyle='none';
    pc.FaceColor='interp';
    xlim([0 size(trac,1)]);
    xticks(0:10:size(trac,1));
    ylim([0 size(trac,2)]);
    yticks(0:10:size(trac,2));
    colormap(jet);
    colorbar;
    hold on;
    plot(brdx, brdy, '--w');
    hold off;
    legend(fn,'location','northoutside');
    daspect([1 1 1]);
    
    figure(2);
    [J,I]=meshgrid(1:size(trac,2),1:size(trac,1));
    D1 = trac(:,:,1);
    D2 = trac(:,:,2);
    q = quiver(I,J,D1*scale,D2*scale,0);
    xlim([0 size(trac,1)]);
    xticks(0:10:size(trac,1));
    ylim([0 size(trac,2)]);
    yticks(0:10:size(trac,2));
    hold on;
    plot(brdx,brdy,'--b');
    hold off;
    legend(fn,'location','northoutside');
    daspect([1 1 1]);
    drawnow;
    
    figure(3);
    pc = pcolor(dsplmag');
    pc.LineStyle='none';
    pc.FaceColor='interp';
    xlim([0 size(dspl,1)]);
    xticks(0:10:size(dspl,1));
    ylim([0 size(dspl,2)]);
    yticks(0:10:size(dspl,2));
    colormap(jet);
    colorbar;
    hold on;
    plot(brdx, brdy, '--w');
    hold off;
    legend(fn,'location','northoutside');
    daspect([1 1 1]);
    
    figure(4);
    D1 = dspl(:,:,1);
    D2 = dspl(:,:,2);
    q = quiver(I,J,D1,D2,0);
    xlim([0 size(dspl,1)]);
    xticks(0:10:size(dspl,1));
    ylim([0 size(dspl,2)]);
    yticks(0:10:size(dspl,2));
    hold on;
    plot(brdx,brdy,'--b');
    hold off;
    legend(fn,'location','northoutside');
    daspect([1 1 1]);
    drawnow;
    
    pause;
end
end
