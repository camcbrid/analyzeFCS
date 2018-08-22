addpath utility
close all

%choose experiment
[fcsopts] = fcsoptions('3 hrs run 1');

%read in data
[cellstruct, datastruct,compflg] = read_all_fcs(fcsopts.datapath);
%relabel datafields
cellstruct = renamefields(cellstruct, fcsopts.platenames);
cellnames = fieldnames(cellstruct);

if ~compflg
    %compensate for fluorescence spillover between channels
    refdata = load('fpspilloverfactors.mat');
    cellstruct = compfluor(cellstruct, refdata.fpstruct);
end

%gate cells
%gate on singlets
cellstruct = gatesinglets(cellstruct,'fsca','fsch');
%gate on low RFP
RGRnames = cellnames(contains(cellnames,{'R1','R2','R3','GR','RY'}));
cellstruct = gatecells(cellstruct,RGRnames,'fl4h',[10^2.8,10^6]);

%find Ghat, Rhat, Yhat for each trial
hatstruct = calcFPhats(cellstruct);
%find J0's for all pairs
Jstruct = findJ02(hatstruct);

%plot everything
figure;
subplot(211);
barplotstruct(hatstruct);
subplot(212);
barplotstruct(Jstruct);

return

%plot
if length(fieldnames(cellstruct)) <= 6
    plotsubfield(cellstruct,'fl1h','fl3h',1)
    plotsubfield(cellstruct,'fl1h','fl2h',2)
    plotsubfield(cellstruct,'fl3h','fl2h',3)
    histsubfield(cellstruct,'fl1h',4,'log')
    histsubfield(cellstruct,'fl3h',5,'log')
    histsubfield(cellstruct,'fl2h',6,'log')
end

cellstruct = normalizefields(cellstruct,'fl1h','ssca','time');
cellstruct = normalizefields(cellstruct,'fl2h','ssca','time');
cellstruct = normalizefields(cellstruct,'fl3h','ssca','time');

movingavestruct(cellstruct,500,'fsca','time')
movingavestruct(cellstruct,500,'ssch','time')
movingavestruct(cellstruct,500,'fl1h','time')
movingavestruct(cellstruct,500,'fl2h','time')
movingavestruct(cellstruct,500,'fl3h','time')
