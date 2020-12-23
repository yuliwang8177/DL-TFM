clc;clear
warning('off','all');
TError = table({'fn'},0,0,'VariableNames',{'File ID','160','160 N'});
fn = sprintf('cutoff.xlsx');
if ~exist(fn)
    TCutoff = [];
else
    TCutoff = readtable(fn);
end

S = 160;
noise = 0.00765;
n = 1;
for p = 1:32
    fn = sprintf('testData/trac/MLData%04d.mat',p);
    try
        fileData = load(fn);
    catch
        continue;
    end
    
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    tracGT = fileData.trac;
    fn = sprintf('testData/strn/MLData%04d.mat',p);
    fileData = load(fn);
    strn = fileData.strn;
    if isempty(TCutoff)
        cutoff = cutoffVal(tracGT,strn,brdx,brdy,90);
    else
        cutoff = TCutoff{TCutoff{:,1}==p,sprintf('x%d',S(i))};
    end
    
    fn = sprintf('#%04d',p);
    TError{n,1} = {fn};
    trac = predictTrac(10670,strn);
    err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
    TError{n,2} = err;
    
    strn = addNoise(strn,noise);
    trac = predictTrac(10670,strn);
    err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
    TError{n,3} = err;
    
    n = n + 1;
end