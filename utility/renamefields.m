function outstruct = renamefields(datastruct, namestruct)
%DATASTRUCTOUT = renamefields(DATASTRUCT, NAMESTRUCT)
%replace fieldnames in DATASTRUCT with strings in NAMESTRUCT. Fieldnames in
%NAMESTRUCT must match those in datastruct.

if ~isstruct(namestruct)
    outstruct = datastruct;
    return
elseif isempty(fieldnames(namestruct))
    outstruct = datastruct;
    return
end

%init
datafields = fieldnames(datastruct);
outstruct = struct;

%change each field name.
for ii = 1:length(datafields)
    newname = namestruct.(datafields{ii});
    outstruct.(newname) = datastruct.(datafields{ii});
end
% datastructout = orderfields(datastructout);