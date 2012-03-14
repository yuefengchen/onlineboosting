function classreal = classifyrealboost(selectorindex,value)
    % log ( p+ / p-) = - log(sigma+) + (x - mean+)^2 / (2 * sigma+^2) -
    %                 (- log(sigma-) + (x - mean-)^2 / (2 * sgima-^2)
    global haarfeature;
    %
    pmean = haarfeature(selectorindex).posgaussian(:, 1);
    psigma = haarfeature(selectorindex).posgaussian(:, 2);
    nmean = haarfeature(selectorindex).neggaussian(:, 1);
    nsigma = haarfeature(selectorindex).neggaussian(:, 2);
    pos = (1 ./ (sqrt(2*pi).*psigma) ) .* exp( -(value - pmean).^2 ./ (2*psigma.^2));
    neg = (1 ./ (sqrt(2*pi).*nsigma) ) .* exp( -(value - nmean).^2 ./ (2*nsigma.^2));
   % classreal = -log(psigma) + (value - pmean).^2 ./ (2*(psigma.^2)) - ...
   %             -log(nsigma) + (value - nmean).^2 ./ (2*(nsigma.^2));
   classreal = log ( (pos + 0.001) ./( neg + 0.001));
end