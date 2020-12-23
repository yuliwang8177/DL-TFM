clc;clear
TError = table({'fn'},0,0,0,0,0,0,0,0,0,0,'VariableNames',{'File ID', ...
    '2,500Pa','5,000Pa','10,000Pa','20,000Pa','40,000Pa', ...
    '2,500Pa N','5,000Pa N','10,000Pa N','20,000Pa N','40,000Pa N'});
S = 160;
E = [2500 5000 10000 20000 40000];
noise = 0.00765;
fn = sprintf('../generic/cutoff.xlsx');
TCutoff = readtable(fn);
n = 1;
for p = 1:55
    fnt = sprintf('testData/trac/MLData%04d.mat',p);
    try
        fileData = load(fnt);
    catch
        continue;
    end

    cutoff = TCutoff{TCutoff{:,1}==p,'x160'};
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    tracGT = fileData.trac;
    for i=1:5
        fns = sprintf('testData/dspl/MLData%04d-%d.mat',p,E(i));
        fileData = load(fns);
        dspl = fileData.dspl;
        
        fn = sprintf('#%04d',p);
        TError{n,1} = {fn};
        trac = predictTrac(dspl,E(i));
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+1} = err;
        
        dspl = addNoise(dspl,noise);
        trac = predictTrac(dspl,E(i));
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+6} = err;
    end
    n = n + 1;
end
disp('normalized error')
disp(mean(TError{:,2:end}))