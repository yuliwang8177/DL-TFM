cellN = 14;
fn = sprintf('dspl/MLData%03d.mat',cellN);
fileData = load(fn);
dspl = fileData.dspl;
brdx = fileData.brdx;
brdy = fileData.brdy;

trac = predictTrac(dspl,10670);
tracFilt = filtTrac(trac,trac,brdx,brdy,95);

plotTrac(tracFilt);
dsplPred = calcDspl(tracFilt,10670,brdx,brdy);
plotError(dspl,dsplPred,brdx,brdy,95);

