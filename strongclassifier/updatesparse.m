function  updatesparse( sumimagedata, patch, label, importance)
    global parameter;
    global haarfeature;
    global selectors;
    global alpha;
    numofpatches = size(patch, 1);
    numofweakclassifier = parameter.numweakclassifiers;
    weight = zeros(numofweakclassifier, numofpatches, parameter.numselectors);
    for i = 1:parameter.numselectors
        % for each weakclassifiers update 
        % possion sampling
        % calculate the haarfeature value for each weakclassifier
        for j = 1: numofpatches
            haarfeatureeval(i, sumimagedata, patch(j,:));
            weight(:, j,i) = haarfeature(i).weightvalue;
            if label(j) == 1
                % pos update
                posgaussiandistributionupdate(i, weight(:, j, i), parameter.minfactor);
            else
                % neg update
                neggaussiandistributionupdate(i, weight(:, j, i), parameter.minfactor);
            end
        end
        
        
        A = zeros(numofpatches, numofweakclassifier + 2 * numofpatches);
        W = zeros(numofpatches, numofpatches);
        for j = 1: numofpatches
            W(j,j) = importance(j);
            %haarfeatureeval(i, sumimagedata, patch(j,:));
            classid = classify(i, weight(:, j, i));
            indwrong = find(classid ~=  label(j));
            indcorrect = find(classid ==  label(j));
        
            haarfeature(i).wrong(indwrong) =  haarfeature(i).wrong(indwrong) + importance(j);
            haarfeature(i).correct(indcorrect) =  haarfeature(i).correct(indcorrect) + importance(j);
            
            A(j, 1:numofweakclassifier) = classid';
        end
        A(:,numofweakclassifier + 1: numofweakclassifier + numofpatches) = eye(numofpatches);
        A(:,numofweakclassifier + numofpatches + 1: numofweakclassifier + 2 * numofpatches) = - eye(numofpatches);
        
        param.lambda = 0.01;
        param.lambda2 = 0;
        param.mode = 2;
        param.pos = true;
        param.L = length(label);
       
        c = mexLasso(label, A, param);
        %c = mexLasso(W*label, W*A, param);
        c = full(c);
        [maxvalue, selectclassifierindex] = max(c(1:numofweakclassifier));
        selectors(i) = (selectclassifierindex);
        minerror = haarfeature(i).wrong(selectclassifierindex) / (haarfeature(i).wrong(selectclassifierindex) +  haarfeature(i).correct(selectclassifierindex));
        if minerror >= 0.5
            alpha(i) = 0;
        else
            alpha(i) = log((1 - minerror)/minerror);
        end
        indcorrect = find(A(:,selectclassifierindex) == label);
        indwrong = find(A(:,selectclassifierindex) ~= label);
       % importance(indcorrect) = importance(indcorrect) * sqrt(minerror/(1 - minerror));
       % importance(indwrong) = importance( indwrong) * sqrt((1 - minerror)/minerror);
       
    end
end