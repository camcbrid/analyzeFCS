function J0struct = findJ02(hatstruct)
%J0STRUCT = findJ02(HATSTRUCT)
%Use data to calculate values of J0 for all pairs of fluorescent proteins:
%Green, Red, Yellow. HATSTRUCT must have fields named *hat* and *hat*std 
%for all pairs of combinations of G, R, and Y.

%unpack data
GhatR = hatstruct.GhatR;        GhatRstd = hatstruct.GhatRstd;
RhatG = hatstruct.RhatG;        RhatGstd = hatstruct.RhatGstd;
GhatY = hatstruct.GhatY;        GhatYstd = hatstruct.GhatYstd;
YhatG = hatstruct.YhatG;        YhatGstd = hatstruct.YhatGstd;
RhatY = hatstruct.RhatY;        RhatYstd = hatstruct.RhatYstd;
YhatR = hatstruct.YhatR;        YhatRstd = hatstruct.YhatRstd;

%calculate J0 for each pair of constitutive genes
[JGR, JGRstd] = calcJ0(GhatR, RhatG, GhatRstd, RhatGstd);
[JGY, JGYstd] = calcJ0(GhatY, YhatG, GhatYstd, YhatGstd);
[JRG, JRGstd] = calcJ0(RhatG, GhatR, RhatGstd, GhatRstd);
[JRY, JRYstd] = calcJ0(RhatY, YhatR, RhatYstd, YhatRstd);
[JYG, JYGstd] = calcJ0(YhatG, GhatY, YhatGstd, GhatYstd);
[JYR, JYRstd] = calcJ0(YhatR, RhatY, YhatRstd, RhatYstd);

%output struct for J calculation and the errors/standard deviations
J0struct = struct('JGR',JGR,'JGY',JGY,'JRG',JRG,'JRY',JRY,'JYG',JYG,'JYR',JYR,...
    'JGRstd',JGRstd,'JGYstd',JGYstd,'JRGstd',JRGstd,'JRYstd',JRYstd,...
    'JYGstd',JYGstd,'JYRstd',JYRstd);


function [J0, J0std] = calcJ0(xhat1, xhat2, xhat1std, xhat2std)
%calculates J0 (resources used by the perturbation) assuming xhat2 is the
%perturbation and xhat1 is the basal protein. Also calculates the standard
%deviation of J0 if standard deviations of xhat1 and xhat2 are provided

if nargin < 4
    xhat2std = 0;
    if nargin < 3
        xhat1std = 0;
    end
end

%calculate J0 for a pair of constitutive genes
J0 = (1 - xhat2)./(xhat2 + xhat1 - 1);
%estimate error (1 standard deviation) in J's
J0std = sqrt(((1-xhat2).*xhat1std).^2 + (xhat1.*xhat2std).^2)./((xhat2 + xhat1 - 1).^2);

