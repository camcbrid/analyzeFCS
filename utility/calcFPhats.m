function hatstruct = calcFPhats(cellstruct)
%hatstruct = calcFPhats(cellstruct)
%Find ratios of all fluorescence measurements alone vs together. Cellstruct
%must have the fields: G, R, Y, GR, GY, and RY. Each substruct must then
%have the subfields: fl1h (GFP), fl2h (RFP), fl3h (YFP), and fl4h (RFP). It
%is assumed that all fluorescence fields have been compensated.

cellstruct = combinesubstructs(cellstruct);

%init
hatstruct = struct;

%calculate
[GhatR,GhatRstd] = meandivide(cellstruct.GR.fl1h(:),cellstruct.G.fl1h(:));
[RhatG,RhatGstd] = meandivide(cellstruct.GR.fl4h(:),cellstruct.R.fl4h(:));
[RhatG2,RhatG2std] = meandivide(cellstruct.GR.fl2h(:),cellstruct.R.fl2h(:));

[GhatY,GhatYstd] = meandivide(cellstruct.GY.fl1h(:),cellstruct.G.fl1h(:));
[YhatG,YhatGstd] = meandivide(cellstruct.GY.fl3h(:),cellstruct.Y.fl3h(:));
[RhatY,RhatYstd] = meandivide(cellstruct.RY.fl4h(:),cellstruct.R.fl4h(:));
[RhatY2,RhatY2std] = meandivide(cellstruct.RY.fl2h(:),cellstruct.R.fl2h(:));
[YhatR,YhatRstd] = meandivide(cellstruct.RY.fl3h(:),cellstruct.Y.fl3h(:));

%output
hatstruct.GhatR = GhatR;
hatstruct.RhatG = RhatG;
hatstruct.RhatG2 = RhatG2;
hatstruct.GhatY = GhatY;
hatstruct.YhatG = YhatG;
hatstruct.RhatY = RhatY;
hatstruct.RhatY2 = RhatY2;
hatstruct.YhatR = YhatR;
%errors
hatstruct.GhatRstd = GhatRstd;
hatstruct.RhatGstd = RhatGstd;
hatstruct.RhatG2std = RhatG2std;
hatstruct.GhatYstd = GhatYstd;
hatstruct.YhatGstd = YhatGstd;
hatstruct.RhatYstd = RhatYstd;
hatstruct.RhatY2std = RhatY2std;
hatstruct.YhatRstd = YhatRstd;

hatstruct = orderfields(hatstruct);


function [z,zstd] = meandivide(x,y,funh)
%options for funh are 'mean', 'median', or 'geomean'
if nargin < 3
    funh = 'geomean';
end

%divide mean of x by mean of y and calculate standard error.
if strcmp(funh,'mean')
    %calculate outputs for mean
    z = mean(x,'omitnan')./mean(y,'omitnan');
    zstd = abs(z).*sqrt((std(x,'omitnan')./funh(x,'omitnan')).^2 + ...
        (std(y,'omitnan')./funh(y,'omitnan')).^2);
elseif strcmp(funh,'median')
    %calculate outputs for median
    z = median(x,'omitnan')./median(y,'omitnan');
    zstd = abs(z).*sqrt((std(x,'omitnan')./median(x,'omitnan')).^2 + ...
        (std(y,'omitnan')./median(y,'omitnan')).^2);
elseif strcmp(funh,'geomean')
    %condition first
    x = x(~isnan(x) & (x>0));
    y = y(~isnan(y) & (y>0));
    nx = length(x);
    ny = length(y);
    deltax = geostd(x,1)*geomean(x)/sqrt(nx);
    deltay = geostd(y,1)*geomean(y)/sqrt(ny);
    %calculate outputs
    z = geomean(x)./geomean(y);
    zstd = abs(z).*sqrt((deltax./geomean(x)).^2 + (deltay./geomean(y)).^2);
end
