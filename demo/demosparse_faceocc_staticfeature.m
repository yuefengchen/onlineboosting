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
load faceocc_gt.mat;
load haarmat.mat;

parameter.numselectors = 20;
parameter.overlap = 0.99;
parameter.searchfactor = 2;
parameter.minfactor = 0.001;
parameter.patch = faceocc_gt(1,:);
parameter.iterationinit = 0;
parameter.numweakclassifiers = parameter.numselectors * 10;
parameter.minarea = 9;
parameter.imagewidth = 352;
parameter.imageheight = 288;
parameter.imdirformat = './/data//faceocc//imgs//img%05d.png';
parameter.imgstart = 0;
parameter.imgend = 885;
objectlocation = parameter.patch;
%parameter.initializeiterations = 50;
% generate haar feature randomly and initilize the gaussian distribution 

I = imread(num2str(parameter.imgstart, parameter.imdirformat));
imshow(I);
sumimagedata = interimagebymatlab(I);
% initilize the posgaussian and neggaussian
for i = 1:parameter.numselectors
    generaterandomfeaturebymat(i,200, haarmat(1+200*(i-1):200*i,:));
end
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
selector_perframe = selectors;

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
    %confidencemap = detectionbymatlab(sumimagedata, patches); 
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
    
    selector_perframe = [ selector_perframe ,selectors];
    %pause;
end
onspboost_faceocc_gt = objectlocation;
onspboost_faceocc_confidence = confidence;
save onspboost_faceocc_gt.mat onspboost_faceocc_gt;
save onspboost_faceocc_confidence.mat onspboost_faceocc_confidence;
