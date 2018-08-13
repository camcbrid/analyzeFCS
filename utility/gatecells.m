function outstruct = gatecells(cellstruct,cellname,propname,thresh)
%outstruct = gatecells(cellstruct,cellname,propname,thresh)
%Eliminate cells that are not in the window of min(THRESH) to max(THRESH)
%for the desired property PROPNAME only in the cell type CELLNAME. CELLNAME
%may be a cell arry with multiple 

%init
outstruct = cellstruct;

if iscell(cellname)
    for jj = 1:length(cellname)
        %find indicies of cells to keep
        inds = cellstruct.(cellname{jj}).(propname) > min(thresh) & ...
            cellstruct.(cellname{jj}).(propname) < max(thresh);
        
        %loop through all propnames, eliminating all data from cells to throw out
        propnames = fieldnames(cellstruct.(cellname{jj}));
        for ii = 1:length(propnames)
            outstruct.(cellname{jj}).(propnames{ii}) = ...
                cellstruct.(cellname{jj}).(propnames{ii})(inds);
        end
    end
else
    %find indicies of cells to keep
    inds = cellstruct.(cellname).(propname) > min(thresh) & ...
        cellstruct.(cellname).(propname) < max(thresh);
    
    %loop through all propnames, eliminating all data from cells to throw out
    propnames = fieldnames(cellstruct.(cellname));
    for ii = 1:length(propnames)
        outstruct.(cellname).(propnames{ii}) = ...
            cellstruct.(cellname).(propnames{ii})(inds);
    end
end
