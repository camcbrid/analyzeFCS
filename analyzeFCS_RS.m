addpath utility
close all

%choose experiment
[fcsopts] = fcsoptions('yili');

%read in data
[cellstruct, datastruct,compflg] = read_all_fcs(fcsopts.datapath);
%relabel datafields
cellstruct = renamefields(cellstruct, fcsopts.platenames);
cellnames = fieldnames(cellstruct);

if ~compflg
    %compensate for fluorescence spillover between channels
    refdata = load('fpspilloverfactors.mat');
    cellstructcomp = compfluor(cellstruct, refdata.fpstruct);
    
    %gate cells
    RGRnames = cellnames(contains(cellnames,{'R1','R2','R3','GR'}));
    cellstructcomp = gatecells(cellstructcomp,RGRnames,'fl4h',[10^2.8,10^6]);
    
    %plot
    if length(fieldnames(cellstruct)) <= 30
        disp('plotting data...')
        plotsubfield(cellstruct,'fl1h','fl3h',1)
        plotsubfield(cellstructcomp,'fl1h','fl3h',1)
        plotsubfield(cellstruct,'fl1h','fl2h',2)
        plotsubfield(cellstructcomp,'fl1h','fl4h',2)
        plotsubfield(cellstruct,'fl3h','fl2h',3)
        plotsubfield(cellstructcomp,'fl3h','fl2h',3)
        histsubfield(cellstruct,'fl1h',4,'log')
        histsubfield(cellstructcomp,'fl1h',4,'log')
        histsubfield(cellstruct,'fl3h',5,'log')
        histsubfield(cellstructcomp,'fl3h',5,'log')
        histsubfield(cellstruct,'fl2h',6,'log')
        histsubfield(cellstructcomp,'fl2h',6,'log')
    end
else
    %copy over
    cellstrcutcomp = cellstruct;
    
    %gate cells
    RGRnames = cellnames(contains(cellnames,{'R1','R2','R3','GR'}));
    cellstructcomp = gatecells(cellstructcomp,RGRnames,'fl4h',[10^2.8,10^6]);
    
    %plot
    if length(fieldnames(cellstruct)) <= 30
        plotsubfield(cellstructcomp,'fl1h','fl3h',1)
        plotsubfield(cellstructcomp,'fl1h','fl4h',2)
        plotsubfield(cellstructcomp,'fl3h','fl4h',3)
        histsubfield(cellstructcomp,'fl1h',4,'log')
        histsubfield(cellstructcomp,'fl3h',5,'log')
        histsubfield(cellstructcomp,'fl4h',6,'log')
    end
end

movingavestruct(cellstruct,500,'fsca','time')
movingavestruct(cellstruct,500,'ssca','time')
movingavestruct(cellstruct,500,'fl1h','time')
movingavestruct(cellstruct,500,'fl4h','time')

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
