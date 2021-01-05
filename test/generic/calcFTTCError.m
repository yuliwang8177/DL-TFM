clear; close all;
warning('off','all');
S = 104;
Noise = 0.00765;
k = 1;
for p = 25:25 %1:55
    fn = sprintf('testData%d/trac/MLData%04d.mat',S,p);
    try
        fileData = load(fn);
    catch
        continue;
    end

    brdx = fileData.brdx;
    brdy = fileData.brdy;
    tracGT = fileData.trac;
    fn = sprintf('testData%d/dspl/MLData%04d.mat',S,p);
    fileData = load(fn);   
    dspl = fileData.dspl;
    %dspl = addNoise(dspl,Noise);
    dsplToTxt(dspl,'c:/Temp/dspl.txt',7);
    
    pause; % trigger FTTC here
    trac = fttcToTrac('c:/Temp/Traction_dspl.txt',7);
    e(k) = errorTrac(trac,tracGT,brdx,brdy) % large stress only
    k = k + 1;
end
e = e';

