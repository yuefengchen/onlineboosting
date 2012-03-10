function error = calerror(objectionlocation, goundtrouth, color)
global parameter;
load faceocc_gt;
e = 1;
error = zeros(parameter.imgend, 1);
for imgno = parameter.imgstart:parameter.imgend
    if mod(e, 5) == 1
        error(e) = sqrt(  ...
            (objectionlocation(e, 1) - faceocc_gt(e,1))^2 + ...
            (objectionlocation(e, 2) - faceocc_gt(e,2))^2 );
    end
    e = e + 1;
end
x = 1:5:parameter.imgend;
plot(x, error(x), color);