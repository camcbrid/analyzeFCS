function movingavestruct(cellstruct,k,yfield,xfield,figh)


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
    meanstruct.(datafields{ii}).(xfield) = cellstruct.(datafields{ii}).(xfield);
end

plotsubfield(meanstruct,xfield,yfield,figh)
applytoallsubplots(figh,'axis','yscale','linear')
