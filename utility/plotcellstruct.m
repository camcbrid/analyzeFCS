function plotcellstruct(cellstruct,datatag,xfield,shifton)
%null = plotcellstruct(cellstruct,datatag,xfield)
%plot timeseries for each dataset contained labeled by the fields in 
%cellstruct
%cellstruct cannot be a nested struct (it is not recursive)
%datatag is a string for the title of the graph
%xfield is a string corresponding to the name of the field used for the
%independent variable on the plot

if nargin < 4
    shifton = false;
    if nargin < 3
        xfield = 'time';
        if nargin < 2
            datatag = '';
        end
    end
end

cellfields = fieldnames(cellstruct);
cellfields2 = cellfields(~contains(cellfields,xfield));
n = sum(~contains(cellfields,xfield));  %number of fields to plot not continaing xfield

%missing explicit time vector
if ~any(strcmp(cellfields,xfield))
    %if time is in the name of some fields
    if any(contains(cellfields,xfield))
        %average all timeseries at each point
        cellxfield = cellfields(contains(cellfields,xfield));
        z = zeros(length(cellstruct.(cellxfield{1})),length(cellxfield));
        for jj = 1:length(cellxfield)
             z(:,jj) = cellstruct.(cellxfield{jj})(:);
             cellstruct.(xfield) = mean(z,2);
        end
    else
        %if no time dependence, just plot data points
        cellstruct.(xfield) = 1:length(cellstruct.(cellfields2{1}));
    end
end

figure;
for ii = 1:n
    subplot(3,ceil(n/3),ii);
    plot(cellstruct.(xfield),cellstruct.(cellfields2{ii}),'.')
	xlabel(xfield)
    ylabel(cellfields2{ii})
    title(datatag)
    xlim([min(cellstruct.(xfield)),max(cellstruct.(xfield))])
end
