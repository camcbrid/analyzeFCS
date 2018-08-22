function histsubfield(cellstruct, xfield, figh, axscale, xrng)
%plotsubfield(cellstruct, xfield, yfield, figh, linesty, axscale, xrng, yrng)
%plot one subfield for each field in a struct. XFIELD and YFIELD must match to a
%valid field for all substructs contined in CELLSTRUCT.

%get fields for each cell type
celltypes = fieldnames(cellstruct);
n = length(celltypes);                  %number of subplots (fields) to make
m = ceil(9/16*sqrt(n));                 %number of rows of subplots

%defaults
if nargin < 5
    xrng = [substructfun(@min,cellstruct,xfield),...
        substructfun(@max,cellstruct,xfield)];
    if nargin < 4
        axscale = 'linear';
        if nargin < 2
            xfield = 'fl1h';
        end
    end
end

%input error checking
if ~ischar(xfield)% || ~any(substructfun(@contains,cellstruct,xfield))
    error('xfield not subfield in cellstruct')
end

%check that each cell type has a time field
cellprops = cell(n,1);
meanstruct = struct;
stdstruct = struct;
for ii = 1:n
    cellprops{ii} = fieldnames(cellstruct.(celltypes{ii}));
    %missing explicit (xfield) vector
    if ~any(strcmp(cellprops{ii},xfield))
        cellstruct.(celltypes{ii}).(xfield) = 1:length(cellstruct.(celltypes{ii}));
    end
    x = cellstruct.(celltypes{ii}).(xfield);
    meanstruct.(celltypes{ii}).geo = geomean(x(x>0));
    %meanstruct.(celltypes{ii}).arith = mean(x(x>0));
    stdstruct.(celltypes{ii}).geo = geostd(x(x>0));
    %stdstruct.(celltypes{ii}).arith = std(x(x>0));
end

%plot each struct's subfield on one plot
if nargin > 2 && ~isempty(figh)
    figure(figh)
else
    figure;
end
%plot each subfield
for jj = 1:n
    subplot(m,ceil(n/m),jj); hold on;
    x = cellstruct.(celltypes{jj}).(xfield)(:);
    if ~strcmp(axscale,'log')
        histogram(x,'binmethod','scott','normalization','pdf',...
            'displaystyle','stairs'); hold on
        errorbar(meanstruct.(celltypes{jj}).geo,1,stdstruct.(celltypes{jj}).geo,...
            'horizontal','kx')
        errorbar(meanstruct.(celltypes{jj}).arith,0.5,stdstruct.(celltypes{jj}).arith,...
            'horizontal','ko')
        if n - jj < ceil(n/m)
            xlabel(xfield)
        end
        xlim([min(xrng),max(xrng)])
    else
        histogram(log10(x(x>0)),'binmethod','scott','normalization','pdf',...
            'displaystyle','stairs'); hold on
        errorbar(log10(meanstruct.(celltypes{jj}).geo),1,log10(stdstruct.(celltypes{jj}).geo),...
            'horizontal','kx')
        %errorbar(log10(meanstruct.(celltypes{jj}).arith),0.5,log10(stdstruct.(celltypes{jj}).arith),...
        %    'horizontal','ko')
        if n - jj < ceil(n/m)
            xlabel(['log_{10}(',xfield,')'])
        end
        if min(xrng) <= 0; xrng(1) = 1e0; end
        xlim([log10(min(xrng)),log10(max(xrng))])
    end
    title(celltypes{jj})
    %put xaxis and yaxis labels on outer plots only
    if mod(jj,ceil(n/m)) == 1
        ylabel('pdf')
    end
    
end


function output = substructfun(funhandle,cellstruct,fieldstr)
%apply FUNHANDLE to all substructs in CELLSTRUCT with subfield FIELDSTR

datafields = fieldnames(cellstruct);
temp = cell(length(datafields),1);
for ii = 1:length(datafields)
    temp{ii} = funhandle(cellstruct.(datafields{ii}).(fieldstr));
end
output  = funhandle(cell2mat(temp));

