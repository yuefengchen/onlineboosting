function   generaterandomfeaturebymat(selectorindex, featurenum, haardata)
    % haarfeature block_width, block_height, x0, y0, colsinblock, rowsinblock,
    % blockweight, mean, sigma
    global haarfeature;
    index = 1;
    haarfeature(selectorindex).area = [];
    haarfeature(selectorindex).type = [];
    haarfeature(selectorindex).location = [];
    haarfeature(selectorindex).weight = [];
    haarfeature(selectorindex).index = [];   
    haarfeature(selectorindex).posgaussian = [];
    haarfeature(selectorindex).neggaussian = [];
    
    for i = 1:featurenum
        x0 = haardata(i, 1);
        y0 = haardata(i, 2);
        colsinblock = haardata(i, 3);
        rowsinblock = haardata(i, 4);
        prob = haardata(i,5);
            if prob <= 0.2
                %   1
                %  -1
                area = 2;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 1;
                location = [x0,  y0,               colsinblock, rowsinblock; 
                            x0,  y0 + rowsinblock, colsinblock, rowsinblock];
                weight =  [1 -1]'./(location(:,3).* location(:,4));
                haarfeature(selectorindex).area = [haarfeature(selectorindex).area; area];
                haarfeature(selectorindex).type = [haarfeature(selectorindex).type ; type];
                haarfeature(selectorindex).location = [haarfeature(selectorindex).location ; location];
                haarfeature(selectorindex).weight = [haarfeature(selectorindex).weight; weight];
                haarfeature(selectorindex).index = [haarfeature(selectorindex).index; index];
                haarfeature(selectorindex).posgaussian = [haarfeature(selectorindex).posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).neggaussian = [haarfeature(selectorindex).neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                index = index +  area;
                
             %   return ;

            elseif prob <= 0.4
            
                area = 2;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type =2;
                location = [x0,                y0,  colsinblock, rowsinblock; 
                            x0 + colsinblock,  y0 , colsinblock, rowsinblock];
                weight = [1, -1]' ./(location(:,3).* location(:,4));
                haarfeature(selectorindex).area = [haarfeature(selectorindex).area; area];
                haarfeature(selectorindex).posgaussian = [haarfeature(selectorindex).posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).neggaussian = [haarfeature(selectorindex).neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).type = [haarfeature(selectorindex).type ; type];
                haarfeature(selectorindex).location = [haarfeature(selectorindex).location ; location];
                haarfeature(selectorindex).weight = [haarfeature(selectorindex).weight; weight];
                haarfeature(selectorindex).index = [haarfeature(selectorindex).index; index];
                index = index +  area;
          

            elseif prob <= 0.6
               
                area = 3;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 3;
                location = [ x0,  y0,                 colsinblock,  rowsinblock; 
                             x0,  y0 + rowsinblock,   colsinblock,  2*rowsinblock;
                             x0,  y0 + 3*rowsinblock, colsinblock,  rowsinblock];
                weight = [1 -2, 1]' ./(location(:,3).* location(:,4));
                haarfeature(selectorindex).area = [haarfeature(selectorindex).area; area];
                haarfeature(selectorindex).posgaussian = [haarfeature(selectorindex).posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).neggaussian = [haarfeature(selectorindex).neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).type = [haarfeature(selectorindex).type ; type];
                haarfeature(selectorindex).location = [haarfeature(selectorindex).location ; location];
                haarfeature(selectorindex).weight = [haarfeature(selectorindex).weight; weight];
                haarfeature(selectorindex).index = [haarfeature(selectorindex).index; index];
                index = index +  area;

            elseif prob <= 0.8
               
                area = 3;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 4;
                location = [ x0,                 y0,  colsinblock,   rowsinblock; 
                             x0 + colsinblock,   y0,  2*colsinblock, rowsinblock;
                             x0 + 3*colsinblock, y0,  colsinblock,   rowsinblock];
                weight = [1,  -2,  1]' ./(location(:,3).* location(:,4));
                haarfeature(selectorindex).area = [haarfeature(selectorindex).area ; area];
                haarfeature(selectorindex).posgaussian = [haarfeature(selectorindex).posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).neggaussian = [haarfeature(selectorindex).neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).type = [haarfeature(selectorindex).type ; type];
                haarfeature(selectorindex).location = [haarfeature(selectorindex).location ; location];
                haarfeature(selectorindex).weight = [haarfeature(selectorindex).weight; weight];
                haarfeature(selectorindex).index = [haarfeature(selectorindex).index; index];
                index = index +  area;
  
            else
                area = 4;
                mean = 0;
                sigma = sqrt(256 * 256 * area / 12);
                type = 5;
                location = [ x0,                 y0,               colsinblock, rowsinblock; 
                             x0 + colsinblock,   y0,               colsinblock, rowsinblock;
                             x0,                 y0 + rowsinblock, colsinblock, rowsinblock;
                             x0 + colsinblock,   y0 + rowsinblock, colsinblock, rowsinblock];
                weight = [1,  -1, -1,  1]' ./(location(:,3).* location(:,4));
                haarfeature(selectorindex).area = [haarfeature(selectorindex).area ; area];
                haarfeature(selectorindex).posgaussian = [haarfeature(selectorindex).posgaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).neggaussian = [haarfeature(selectorindex).neggaussian; [mean, sigma, 1000, 0.01, 1000, 0.01]];
                haarfeature(selectorindex).type = [haarfeature(selectorindex).type ; type];
                haarfeature(selectorindex).location = [haarfeature(selectorindex).location ; location];
                haarfeature(selectorindex).weight = [haarfeature(selectorindex).weight; weight];
                haarfeature(selectorindex).index = [haarfeature(selectorindex).index; index];
                index = index +  area;
            end
    end
    % used to calculate the accmulated correct and wrong samples
    haarfeature(selectorindex).correct = ones(featurenum, 1);
    haarfeature(selectorindex).wrong = ones(featurenum, 1);
end