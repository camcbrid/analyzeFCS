function outstruct = gatesinglets(cellstruct,xprop,yprop,xv,yv,ploton)
%outstruct = gatesinglets(cellstruct,xprop,yprop,xv,yv)
%Eliminate cells that are not in the polygon defined by the points (XV, YV)
%for the properties XPROP vs YPROP in the data contained in CELLSTRUCT. If
%no (XV, YV) input, then gate attempts to select singlet cellse.

%defaults
if nargin < 6
    ploton = true;
    if nargin < 4
        z = 1e5*[0.0435, 0.0694;
            0.0539, 0.0419;
            6.6287, 2.1694;
            3.0661, 5.2837;
            0.0435, 0.0694];
        xv = z(:,1);
        yv = z(:,2);
        if nargin < 3
            yprop = 'fsch';
            if nargin < 2
                xprop = 'fsca';
            end
        end
    end
end

%init
outstruct = cellstruct;
celltypes = fieldnames(cellstruct);

for jj = 1:length(celltypes)
    %find indicies of cells to keep
    
    xq = cellstruct.(celltypes{jj}).(xprop);
    yq = cellstruct.(celltypes{jj}).(yprop);
    inds = inpolygon(xq,yq,xv,yv);
    
    %loop through all propnames, eliminating all data from cells to throw out
    propnames = fieldnames(cellstruct.(celltypes{jj}));
    for ii = 1:length(propnames)
        outstruct.(celltypes{jj}).(propnames{ii}) = ...
            cellstruct.(celltypes{jj}).(propnames{ii})(inds);
        polygonstruct.(celltypes{jj}).xv = xv;
        polygonstruct.(celltypes{jj}).yv = yv;
    end
end

%plot gated cells
if ploton
    plotsubfield(cellstruct,xprop,yprop,[],'log')
    plotsubfield(outstruct,xprop,yprop,gcf,'log')
    plotsubfield(polygonstruct,'xv','yv',gcf,'log','k--')
end