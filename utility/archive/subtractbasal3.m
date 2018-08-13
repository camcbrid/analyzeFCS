function [newstruct,basalstruct] = subtractbasal3(cellstct,nonefld,mediafld,ODeps,FPeps)
%[newstruct,basalstruct] = subtractbasal3(cellstct,nonefld,mediafld,ODeps,FPeps)
%find basal level for each property by assuming initial conditition should
%be 0 for all properties

if nargin < 5
    ODeps = 0;
    if nargin < 4
        FPeps = 0;
        if nargin < 3
            mediafld = 'M9';
            if nargin < 2
                nonefld = 'T10';
            end
        end
    end
end

%init
newstruct = struct;
cellnames = fieldnames(cellstct);
%find basal levels
basalstruct = findbasallevel3(cellstct.(nonefld),cellstct.(mediafld),ODeps,FPeps);

for ii = 1:length(cellnames)
    dataprops = fieldnames(cellstct.(cellnames{ii}));
    %loop across each cell type
    for jj = 1:length(dataprops)
        %loop across each data property and subtract off basal level
        newstruct.(cellnames{ii}).(dataprops{jj}) = ...
            cellstct.(cellnames{ii}).(dataprops{jj}) - ...
            basalstruct.(dataprops{jj});
    end
end


function basalstruct = findbasallevel3(nonestct,mediastct,ODeps,FPeps)
%find basal levels of each property based on media measurements

basalstruct = struct;
dprops = fieldnames(nonestct);

for ii = 1:length(dprops)
    if isstruct(nonestct.(dprops{ii}))
        basalstruct.(dprops{ii}) = findbasallevel2(nonestct.(dprops{ii}),ODeps,FPeps,n);
    else
        if contains(dprops{ii},'OD')
            basalstruct.(dprops{ii}) = mean(mediastct.(dprops{ii}),2) - ODeps;
        elseif contains(dprops{ii},'FP')
            basalstruct.(dprops{ii}) = mean(nonestct.(dprops{ii}),2) - FPeps;
        elseif contains(dprops{ii},'time') || contains(dprops{ii},'temp')
            basalstruct.(dprops{ii}) = 0;
        else
            basalstruct.(dprops{ii}) = mean(nonestct.(dprops{ii}),2);
        end
    end
end


function basalstruct = findbasallevel(cellstct,ODeps,FPeps)
%find basal levels of each property based on media measurements

basalstruct = struct;
dprops = fieldnames(cellstct);

for ii = 1:length(dprops)
    if isstruct(cellstct.(dprops{ii}))
        basalstruct.(dprops{ii}) = findbasallevel(cellstct.(dprops{ii}),ODeps,FPeps);
    else
        if contains(dprops{ii},'OD')
            basalstruct.(dprops{ii}) = ...
                mean(cellstct.(dprops{ii}),2) - ODeps;
        elseif contains(dprops{ii},'FP')
            basalstruct.(dprops{ii}) = ...
                mean(cellstct.(dprops{ii}),2) - FPeps;
        elseif contains(dprops{ii},'time') || contains(dprops{ii},'temp')
            basalstruct.(dprops{ii}) = 0;
        else
            basalstruct.(dprops{ii}) = ...
                mean(cellstct.(dprops{ii}),2);
        end
    end
end


function basalstruct = findbasallevel2(cellstct,ODeps,FPeps,n)
%find basal levels of each property based on media measurements

basalstruct = struct;
dprops = fieldnames(cellstct);

for ii = 1:length(dprops)
    if isstruct(cellstct.(dprops{ii}))
        basalstruct.(dprops{ii}) = findbasallevel2(cellstct.(dprops{ii}),ODeps,FPeps,n);
    else
        if contains(dprops{ii},'OD')
            basalstruct.(dprops{ii}) = mean(cellstct.(dprops{ii})(1:n,:),1) - ODeps;
        elseif contains(dprops{ii},'FP')
            basalstruct.(dprops{ii}) = mean(cellstct.(dprops{ii})(1:n,:),1) - FPeps;
        elseif contains(dprops{ii},'time') || contains(dprops{ii},'temp')
            basalstruct.(dprops{ii}) = 0;
        else
            basalstruct.(dprops{ii}) = mean(cellstct.(dprops{ii})(1:n,:),1);
        end
    end
end

