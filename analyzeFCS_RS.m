addpath utility
close all

%choose experiment
%select folder with experimental data inside
[fcsopts] = fcsoptions('');

%read in data
[cellstruct, datastruct,compflg] = read_all_fcs(fcsopts.datapath);
%relabel datafields
cellstruct = renamefields(cellstruct, fcsopts.platenames);
cellnames = fieldnames(cellstruct);

%gate on singlets
cellstruct = gatesinglets(cellstruct,'fsca','fsch');

%smooth fields
% movingavestruct(cellstruct,500,'fl1h','time',2)
% movingavestruct(cellstruct,500,'fl2h','time',3)
% movingavestruct(cellstruct,500,'fl3h','time',4)

if ~compflg
    %compensate for fluorescence spillover between channels
    %refdata = load('fpspilloverfactors.mat');
    [cellstructcomp,mstruct,fitstruct] = compfluor2(cellstruct,0);
end

movingavestruct(cellstructcomp,500,'fl1h','time',2)
movingavestruct(cellstructcomp,500,'fl2h','time',3)
movingavestruct(cellstructcomp,500,'fl3h','time',4)

% estimatedist(cellstructcomp,'fl1h','gamma',5);
% estimatedist(cellstructcomp,'fl2h','gamma',6);
% estimatedist(cellstructcomp,'fl3h','gamma',7);
% estimatedist(cellstructcomp,'fl1h','lognormal',5);
% estimatedist(cellstructcomp,'fl2h','lognormal',6);
% estimatedist(cellstructcomp,'fl3h','lognormal',7);
histsubfield(cellstructcomp,'fl1h',5,'log')
histsubfield(cellstructcomp,'fl2h',6,'log')
histsubfield(cellstructcomp,'fl3h',7,'log')

%gate cells
%gate on low RFP
%RGRnames = cellnames(contains(cellnames,{'R1','R2','R3','GR','RY'}));
%cellstruct = gatecells(cellstruct,RGRnames,'fl4h',[10^2.8,10^6]);

return
%find Ghat, Rhat, Yhat for each trial
hatstruct = calcFPhats(cellstructcomp);
%find J0's for all pairs
Jstruct = findJ02(hatstruct);

%plot everything
figure;
subplot(211);
barplotstruct(hatstruct);
subplot(212);
barplotstruct(Jstruct);

%old
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
