function [outstruct,mstruct,fitstruct] = compfluor(cellstruct, fpstruct)
%compensate for fluorescent spillover between channels.

%init
outstruct = cellstruct;
mstruct = struct;
fitstruct = struct;

if nargin < 2
    %compensate for fluorescent leakage
    fitstruct21 = linearfitsubfield(cellstruct,'fl2h','fl1h',1);    %good (orthagonal)
    applytoallsubplots(1,'Line','MarkerSize',1); drawnow
    fitstruct13 = linearfitsubfield(cellstruct,'fl1h','fl3h',2);    %good G, Y
    applytoallsubplots(2,'Line','MarkerSize',1); drawnow
    fitstruct14 = linearfitsubfield(cellstruct,'fl1h','fl4h',3);    %good (orthagonal)
    applytoallsubplots(3,'Line','MarkerSize',1); drawnow
    fitstruct23 = linearfitsubfield(cellstruct,'fl2h','fl3h',4);    %good R, Y
    applytoallsubplots(4,'Line','MarkerSize',1); drawnow
    fitstruct24 = linearfitsubfield(cellstruct,'fl2h','fl4h',5);    %good R
    applytoallsubplots(5,'Line','MarkerSize',1); drawnow
    fitstruct43 = linearfitsubfield(cellstruct,'fl4h','fl3h',6);    %good R, Y
    applytoallsubplots(6,'Line','MarkerSize',1); drawnow
    
    %output
    fitstruct.fit21 = fitstruct21;
    fitstruct.fit13 = fitstruct13;
    fitstruct.fit14 = fitstruct14;
    fitstruct.fit23 = fitstruct23;
    fitstruct.fit24 = fitstruct24;
    fitstruct.fit43 = fitstruct43;
    mstruct.fit21 = outputsubfield(fitstruct.fit21,'m');
    mstruct.fit13 = outputsubfield(fitstruct.fit13,'m');
    mstruct.fit14 = outputsubfield(fitstruct.fit14,'m');
    mstruct.fit23 = outputsubfield(fitstruct.fit23,'m');
    mstruct.fit24 = outputsubfield(fitstruct.fit24,'m');
    mstruct.fit43 = outputsubfield(fitstruct.fit43,'m');
    
    %compensate for GR, GY, RY fluorescent leakage. FL1 = GFP; FL2 = RFP; FL3 =
    %YFP; FL4 = RFP (stronger).
    [outstruct.GR.fl1h, outstruct.GR.fl4h] = compfluorhelp(cellstruct.GR.fl1h,...
        cellstruct.GR.fl4h, fitstruct14.G.m, 1/fitstruct14.R.m);
    [outstruct.GY.fl1h, outstruct.GY.fl3h] = compfluorhelp(cellstruct.GY.fl1h,...
        cellstruct.GY.fl3h, fitstruct13.G.m, 1/fitstruct13.Y.m);
    [outstruct.RY.fl3h, outstruct.RY.fl4h] = compfluorhelp(cellstruct.RY.fl3h,...
        cellstruct.RY.fl4h, 1/fitstruct43.R.m, fitstruct43.Y.m);
    [outstruct.GR.fl1h2, outstruct.GR.fl2h] = compfluorhelp(cellstruct.GR.fl1h,...
        cellstruct.GR.fl2h, 1/fitstruct21.G.m, fitstruct21.R.m);
    [outstruct.RY.fl2h, outstruct.RY.fl3h2] = compfluorhelp(cellstruct.RY.fl2h,...
        cellstruct.RY.fl3h, fitstruct23.R.m, 1/fitstruct23.Y.m);
else
    %compensate for GR, GY, RY fluorescent leakage. FL1 = GFP; FL2 = RFP; FL3 =
    %YFP; FL4 = RFP (stronger).
    
    %identify cell field names
    datafields = fieldnames(cellstruct);
    GRstr = datafields(contains(datafields,'GR'));
    GYstr = datafields(contains(datafields,'GY'));
    RYstr = datafields(contains(datafields,'RY'));
    
    %compensate all GR's
    for ii = 1:length(GRstr)
        [outstruct.(GRstr{ii}).fl1h, outstruct.(GRstr{ii}).fl4h] = ...
            compfluorhelp(cellstruct.(GRstr{ii}).fl1h,...
            cellstruct.(GRstr{ii}).fl4h, fpstruct.G14, fpstruct.R14);
        [outstruct.(GRstr{ii}).fl1h2, outstruct.(GRstr{ii}).fl2h] = ...
            compfluorhelp(cellstruct.(GRstr{ii}).fl1h,...
            cellstruct.(GRstr{ii}).fl2h, fpstruct.G12, fpstruct.R12);
    end
    %compensate all GY's
    for jj = 1:length(GYstr)
        [outstruct.(GYstr{jj}).fl1h, outstruct.(GYstr{jj}).fl3h] = ...
            compfluorhelp(cellstruct.(GYstr{jj}).fl1h,...
            cellstruct.(GYstr{jj}).fl3h, fpstruct.G13, fpstruct.Y13);
    end
    %compensate all RY's
    for k = 1:length(RYstr)
        [outstruct.(RYstr{k}).fl3h, outstruct.(RYstr{k}).fl4h] = ...
            compfluorhelp(cellstruct.(RYstr{k}).fl3h,...
            cellstruct.(RYstr{k}).fl4h, fpstruct.R34, fpstruct.Y34);
        [outstruct.(RYstr{k}).fl2h, outstruct.(RYstr{k}).fl3h2] = ...
            compfluorhelp(cellstruct.(RYstr{k}).fl2h,...
            cellstruct.(RYstr{k}).fl3h, fpstruct.R23, fpstruct.Y23);
    end
end


function [xnew,ynew] = compfluorhelp(x, y, a, b)
%[xnew,ynew] = compfluor2(x,y,a,b)
%a is the fraction amount of signal in the X channel with only Y present
%a is the fraction amount of signal in the Y channel with only X present

%good
xnew = (x - b*y)./(1-a*b);
ynew = (y - a*x)./(1-a*b);
