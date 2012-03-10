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
parameter.numweakclassifiers = parameter.numselectors * 20;
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


for  i = 1:50
    
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches,:),  -1, 1.0);
   
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
    %confidencemap = detectionbymatlab(sumimagedata, patches); 
    confidencemap = detection(sumimagedata, patches); 
    imshow(confidencemap);
    
    
    g = fspecial('gaussian', [3 ,3]);
    confidencemap = imfilter(confidencemap, g);
    
    % get the max patches
    [maxx, yind] = max(confidencemap, [], 1);
    [maxv, xind] = max(maxx);
    parameter.patch = [xind yind(xind) parameter.patch(3), parameter.patch(4)];
    imshow(I);
    rectangle('Position',parameter.patch, 'edgecolor', 'g');
    text( xind + parameter.patch(3)/2, yind(xind)+ parameter.patch(4)/2, ...
        num2str(max(max(confidencemap)), '%6f'));
    objectlocation = [objectlocation;parameter.patch];
    confidence = [confidence ; max(max(confidencemap))];
    
    
    % generate patches
    patches = generatepatches(parameter.patch, parameter.searchfactor, parameter.overlap);
    numofpatches = size(patches, 1);
    
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 3,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 2,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches - 1,:), -1, 1.0);
    update(sumimagedata, parameter.patch, 1, 1.0);
    update(sumimagedata, patches(numofpatches,:),     -1, 1.0);
    
   
    pause(0.00040);
end
onlboost_tiger1_gt = objectlocation;
onlboost_tiger1_confidence = confidence;
save onlboost_tiger1_gt.mat onlboost_tiger1_gt;
save onlboost_tiger_confidence.mat onlboost_tiger1_confidence;
