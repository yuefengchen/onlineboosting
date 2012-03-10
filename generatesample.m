function [patches, label] = generatesample( patch, pmindis, maxpossamplenum,  nmindis, nmaxdis , maxnegsamplenum)
    global parameter;
    objx = parameter.patch(1);
    objy = parameter.patch(2);
    distance = sqrt( (patch(:,1) - objx).^2 + (patch(:,2) - objy).^2);
    
    patches = [];
    label = [];
    % generate positive samples
    posindex = find(distance < pmindis);
    if length(posindex) > maxpossamplenum
        rndposindex = posindex(randperm(length(posindex)));
        patches = [patches ; patch(rndposindex(1:maxpossamplenum), :)];
        label = [label; ones(maxpossamplenum, 1)];
    else
        patches = [patches ;patch(posindex, :)];
        label = [label; ones(length(posindex), 1)];
    end
    
    % generate negative  samples
    negindex = find(distance > nmindis & distance < nmaxdis);
    if  length(negindex) > maxnegsamplenum
        rndnegindex = negindex( randperm( length( negindex )) );
        patches = [patches ; patch(rndnegindex(1:maxnegsamplenum), :)];
        label = [label; -1 * ones(maxnegsamplenum, 1)];
    else
        patches = [patches; patches(negindex, :)];
        label = [label; -1 * ones(length(negindex), 1)];
    end
    
end