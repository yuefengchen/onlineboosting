% program is programming by chenyuefeng on 2012-03-06
% demo main function
clear;
clear global haarfeature;
clear global parameter;
clear global selectors;
clear global alpha;
global haarfeature;
global parameter;
global selectors;
global alpha;
load tiger1_gt.mat;
parameter.numselectors = 50;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = tiger1_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 320;
parameter.imageheight = 240;
parameter.imdirformat = './/tiger1//imgs//img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 353;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = interimagebymatlab(I);
% initilize the posgaussian and neggaussian
init_strongclassifier(parameter.patch);
% generate the patches in the search region
patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
% first initilize the weakclassifiers
selectors = zeros(parameter.numselectors, 1);
alpha = zeros(parameter.numselectors, 1);
numofpatches = size(patches, 1);

patchesforupdate = zeros(8, 4);
labelforupdate = zeros(8, 1);
for  i = 1:50
    
    importance = ones(8,1);
    
    patchesforupdate(1,:) = parameter.patch;
    labelforupdate(1) = 1;
    
    patchesforupdate(2,:) = patches(numofpatches - 3,:);
    labelforupdate(2) = -1;
    
    patchesforupdate(3,:) = parameter.patch;
    labelforupdate(3) = 1;
    
    patchesforupdate(4,:) = patches(numofpatches - 2,:);
    labelforupdate(4) = -1;
    
    patchesforupdate(5,:) = parameter.patch;
    labelforupdate(5) = 1;
    
    patchesforupdate(6,:) = patches(numofpatches - 1,:);
    labelforupdate(6) = -1;
    
    patchesforupdate(7,:) = parameter.patch;
    labelforupdate(7) = 1;
    
    patchesforupdate(8,:) = patches(numofpatches ,:);
    labelforupdate(8) = -1;
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
   
    
   
end
flag = 1;
confidence = [];
for imgno = parameter.imgstart+1:parameter.imgend
    if mod(imgno , 10) == 0 
        imgno
        if flag
            tic
        else
            toc
        end
        flag = ~flag;
    end
   
    I = imread(num2str(imgno, parameter.imdirformat));
    subplot(1, 2, 1);
    imshow(I);
    sumimagedata = intimage(I);
    subplot(1, 2, 2);

    confidencemap = detection(sumimagedata, patches); 
    imshow(confidencemap);
    
    
    g = fspecial('gaussian', [3 ,3]);
    confidencemap = imfilter(confidencemap, g);
    
    % get the max patches
    [maxx, yind] = max(confidencemap, [], 1);
    [maxv, xind] = max(maxx);
    parameter.patch = [xind yind(xind) parameter.patch(3) parameter.patch(4)];
    imshow(I);
    rectangle('Position',parameter.patch, 'edgecolor', 'g');
    text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, num2str(max(max(confidencemap)), '%6f'));
    objectlocation = [objectlocation;parameter.patch];
    confidence = [confidence ; max(max(confidencemap))];
    
    
    % generate patches
    patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
    numofpatches = size(patches, 1);
    
    importance = ones(8,1);
    
    patchesforupdate(1,:) = parameter.patch;
    labelforupdate(1) = 1;
    
    patchesforupdate(2,:) = patches(numofpatches - 3,:);
    labelforupdate(2) = -1;
    
    patchesforupdate(3,:) = parameter.patch;
    labelforupdate(3) = 1;
    
    patchesforupdate(4,:) = patches(numofpatches - 2,:);
    labelforupdate(4) = -1;
    
    patchesforupdate(5,:) = parameter.patch;
    labelforupdate(5) = 1;
    
    patchesforupdate(6,:) = patches(numofpatches - 1,:);
    labelforupdate(6) = -1;
    
    patchesforupdate(7,:) = parameter.patch;
    labelforupdate(7) = 1;
    
    patchesforupdate(8,:) = patches(numofpatches ,:);
    labelforupdate(8) = -1;
    updatesparse(sumimagedata, patchesforupdate, labelforupdate, importance);
    
    %pause;
end
onspboost_tiger1_gt = objectlocation;
onspboost_tiger1_confidence = confidence;
save onspboost_tiger_gt.mat onspboost_tiger1_gt;
save onspboost_tiger_confidence.mat onspboost_tiger1_confidence;
