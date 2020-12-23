clc;clear
TCutoff = table({'fn'},0,'VariableNames',{'File ID','cutoff'});
n = 1;
for p = 1:40
    fn = sprintf('testData/trac/MLData%04d.mat',p);
    try
        fileData = load(fn);
    catch
        continue;
    end
    brdx = fileData.brdx;
    brdy = fileData.brdy;
    trac = fileData.trac;
    fn = sprintf('testData/dspl/MLData%04d.mat',p);
    fileData = load(fn);
    dspl = fileData.dspl;
    fn = sprintf('#%04d',p);
    TCutoff{n,1} = {fn};
    TCutoff{n,2} = tracCutoff(trac,dspl,brdx,brdy,90);
    n = n+1;
end