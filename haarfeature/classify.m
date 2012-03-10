function classid = classify(selectorindex,value)
    global haarfeature;
    mean = (haarfeature(selectorindex).posgaussian(:, 1) + haarfeature(selectorindex).neggaussian(:, 1))/2;
    logicalval = ~xor (value < mean , haarfeature(selectorindex).posgaussian(:,1) < haarfeature(selectorindex).neggaussian(:,1));
    classid = ones(length(value), 1);
    classid(find(logicalval == 0)) = -1;
end