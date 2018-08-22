function plotsubfield(cellstruct, xfield, yfield, figh, axscale, linesty, xrng, yrng)
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
            linesty = '.';
            if nargin < 5
                axscale = 'linear';
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
if isempty(axscale)
    axscale = 'linear';
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
if nargin > 3 && ~isempty(figh)
    figure(figh)
else
    figure;
end
%plot each subfield
for jj = 1:n
    subplot(m,ceil(n/m),jj); hold on;
    x = cellstruct.(celltypes{jj}).(xfield);
    y = cellstruct.(celltypes{jj}).(yfield);
    [x,y] = downsampleplot(x,y,n);
    if length(x) > 10
        z = sortrows([x(:),y(:)]);
    else
        z = [x(:),y(:)];
    end
    plot(z(:,1),z(:,2),linesty,'MarkerSize',2)%,...
        %'MarkerEdgeColor',0.5*[1,1,1],'MarkerFaceColor',0.5*[1,1,1])
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
    if strcmp(xfield,'time')
        xlim([min(x),max(x)])
        xticks([min(x),max(x)])
    else
        xlim([min(xrng),max(xrng)])
    end
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


function [xnew,ynew] = downsampleplot(x,y,n)
%[xnew,ynew] = downsampleplot(x,y,n)
%downsample to make plots faster to create.
%n is the number of plots to create

maxptstot = 20000;
m = length(x);

%amount to downsample
z = m/(maxptstot/n);

if z < 1
    %no downsampling necessary
    xnew = x;
    ynew = y;
    return
else
    inds = round(1:z:m);
    xnew = x(inds);
    ynew = y(inds);
end
