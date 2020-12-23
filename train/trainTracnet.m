%trainTracnet
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trainTracnet(S)
%
% Description: train a tracnet network from scratch
%
% Parameters: 
%   S: size of the neural network; must be multiples of 8 
%   outNetFn: file for storing the trained network
%   ep: maximal number of epoches
%   lr: initial learning rate
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;clc;
S = 104;
outNetFn = sprintf('tracnet%d-02.mat',S);
ep = 50; % max epoch
lr = 6e-4; % initial learning rate
mag = S/104;

fn1 = sprintf('trainData%d/dspl',S);
fn2 = sprintf('trainData%d/dsplRadial',S);
dsplTrainds = imageDatastore({fn1,fn2},'FileExtensions','.mat','ReadFcn',@load);
fn1 = sprintf('trainData%d/trac',S);
fn2 = sprintf('trainData%d/tracRadial',S);
tracTrainds = imageDatastore({fn1,fn2},'FileExtensions','.mat','ReadFcn',@load);

dspl_array=zeros(S,S,2,1);
for i = 1:numel(dsplTrainds.Files)
    dsplData=load(dsplTrainds.Files{i});
    dspl_array(:,:,:,i)=dsplData.dspl;
end
trac_array=zeros(S,S,2,1);
for i = 1:numel(tracTrainds.Files)
    tracData=load(tracTrainds.Files{i});
    trac_array(:,:,:,i)=tracData.trac;
end
augimdsTrain = augmentedImageDatastore([S S 2],dspl_array,trac_array);

fn1 = sprintf('tracnetGraph%d.mat',S);
lgraph = load(fn1);
lgraph = lgraph.lgraph;

options = trainingOptions('sgdm', ...
    'InitialLearnRate',lr, ...
    'LearnRateSchedule', 'piecewise', ...    
    'LearnRateDropPeriod', 10, ...
    'LearnRateDropFactor', 0.7943, ...
    'L2Regularization',0.0005, ...
    'MaxEpochs',ep, ...  
    'MiniBatchSize',ceil(30/mag), ...
    'GradientThreshold',1, ...
    'CheckpointPath', tempdir, ...          
    'VerboseFrequency',2, ...
    'shuffle','every-epoch', ...
    'Plots','training-progress');
             
[net, info] = trainNetwork(augimdsTrain,lgraph,options);
save(outNetFn,'net');

