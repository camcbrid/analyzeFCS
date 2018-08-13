function cellstruct = bulkdata2cells(datastruct, indstruct, datafields)
%convert raw data in a struct to sorted by individual cells in a struct

if nargin < 3
    datafields = {'OD','GFP','RFP','YFP','time'};
    if nargin < 2
        indstruct = struct;
        indstruct.R = 1:3;
        indstruct.YG = 4:6;
        indstruct.G = 11:13;
        indstruct.GR = 14:16;
        indstruct.Y = 21:23;
        indstruct.YR = 24:26;
        indstruct.M9 = [7,17,27,34:37,41:44];
        indstruct.T10 = 31:33;
        indstruct.none = [8:10,18:20,28:30,38:40,45:60];
    end
end

%init structs
cellstruct = struct;
cellnames = fieldnames(indstruct);

%loop across cell names
for ii = 1:length(cellnames)
    %init individual cell struct
    cellstruct.(cellnames{ii}) = struct;
    %output OD, GFP, RFP, YFP
    for jj = 1:length(datafields)
        if ~contains(datafields{jj},'time')
            cellstruct.(cellnames{ii}).(datafields{jj}) = ...
                datastruct.(datafields{jj})(:,indstruct.(cellnames{ii}));
        else
            cellstruct.(cellnames{ii}).time = datastruct.(datafields{jj});
        end
    end
end

cellstruct = orderfields(cellstruct);
