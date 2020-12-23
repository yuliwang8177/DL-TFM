clc;clear
TError = table({'fn'},0,0,0,0,0,0,0,0,'VariableNames',{'File ID','1,000Pa','2,000Pa','4,000Pa','8,000Pa','1,000Pa N','2,000Pa N','4,000Pa N','8,000Pa N'});
S = 160;
T = [1000 2000 4000 8000];
noise = 0.00765;
fn = sprintf('../generic/cutoff.xlsx');
TCutoff = readtable(fn);
n = 1;
for p = 1:55
    fnt = sprintf('testData/trac/MLData%04d-1000.mat',p);
    try
        fileData = load(fnt);
    catch
        continue;
    end
    
    cutoff = TCutoff{TCutoff{:,1}==p,'x160'};
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    for i=1:4
        fnt = sprintf('testData/trac/MLData%04d-%d.mat',p,T(i));
        fileData = load(fnt);
        tracGT = fileData.trac;
        fns = sprintf('testData/dspl/MLData%04d-%d.mat',p,T(i));
        fileData = load(fns);
        dspl = fileData.dspl;
        
        fn = sprintf('#%04d',p);
        TError{n,1} = {fn};
        trac = predictTrac(dspl,10670);
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+1} = err;
        
        dspl = addNoise(dspl,noise);
        trac = predictTrac(dspl,10670);
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+5} = err;
    end
    n = n + 1;
end
disp('normalized error')
disp(mean(TError{:,2:end}))