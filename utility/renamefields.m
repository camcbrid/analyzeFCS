function datastructout = renamefields(datastruct, namestruct)
%DATASTRUCTOUT = renamefields(DATASTRUCT, NAMESTRUCT)
%replace fieldnames in DATASTRUCT with strings in NAMESTRUCT. Fieldnames in
%NAMESTRUCT must match those in datastruct.

%init
datafields = fieldnames(datastruct);
datastructout = struct;

%change each field name.
for ii = 1:length(datafields)
    newname = namestruct.(datafields{ii});
    datastructout.(newname) = datastruct.(datafields{ii});
end
% datastructout = orderfields(datastructout);