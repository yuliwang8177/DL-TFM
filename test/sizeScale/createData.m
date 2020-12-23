clc;clear;
for p=1:55
    fnt = sprintf('../generic/testData160/trac/MLData00%02d.mat',p);
    try
        fileData = load(fnt);
    catch
        continue;
    end
    trac160 = fileData.trac;
    brdx160 = fileData.brdx;
    brdy160 = fileData.brdy;
    fnt160 = sprintf('testData/trac160/MLData00%02d.mat',p);
    copyfile(fnt,fnt160);    
        
    fns = sprintf('../generic/testData160/dspl/MLData00%02d.mat',p);   
    fileData = load(fns);
    dspl160 = fileData.dspl;
    fns160 = sprintf('testData/dspl160/MLData00%02d.mat',p);
    copyfile(fns,fns160);      
   
    %% rescale to 104x104
    magnify = 104/160;
    brdx = (brdx160 - 80)*magnify + 52;
    brdy = (brdy160 - 80)*magnify + 52;
    
    trac = zeros(104,104,2);
    trac(:,:,1) = imresize(trac160(:,:,1),magnify,'method','bilinear');
    trac(:,:,2) = imresize(trac160(:,:,2),magnify,'method','bilinear');
    fnt = sprintf('testData/trac104/MLData00%02d.mat',p);
    save(fnt,'trac','brdx','brdy');
    
    dspl = zeros(104,104,2);
    dspl(:,:,1) = imresize(dspl160(:,:,1),magnify,'method','bilinear')*magnify;
    dspl(:,:,2) = imresize(dspl160(:,:,2),magnify,'method','bilinear')*magnify;
    fns = sprintf('testData/dspl104/MLData00%02d.mat',p);
    save(fns,'dspl','brdx','brdy');

    %% rescale to 256x256
    magnify = 256/160;
    brdx = (brdx160 - 80)*magnify + 128;
    brdy = (brdy160 - 80)*magnify + 128;
    
    trac = zeros(256,256,2);
    trac(:,:,1)=imresize(trac160(:,:,1),magnify,'method','bilinear');
    trac(:,:,2)=imresize(trac160(:,:,2),magnify,'method','bilinear');
    fnt = sprintf('testData/trac256/MLData00%02d.mat',p);
    save(fnt,'trac','brdx','brdy');
    
    dspl = zeros(256,256,2);
    dspl(:,:,1) = imresize(dspl160(:,:,1),magnify,'method','bilinear')*magnify;
    dspl(:,:,2) = imresize(dspl160(:,:,2),magnify,'method','bilinear')*magnify;
    fns = sprintf('testData/dspl256/MLData00%02d.mat',p);
    save(fns,'dspl','brdx','brdy');

end
