%clc;clear
warning('off','all');
TError = table({'fn'},0,0,0,0,0,0,'VariableNames',{'File ID','104','160','256','104 N','160 N','256 N'});
fn = sprintf('cutoff.xlsx');
if ~exist(fn)
    TCutoff = [];
else
    TCutoff = readtable(fn);
end
S = [104 160 256];
noise = 0.00765;
n = 1;
for p = 1:55
    fn = sprintf('testData104/trac/MLData%04d.mat',p);
    try
        fileData = load(fn);
    catch
        continue;
    end
    for i=1:3
        fn = sprintf('testData%d/trac/MLData%04d.mat',S(i),p);
        fileData = load(fn);
        brdx = fileData.brdx;
        brdy = fileData.brdy;
        tracGT = fileData.trac;
        fn = sprintf('testData%d/dspl/MLData%04d.mat',S(i),p);
        fileData = load(fn);
        dspl = fileData.dspl;
        if isempty(TCutoff)
            cutoff = cutoffVal(tracGT,dspl,brdx,brdy,90);
        else
            cutoff = TCutoff{TCutoff{:,1}==p,sprintf('x%d',S(i))};
        end    
    
        fn = sprintf('#%04d',p);
        TError{n,1} = {fn};
        
        trac = predictTrac(dspl,10670);
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+1} = err;        
        
        dspl = addNoise(dspl,noise);
        trac = predictTrac(dspl,10670);
        err = errorTrac(trac,tracGT,brdx,brdy,cutoff);
        TError{n,i+4} = err;        
    end
    n = n + 1;    
end
disp('normalized error')
disp(mean(TError{:,2:end}))