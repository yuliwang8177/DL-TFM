clc;clear
warning('off','all');
TCutoff = table({'fn'},0,0,0,'VariableNames',{'File ID','104','160','256'});
S = [104 160 256];
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
        trac = fileData.trac;
        fn = sprintf('testData%d/strn/MLData%04d.mat',S(i),p);
        fileData = load(fn);
        strn = fileData.strn;
        fn = sprintf('#%04d',p);
        TCutoff{n,1} = {fn};
        TCutoff{n,i+1} = cutoffVal(trac,strn,brdx,brdy,90);
    end        
    n=n+1;
end