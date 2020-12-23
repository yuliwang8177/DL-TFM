function createTracnet(S)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createTracnet(S)
%
% Description: create a U-Net neural network architecture for deep learning 
% traction force microscopy
%
% Input: 
%   S: size of the neural network; must be multiples of 8 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clc;clear;
inputSize = [S S 2]; %for SxS [x y] vector maps
inputLayer = image3dInputLayer(inputSize,'Normalization','none','Name','input');

numFiltersEncoder = [
    32 64; 
    64 128; 
    128 256];

layers = [inputLayer];
for module = 1:3 %create encoding layers
    layer_name = num2str(module);
    encoderModule = [
        convolution3dLayer([3 3 2],numFiltersEncoder(module,1), ...
            'Padding','same','WeightsInitializer','narrow-normal', ...
            'BiasInitializer', 'zeros', ...
            'Name',['en',layer_name,'_conv1']);
        batchNormalizationLayer('Name',['en',layer_name,'_bn']);
        reluLayer('Name',['en',layer_name,'_relu1']);
        convolution3dLayer([3 3 2],numFiltersEncoder(module,2), ...
            'Padding','same','WeightsInitializer','narrow-normal', ...
            'BiasInitializer', 'zeros', ...
            'Name',['en',layer_name,'_conv2']);
        reluLayer('Name',['en',layer_name,'_relu2']);
        maxPooling3dLayer([2,2,1],'Stride',[2,2,1],'Padding','same', ...
            'Name',['en',layer_name,'_maxpool']);
    ];
    layers = [layers; encoderModule];
end

numFiltersDecoder = [
    128 256; 
    64 128; 
    32 64;
    1 32];

for module = 1:4 %create decoding layers
    layer_name = num2str(-module+5); %numbered 4 to 1
    decodeModule = [
        convolution3dLayer([3 3 2],numFiltersDecoder(module,1), ...
            'Padding','same','WeightsInitializer','narrow-normal', ...
            'BiasInitializer', 'zeros', ...
            'Name',['de',layer_name,'_conv1']);
        batchNormalizationLayer('Name',['de',layer_name,'_bn1']);
        reluLayer('Name',['de',layer_name,'_relu1']);
        convolution3dLayer([3 3 2],numFiltersDecoder(module,2), ...
            'Padding','same','WeightsInitializer','narrow-normal', ...
            'BiasInitializer', 'zeros', ...
            'Name',['de',layer_name,'_conv2']);
        batchNormalizationLayer('Name',['de',layer_name,'_bn2']);        
        reluLayer('Name',['de',layer_name,'_relu2']);
        transposedConv3dLayer([3,3,1],numFiltersDecoder(module,2),'Stride',[2,2,1],'Cropping','same', ...
            'WeightsInitializer','narrow-normal','BiasInitializer', 'zeros', ...
            'Name',['de',layer_name,'_transconv']);
    ];
    layers = [layers; decodeModule];
end

%create output layers
lgraph = layerGraph(layers);
lgraph = removeLayers(lgraph, 'de1_transconv');
layer =  convolution3dLayer([3 3 2], 1, ...
            'Padding','same','WeightsInitializer','narrow-normal', ...
            'BiasInitializer', 'zeros', ...
            'Name',['de1_conv3']);
lgraph = addLayers(lgraph,layer);
lgraph = connectLayers(lgraph,'de1_relu2','de1_conv3');
layer = regressionLayer('name','output');
lgraph = addLayers(lgraph,layer);
lgraph = connectLayers(lgraph, 'de1_conv3','output');

%create bubble structures
lgraph = disconnectLayers(lgraph,'de2_transconv','de1_conv1');
concat1 = concatenationLayer(4,2,'Name','concat1');
lgraph = addLayers(lgraph,concat1);
lgraph = connectLayers(lgraph,'en1_relu2','concat1/in1');
lgraph = connectLayers(lgraph,'de2_transconv','concat1/in2');
lgraph = connectLayers(lgraph,'concat1/out','de1_conv1');

lgraph = disconnectLayers(lgraph,'de3_transconv','de2_conv1');
concat2 = concatenationLayer(4,2,'Name','concat2');
lgraph = addLayers(lgraph,concat2);
lgraph = connectLayers(lgraph,'en2_relu2','concat2/in1');
lgraph = connectLayers(lgraph,'de3_transconv','concat2/in2');
lgraph = connectLayers(lgraph,'concat2/out','de2_conv1');

lgraph = disconnectLayers(lgraph,'de4_transconv','de3_conv1');
concat3 = concatenationLayer(4,2,'Name','concat3');
lgraph = addLayers(lgraph,concat3);
lgraph = connectLayers(lgraph,'en3_relu2','concat3/in1');
lgraph = connectLayers(lgraph,'de4_transconv','concat3/in2');
lgraph = connectLayers(lgraph,'concat3/out','de3_conv1'); 

analyzeNetwork(lgraph);
fn = sprintf('tracnetGraph%d.mat',S);
save(fn,'lgraph');
end
