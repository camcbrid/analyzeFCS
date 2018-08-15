function outstruct = normalizefields(datastruct,outfield,normfield,tfield)

if nargin < 4
    tfield = 'time';
    if nargin < 3
        normfield = 'fsca';
    end
end

%init
datafields = fieldnames(datastruct);
outstruct = datastruct;

for ii = 1:length(datafields)
    x = datastruct.(datafields{ii}).(outfield);
    y = datastruct.(datafields{ii}).(normfield);
    %x = x(y > 0);
    %y = y(y > 0);
    if length(x) == length(y)
        %normalize 'outfield' by 'normfield'
        outstruct.(datafields{ii}).([outfield,'norm']) = x./y;
    elseif length(x) > length(y)
        %pad with zeros
        outstruct.(datafields{ii}).([outfield,'norm']) = x./y;
    elseif length(x) < length(y)
        %pad with zeros
        outstruct.(datafields{ii}).([outfield,'norm']) = x./y;
    end
end

%plot
movingavestruct(outstruct,500,[outfield,'norm'],'time')
