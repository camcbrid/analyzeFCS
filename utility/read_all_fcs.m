function [datastruct, datastruct2, compflg] = read_all_fcs(folderpath)
% [DATASTRUCT, DATASTRUCT2, COMPFLG] = read_all_fcs(FOLDERPATH)
% read every *.fcs file at FOLDERPATH and output data formatted as structs.
% DATASTRUCT has subfields with filenames and subsubfields of data
% properties, DATASTRUCT2 has subfields of data properties and subsubfields
% of filenames. COMPFLG is set to 1 if all files had color-compensated data
% and set 0 otherwise.

%init
datastruct = struct;
datastruct2 = struct;

%get all filenames with extension '.fcs'
root = pwd;
cd(folderpath)
D = dir('*.fcs');
filenames = strrep({D.name},'.fcs','');

%read each file
compflgvec = zeros(length(filenames),1);
for ii = 1:length(filenames)
    disp(filenames{ii})
    %read in data from FCS file
    [fcsdat, fcshdr, fcsdatscaled, fcsdat_comp] = fca_readfcs([filenames{ii},'.fcs']);
    %ignore scaling and compensation done on machine
    
    %output as structs
    datafields = lower(strrep({fcshdr.par.name},'-',''));
    for jj = 1:length(datafields)
        if ~isempty(fcsdat_comp)
            compflgvec(ii) = 1;
            datastruct.(filenames{ii}).(datafields{jj}) = fcsdat_comp(:,jj);
            datastruct2.(datafields{jj}).(filenames{ii}) = fcsdat_comp(:,jj);
        else
            compflgvec(ii) = 0;
            datastruct.(filenames{ii}).(datafields{jj}) = fcsdat(:,jj);
            datastruct2.(datafields{jj}).(filenames{ii}) = fcsdat(:,jj);
        end
    end
end
compflg = floor(sum(compflgvec)/length(filenames));
if compflg == 0
    disp('uncompensated FCS data')
else
    disp('compensated FCS data')
end
cd(root);