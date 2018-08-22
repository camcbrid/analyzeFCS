function [fcsopts,platenames] = fcsoptions(expname)

fcsopts = struct;

expname = strrep(expname,' ','');
if contains(expname,'3hrsrun1')
    %3 hrs
    fcsopts.time = '3 hrs';
    fcsopts.datapath = 'D:\Research\Experimental\FCS\RS FCS 2018-08-02\CFlow-FCS Exports\20180810_1344283hrs_comp';
    fcsopts.platenames = struct(...
        'A01','G1', 'B01','G2', 'C01','G3',...
        'A02','R1', 'B02','R2', 'C02','R3',...
        'A03','Y1', 'B03','Y2', 'C03','Y3',...
        'A04','GR1', 'B04','GR2', 'C04','GR3',...
        'A05','GY1', 'B05','GY2', 'C05','GY3',...
        'A06','RY1', 'B06','RY2', 'C06','RY3');
elseif contains(expname,'6hrsrun1')
    %experiment 6 hrs
    fcsopts.time = '6 hrs';
    fcsopts.datapath = 'D:\Research\Experimental\FCS\RS FCS 2018-08-02\CFlow-FCS Exports\20180810_1342116hrs_comp';
    fcsopts.platenames = struct(...
        'A01','G1', 'B01','G2', 'C01','G3',...
        'A02','R1', 'B02','R2', 'C02','R3',...
        'A03','Y1', 'B03','Y2', 'C03','Y3',...
        'A04','GR1', 'B04','GR2', 'C04','GR3',...
        'A05','GY1', 'B05','GY2', 'C05','GY3',...
        'A06','RY1', 'B06','RY2', 'C06','RY3',...
        'B08','cleaning','C08','DI_H20');
elseif contains(expname,'washrun1')
    %experiment 6 hrs
    fcsopts.time = 'n/a';
    fcsopts.datapath = 'D:\Research\Experimental\FCS\RS FCS 2018-08-02\CFlow-FCS Exports\Wash2018_0802';
    platenames = struct('A01','G1');
elseif contains(expname,'overnightrun1')
    %experiment 6 hrs
    fcsopts.time = '0 hrs';
    fcsopts.datapath = 'D:\Research\Experimental\FCS\RS FCS 2018-08-02\CFlow-FCS Exports\20180810_133639overnight_comp';
    fcsopts.platenames = struct(...
        'A01','G','A02','R','A03','Y',...
        'B01','GR','B02','GY','B03','RY');
elseif contains(expname,'yili')
    %yili isocost experiment?
    fcsopts.time = '0 hrs';
    fcsopts.datapath = 'D:\Research\Experimental\FCS\20180815_143908_yili';
    fcsopts.platenames = struct;
elseif contains(expname,'thirdparty')
    fcsopts.datapath = 'D:\Research\Experimental\FCS\CFlow-FCS Exports_new\20180822_144033_third_party';
    fcsopts.platenames = struct;
elseif contains(expname,'exportfcs')
    fcsopts.datapath = 'D:\Research\Experimental\FCS\CFlow-FCS Exports_new\20180822_144220_export_fcs';
    fcsopts.platenames = struct;
else
    error('does not match valid experiment condition')
end