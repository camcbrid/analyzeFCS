function outstruct = applysubstructs(funhandle,datastruct)
%only works for function handles that take in one argument, e.g. @min, 
%@max, @mean, @sum, etc

%init
outstruct = struct;
datafields = fieldnames(datastruct);

%loop through all fields of datastruct
for ii = 1:length(datafields)
    %if we have structs within structs, go one level deeper
    if isstruct(datastruct.(datafields{ii}))
        outstruct.(datafields{ii}) = applysubstructs(funhandle,datastruct.(datafields{ii}));
    else
        %apply funhandle to data in datastruct
        outstruct.(datafields{ii}) = funhandle(datastruct.(datafields{ii}));
    end
end