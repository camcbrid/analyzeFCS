function fitstruct = linearfitsubfield(cellstruct, xfield, yfield, figh)
%FITSTRUCT = linearfitsubfield(CELLSTRUCT, XFIELD, YFIELD, FIGH)
%Fit scatterplots with a linear and a robust linear fit to determine
%fluorescence spillover.

if nargin < 4
    figh = 1;
end

%init
celltypes = fieldnames(cellstruct);
fitstruct = struct;

%loop through each cell type
disp(['linear fitting ',xfield,' and ',yfield,'...'])
for ii = 1:length(celltypes)
    %data
    x = cellstruct.(celltypes{ii}).(xfield);
    y = cellstruct.(celltypes{ii}).(yfield);
    %linear fit
    [fitobj,gof] = fit(x, y, 'poly1');
    [fitobjT,gofT] = fit(y, x, 'poly1');
    %output
    fitstruct.(celltypes{ii}).fitobj = fitobj;
    fitstruct.(celltypes{ii}).gof = gof;
    fitstruct.(celltypes{ii}).fitobjT = fitobjT;
    fitstruct.(celltypes{ii}).gofT = gofT;
    fitstruct.(celltypes{ii}).m = fitobj.p1;
    fitstruct.(celltypes{ii}).b = fitobj.p2;
    fitstruct.(celltypes{ii}).mT = 1/fitobjT.p1;
    fitstruct.(celltypes{ii}).bT = -fitobjT.p2./fitobjT.p1;
    cellstruct.(celltypes{ii}).([yfield,'fit']) = x*fitobj.p1 + fitobj.p2;
    cellstruct.(celltypes{ii}).([yfield,'fitT']) = x/fitobjT.p1 - fitobjT.p2/fitobjT.p2;
    %display slopes
    disp([celltypes{ii},' slope: ',num2str([fitobj.p1,1/fitobjT.p1]),...
        '; rsq: ',num2str([gof.rsquare,gofT.rsquare])])
end

%plot raw data and fits
plotsubfield(cellstruct,xfield,yfield,figh)
plotsubfield(cellstruct,xfield,[yfield,'fit'],figh,'--')
plotsubfield(cellstruct,xfield,[yfield,'fitT'],figh,'-.')
