function outstruct = outputsubfield(datastruct,subfield)
%output all subfields of DATASTRUCT matching the string SUBFIELD in a
%struct.

%init
datafields = fieldnames(datastruct);
outstruct = struct;
%loop through each subfield
for ii = 1:length(datafields)
    outstruct.(datafields{ii}) = datastruct.(datafields{ii}).(subfield);
end