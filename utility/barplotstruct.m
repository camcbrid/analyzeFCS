function barplotstruct(datastruct,datatag)
%create barplot using field


if nargin < 2
    datatag = '';
end
%find names for each field not including 'std', 'error', or 'err'
datafields = fieldnames(datastruct);
plotfields = datafields(~contains(datafields,{'std','error','err'}));

%init
z = zeros(length(plotfields),1);
zstd = zeros(length(plotfields),1);
%loop through each name
for ii = 1:length(plotfields)
    z(ii) = datastruct.(plotfields{ii});
    stdfield = datafields(strcmp(datafields,[plotfields{ii},'std']));
    if ~isempty(stdfield)
        zstd(ii) = datastruct.(stdfield{1});
    else
        zstd(ii) = 0;
    end
end

%make plot
c = categorical(plotfields);
cla;
bar(c,z,'FaceColor',[0,0.4470,0.7410]); hold on
errorbar(z,zstd,'.k')
ylabel(datatag)