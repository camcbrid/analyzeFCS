function plotsubfield(cellstruct, xfield, yfield, figh, linesty, axscale, xrng, yrng)
%plotsubfield(cellstruct, xfield, yfield, figh, linesty, axscale, xrng, yrng)
%plot one subfield for each field in a struct. XFIELD and YFIELD must match to a
%valid field for all substructs contined in CELLSTRUCT.

%get fields for each cell type
celltypes = fieldnames(cellstruct);
n = length(celltypes);                  %number of subplots (fields) to make
m = ceil(9/16*sqrt(n));                 %number of rows of subplots

%defaults
if nargin < 8
    yrng = [substructfun(@min,cellstruct,yfield),...
        substructfun(@max,cellstruct,yfield)];
    if nargin < 7
        xrng = [substructfun(@min,cellstruct,xfield),...
            substructfun(@max,cellstruct,xfield)];
        if nargin < 6
            axscale = 'linear';
            if nargin < 5
                linesty = '.';
                if nargin < 3
                    yfield = 'fl3h';
                    if nargin < 2
                        xfield = 'fl1h';
                    end
                end
            end
        end
    end
end

%input error checking
if ~ischar(xfield)% || ~any(substructfun(@contains,cellstruct,xfield))
    error('xfield not subfield in cellstruct')
end
if ~ischar(yfield)% || ~any(substructfun(@contains,cellstruct,yfield))
    error('yfield not subfield in cellstruct')
end

%check that each cell type has a time field
cellprops = cell(n,1);
for ii = 1:n
    cellprops{ii} = fieldnames(cellstruct.(celltypes{ii}));
    %missing explicit (xfield) vector
    if ~any(strcmp(cellprops{ii},xfield))
        cellstruct.(celltypes{ii}).(xfield) = 1:length(cellstruct.(celltypes{ii}));
    end
end

%plot each struct's subfield on one plot
if nargin > 3
    figure(figh)
else
    figure;
end
%plot each subfield
for jj = 1:n
    subplot(m,ceil(n/m),jj); hold on;
    x = cellstruct.(celltypes{jj}).(xfield);
    y = cellstruct.(celltypes{jj}).(yfield);
    z = sortrows([x(:),y(:)]);
    plot(z(:,1),z(:,2),linesty)
    set(gca,'xscale',axscale);
    set(gca,'yscale',axscale);
    title(celltypes{jj})
    %put xaxis and yaxis labels on outer plots only
    if mod(jj,ceil(n/m)) == 1
        ylabel(yfield)
    end
    if n - jj < ceil(n/m)
        xlabel(xfield)
    else
        %xticks([])
    end
    xlim([min(xrng),max(xrng)])
    ylim([min(yrng),max(yrng)])
end


function output = substructfun(funhandle,cellstruct,fieldstr)
%apply FUNHANDLE to all substructs in CELLSTRUCT with subfield FIELDSTR

datafields = fieldnames(cellstruct);
temp = cell(length(datafields),1);
for ii = 1:length(datafields)
    temp{ii} = funhandle(cellstruct.(datafields{ii}).(fieldstr));
end

output  = funhandle(cell2mat(temp));
