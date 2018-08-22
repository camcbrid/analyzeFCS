function diststruct = estimatedist(cellstruct,ploton)

if nargin < 2
    ploton = true;
end

%init
diststruct = struct;
celltypes = fieldnames(cellstruct);
fittype = 'lognormal';

for ii = 1:length(celltypes)
    
    %recursive structs within structs
    if isstruct(cellstruct.(celltypes{ii}))
        disp(celltypes{ii})
        diststruct.(celltypes{ii}) = estimatedist(cellstruct.(celltypes{ii}));
    else
        %skip time field
        if contains(celltypes{ii},'time')
            diststruct.(celltypes{ii}) = cellstruct.(celltypes{ii});
            continue
        end
            %fit distribution using Gaussian kernel function to high frequency data
            %[bandwidth,density,xmesh,cdf] = kde(cellstruct.(celltypes{ii})(:,jj));
            %or use kde2 or akde or ksdensity?
            %or use kde or fitdist
            z = cellstruct.(celltypes{ii})(:);
            %fit distribtuion
            diststruct.(celltypes{ii}) = fitdist(z(z>0),fittype);
    end
end

if ploton
    plotsubfield(diststruct,'pdf','xmesh')
    
    % subplot(2,ceil((length(celltypes)-1)/2),k); hold on
    % histogram(cellstruct.(celltypes{ii})(:,jj),'displaystyle','stairs',...
    %     'binmethod','scott','normalization','pdf')
    % plot(xmesh,density)
    % ylabel('probability density')
    % k = k + 1;
    % xlim([-10,10])
    % subplot(2,length(celltypes),ii+length(celltypes)); hold on
    % plot(xmesh,cdf)
    % xlabel(celltypes{ii})
    % ylabel('cdf')
    % xlim([-10,10])
end


