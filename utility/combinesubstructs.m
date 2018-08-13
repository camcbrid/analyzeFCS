function outstruct = combinesubstructs(datastruct, infostruct)
%OUTSTRUCT = renamefields(DATASTRUCT, NAMESTRUCT)
%replace fieldnames in DATASTRUCT with strings in NAMESTRUCT (optional). 
%Fieldnames in NAMESTRUCT must match those in datastruct. If 2nd argument
%is not given, the new fieldnames are created by taking all characters 
%occuring before a number in all fieldnames in DATASTRUCT.

%init
datafields = fieldnames(datastruct);
outstruct = struct;

%change each field name.
for ii = 1:length(datafields)
    %create new fieldnames
    if nargin < 2
        temp = regexp(datafields{ii},'\d','split');
        newname = temp{1};
    else
        newname = infostruct.(datafields{ii});
    end
    
    %merge each substruct
    if ~isfield(outstruct,newname)
        %init each substruct
        outstruct.(newname) = datastruct.(datafields{ii});
    else
        %append for each subfield
        subdatafields = fieldnames(datastruct.(datafields{ii}));
        for jj = 1:length(subdatafields)
            %check if data is same length
            newdata = datastruct.(datafields{ii}).(subdatafields{jj})(:);
            olddata = outstruct.(newname).(subdatafields{jj});
            oldlen = length(olddata);
            newlen = length(newdata);
            if oldlen < newlen
                %pad olddata with NaN's
                olddata = padarray(olddata,newlen-oldlen,NaN,'post');
            elseif oldlen > newlen
                %pad newdata with NaN's
                newdata = padarray(newdata,oldlen-newlen,NaN,'post');
            end
            %append data
            outstruct.(newname).(subdatafields{jj}) = [olddata,newdata];
        end
    end
end

outstruct = orderfields(outstruct);