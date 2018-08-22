function movingavestruct(cellstruct, k, yfield, xfield, figh)
%movingavestruct(CELLSTRUCT, K, YFIELD, XFIELD, FIGH)
%calculate moving averate of YFIELD over XFIELD with K-point moving
%average. Outputs plot of smoothed YFIELD vs XFIELD to the figure handle 
%FIGH.

if nargin < 5
    figh = [];
    if nargin < 4
        xfield = 'time';
    end
end

datafields = fieldnames(cellstruct);
meanstruct = struct;
for ii = 1:length(datafields)
    meanstruct.(datafields{ii}).(yfield) = movmean(cellstruct.(datafields{ii}).(yfield),k);
    meanstruct.(datafields{ii}).(xfield) = cellstruct.(datafields{ii}).(xfield)...
        - cellstruct.(datafields{ii}).(xfield)(1);
end

plotsubfield(meanstruct,xfield,yfield,figh)
setallsubplots(figh,'axis','yscale','linear')
