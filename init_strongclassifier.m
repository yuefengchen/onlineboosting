function init_strongclassifier(patch)
    global parameter;
    % haarfeature is global variable
    % in function generaterandomfeature the generateed haar feature is
    % stored in haarfeature
    % then init the gaussian distribution
    for i = 1:parameter.numselectors
        generaterandomfeature(i, parameter.numweakclassifiers + parameter.iterationinit, parameter.patch, parameter.minarea);
    end
   % gaussiandistributioninit( [haarfeature.mean, haarfeature.sigma]);
end