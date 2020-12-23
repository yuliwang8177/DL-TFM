clear; close all;
warning('off','all');
S = 104;
Noise = 0.00765;
TCutoff = readtable('cutoff.xlsx');
k = 1;
for p = 1:55
    fn = sprintf('testData%d/trac/MLData%04d.mat',S,p);
    try
        fileData = load(fn);
    catch
        continue;
    end

    cutoff = TCutoff{TCutoff{:,1}==p,'x104'};
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    tracGT = fileData.trac;
    fn = sprintf('testData%d/strn/MLData%04d.mat',S,p);
    fileData = load(fn);   
    strn = fileData.strn;
    strn = addNoise(strn,Noise*S/104);
    strnToTxt;
    
    pause;
    fttcToTrac;
    e(k) = errorTrac(trac,tracGT,brdx,brdy,cutoff) % large stress only
    %e(k) = errorTrac(trac,tracGT,brdx,brdy,0) % all interior stress
    k = k + 1;
end
e = e';

