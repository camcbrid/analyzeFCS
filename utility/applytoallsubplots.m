function applytoallsubplots(figh, proptype, propname, propvalue)
%applytoallsubplots(FIGH, PROPTYPE, PROPNAME, PROPVALUE)
%Change the properties of all children in the figure. May apply for any 
%figure properties, axis properties, or line properties.
%Valid options for PROPTYPE are 'figure', 'axis', or 'line'.
%PROPNAME may be any valid property field for the correpsonding figure,
%axis, or line properties. PROPVALUE is the value to set the desired 
%property for all subplots in FIGH.

if nargin < 4
    propvalue = 'log';
    if nargin < 3
        propname = 'yscale';
        if nargin < 2
            proptype = 'axis';
            if nargin < 1
                figh = gcf;
            end
        end
    end
end

if isnumeric(figh) && ~isempty(figh)
    figh = figure(figh);
elseif isgraphics(figh)
    figh = figure(figh);
else
    figh = gcf;
end

%if 
if strcmpi(proptype,'line')
    for ii = 1:length(figh.Children)
        for jj = 1:length(figh.Children(ii).Children)
            set(figh.Children(ii).Children(jj),propname,propvalue)
        end
    end
elseif strcmpi(proptype,'axis')
    for ii = 1:length(figh.Children)
        set(figh.Children(ii),propname,propvalue)
    end
elseif strcmpi(proptype,'figure')
    set(figh,propname,propvalue)
end

