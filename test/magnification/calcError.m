clc;clear;
TError = table({'fn'},0,0,0,0,'VariableNames',{'File ID','0.8x','1.25x','0.8x N','1.25x N'});
noise = 0.00765;
n = 1;
for p=1:55
    fn = sprintf('testData/trac160/MLData00%02d.mat',p);
    try
        tData160=load(fn);
    catch
        continue;
    end

    fn = sprintf('testData/trac160S/MLData00%02d.mat',p);
    tDataS=load(fn);
    fn = sprintf('testData/trac160L/MLData00%02d.mat',p);
    tDataL=load(fn);
    fn = sprintf('testData/dspl160S/MLData00%02d.mat',p);
    sDataS = load(fn);
    fn = sprintf('testData/dspl160L/MLData00%02d.mat',p);
    sDataL = load(fn);
    
    fn = sprintf('#00%02d',p);
    TError{n,1} = {fn};
    
    dspl = sDataS.dspl;
    tracGT = tDataS.trac;
    brdx = tDataS.brdx;
    brdy = tDataS.brdy;
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,2} = err;

    dspl = addNoise(dspl,noise);
    trac = predictTrac(dspl,10670);
    err = errorTrac(trac,tracGT,brdx,brdy);
    TError{n,4} = err;   
    
    dspl = sDataL.dspl;
    tracGT = tDataL.trac;
    brdx = tDataL.brdx;
    brdy = tDataL.brdy;    
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