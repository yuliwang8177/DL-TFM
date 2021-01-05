clear; close all;
warning('off','all');
TError = table({'fn'},0,'VariableNames',{'File ID','Error'});
n = 1;
for i=1:14
    try
        fn = sprintf('dspl/MLData%03d.mat',i);
        fileData = load(fn);
    catch
        continue;
    end
    dsplGT = fileData.dspl;
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    
    fn = sprintf('#%03d',i);
    TError{n,1} = {fn};
    
    trac = predictTrac(dsplGT,10670);
    
    dspl = calcDspl(trac,10670,brdx,brdy,10);
    TError{n,2} = errorDspl(dspl,dsplGT,brdx,brdy,10);
    n = n+1;
end
disp('normalized error')
disp(mean(TError{:,2:end}))