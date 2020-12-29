clc;clear;
TError = table({'fn'},0,0,0,0,'VariableNames',{'File ID','104x104','256x256','104x104 N','256x256 N'});
noise = 0.00765;
n = 1;
for p=1:55
    fn = sprintf('testData/trac160/MLData00%02d.mat',p);
    try
        tData160=load(fn);
    catch
        continue;
    end

    fn = sprintf('testData/trac104/MLData00%02d.mat',p);
    tData104=load(fn);
    fn = sprintf('testData/trac256/MLData00%02d.mat',p);
    tData256=load(fn);
    fn = sprintf('testData/dspl104/MLData00%02d.mat',p);
    sData104 = load(fn);
    fn = sprintf('testData/dspl256/MLData00%02d.mat',p);
    sData256 = load(fn);
    
    fn = sprintf('#00%02d',p);
    TError{n,1} = {fn};
    
    dspl = sData104.dspl;
    tracGT = tData104.trac;
    brdx = tData104.brdx;
    brdy = tData104.brdy;
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,2} = err;
    
    dspl = addNoise(dspl,noise);
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,4} = err;   
    
    dspl = sData256.dspl;
    tracGT = tData256.trac;
    brdx = tData256.brdx;
    brdy = tData256.brdy;    
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,3} = err;
    
    dspl = addNoise(dspl,noise);
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,5} = err; 
    n = n + 1;
end
disp('normalized error')
disp(mean(TError{:,2:end}))