%clc;clear
warning('off','all');
TError = table({'fn'},0,0,'VariableNames',{'File ID','160','160 N'});
S = 160;
noise = 0.00765;
n = 1;
for p = 1:10
    fn = sprintf('testData/trac/MLData%04d.mat',p);
    try
        fileData = load(fn);
    catch
        continue;
    end
    
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    tracGT = fileData.trac;
    fn = sprintf('testData/dspl/MLData%04d.mat',p);
    fileData = load(fn);
    dspl = fileData.dspl;
    
    fn = sprintf('#%04d',p);
    TError{n,1} = {fn};
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,2} = err;
    
    dspl = addNoise(dspl,noise);
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,3} = err;
    
    n = n + 1;
end
disp('normalized error')
disp(mean(TError{:,2:end}))