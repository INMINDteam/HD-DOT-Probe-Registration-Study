clear all;close all;clc
restoredefaultpath
clc

%Adding directories and tool boxes that are needed 
% %iso2mesh
dir_iso2mesh = 'E:\PadovaPostDoc\iso2mesh-master'
% Add the paths
addpath(genpath(dir_iso2mesh))

%these are the .mat files that contain the registered co-ordinates
dir_mat_sensors = 'E:\PadovaPostDoc\Sleeping_Memory_NewBorns\DATA\data_sensors_matfiles';
cd(dir_mat_sensors)

% Add to the path to lumomat
dir_lumomat = 'E:\PadovaPostDoc\Sleeping_Memory_NewBorns\lumomat-master';
addpath(genpath(dir_lumomat))

% Homer3
% Path to the Homer folder
dir_homer = 'E:\PadovaPostDoc\homer3-1.80.2';

% Add Homer3
current_path = pwd;
cd(dir_homer)
setpaths
cd(current_path)

%add fdr_bh to your path
%https://uk.mathworks.com/matlabcentral/fileexchange/27418-fdr_bh
%David Groppe (2026). fdr_bh (https://uk.mathworks.com/matlabcentral/fileexchange/27418-fdr_bh), MATLAB Central File Exchange. Retrieved October 26, 2026. 
addpath("E:\PadovaPostDoc\fdr_bh")

% Path to the input data folder, this is not needed with the other files
% downloaded!
%dir_data_raw = 'D:\RE-MIND\DATA-RE-MIND\DATA-original';
%% This is a list of the subjects gestational age (GA)
week_GA_subs = [39
38
41
39
41
41
39
40
39
39
39
40
40
38
40
37
38
39
40
41
40
41
39
41
37
40
38
39
39
40
38
39
39
40
39
38
39
41
41
38
40
38
40
40
39
37
38
40
38
42
39
40
39
41
38
39
40
37
38
39
40
38
41
41];
week_GA_subs(:,2) = [1:1:size(week_GA_subs,1)]';

week_GA_subs(66:81,1) = [40
38
39
39
37
41
38
42
38
42
38
40
41
39
39
40];

week_GA_subs(66:81,2) = [66:1:81]';

week_GA_subs(83:118,1) = [40
40
41

38
39
40
39
40

38
39
40
38
38
40
39
41

38 %99
39
40
37
41
42
39
38
39
40
37
41 %110
39 %111
41
41
40
40
40
42
40]; %188

%111-118

week_GA_subs(83:118,2) = [83:1:118]';

% pic or grande cap size, the gap is either small (picolla) or large
% (grande)
pic_or_grande = [2
1
2
1
1
1
2
1
2
2
2
1
1
1
1
2
2
2
1
2
1
2
1
1
1
1
2
1
1
1
1
1
1
2
2
1
2
2
1
1
1
1
1
1
1
2
2
2
2
2
2
2
1
1
1
1
2
1
2
1
2
1
1
1
1
1
1
2
2
2
2
2
1
1
2
2
1
1
2
1
1
2
2
1
1

1
1
1
1
1

2
1
2
2
1
1
1
1  

%99
2

2
1
1
1
2
1
1
1
1
1
1 %110

1
2
2
1
1
1
1
1]; %118

weekGA_subs_p_G = [week_GA_subs  pic_or_grande    ];

%both pic and grande have meshGA from 37:42! - so create these meshes
weeksGA_pic = unique( weekGA_subs_p_G(find(weekGA_subs_p_G(:,3)==1) ,1));
weeksGA_grande = unique( weekGA_subs_p_G(find(weekGA_subs_p_G(:,3)==2) ,1));

weeksGA_pic = nonzeros(weeksGA_pic);
weeksGA_grande = nonzeros(weeksGA_grande);
%% 02 02 26 correlate probe displacement with subject stats, HC, BW, sex GA etc. 

load('E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\eucdist-pic_subs_probes_all.mat');

%SubjectID	sub-08-rv137	sub-12-eb150	sub-13-nm151	sub-14-nb152	sub-19-lr157	sub-21-zn159	sub-23-ev161	sub-24-ac162	sub-25-mc163	sub-26-cu164	sub-28-ml166	sub-29-ym167	sub-30-am168	sub-31-cm169	sub-32-gf170	sub-33-cn171	sub-36-fv174	sub-39-bm177	sub-40-in178	sub-41-mm179	sub-42-ar180	sub-43-gg181	sub-44-gl202	sub-53-pr211	sub-54-mv212	sub-55-bm213	sub-56-mf214	sub-58-ad216	sub-60-ar218	sub-62-ac220	sub-63-el221	sub-65-zm332	sub-66-ef333	sub-67-ec334	sub-73-lf340	sub-74-vp341	sub-77-ro344	sub-80-rc348	sub-81-nb349	sub-85-ed352	sub-86-gg369	sub-87-mw370	sub-88-sl371	sub-89-bs372	sub-90-md373	sub-92-nb375	sub-95-gb378	sub-96-rf379	sub-98-em402
%HC	
meta_data_pic_subs_sm.hc = [35	34.5	34.3	33.8	34.8	33	33.5	34	34	33.5	32	34	34.5	31	34.2	34.2	34.5	32.7	31.5	32	33	33.6	34	36	33.6	34	34.2	32.7	32	33.4	35.5	35.5	34	33.8	34.5	33	33.5	33.8	34.5	34.4	33.8	35	34	32	33	34.5	34.5	37	36]';
%Age_days	
meta_data_pic_subs_sm.age_acq = [1	2	4	1	2	2	2	3	6	4	2	1	2	0	0	3	2	3	2	3	0	2	1	2	2	2	1	1	0	1	1	3	0	3	1	3	2	1	1	1	1	1	1	0	1	1	0	2	1]';
%Weight	
meta_data_pic_subs_sm.bw = [2800	3480	3440	3300	3520	3320	3480	2820	3150	3000	2860	2830	3610	3054	3120	2775	3100	2970	2320	2870	2750	2920	3168	2829	3830	3053	2890	2390	2987	2870	3120	3510	3260	3265	3260	2544	3270	3082	3505	3860	3390	3410	3450	2828	3250	3290	3760	3500	3180]';
%Length	
meta_data_pic_subs_sm.length = [47	52	51	47	50	50	47	48	49	47	47	48	50	47	47	46	50	48	43	48	47	49	50	49	51	48	49	47	47	47	49	49	50	50	52	48	48	48	52	49	49	50	50	46	50	47	50	48	48]';
%GA_days	
meta_data_pic_subs_sm.GA = [283	277	278	265	278	281	270	286	262	281	276	274	281	267	270	272	263	285	269	277	267	281	280	276	286	266	273	260	274	268	289	268	282	264	291	266	281	271	290	287	269	270	282	273	280	273	268	277	285]';

avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic = mean(euc_dist_model_src_det_stormn_src_det_allsubs_pic,2);

[rho(1),pval(1)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.hc);
[rho(2),pval(2)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.age_acq);
[rho(3),pval(3)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.bw);
[rho(4),pval(4)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.GA);
[rho(5),pval(5)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.length);

r_p_val = [rho ; pval];
%% allignemnt vs sum accelerometer 
load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\subs_pic_used.mat");

%subject index
subjects = {...
    '001pv130',...
    '002et131',...
    '003ep132',...
    '004ma133',...
    '005cm134',...
    '006rk135',...
    '007es136',...
    '008rv137',...
    '009ym138',...
    '010gb139',...
    '011vz140',...
    '012eb150',...
    '013nm151',...
    '014nb152',...
    '015ms153',...
    '016lg154',...
    '017gb155',...
    '018mp156',...
    '019lr157',...
    '020pb158',...
    '021zn159',...
    '022sc160',...
    '023ev161',...
    '024ac162',...
    '025mc163',...
    '026cu164',...
    '027lt165',...
    '028ml166',...
    '029ym167',...
    '030am168',...
    '031cm169',...
    '032gf170',...
    '033cn171',...
    '034lb172',...
    '035gc173',...
    '036fv174',...
    '037bt175',...
    '038ge176',...
    '039bm177',...
    '040in178',...
    '041mm179',...
    '042ar180',...
    '043gg181',...
    '044gl202',...
    '045mt203',...
    '046gf204',...
    '047rm205',...
    '048dn206',...
    '049db207',...
    '050cp208',...
    '051dp209',...
    '052ez210',...
    '053pr211',...
    '054mv212',...
    '055bm213',...
    '056mf214',...
    '057gc215',...
    '058ad216',...
    '059nh217',...
    '060ar218',...
    '061eo219',...
    '062ac220',...
    '063el221',...
    '064lz331',...
    '065zm332',...
    '066ef333',...
    '067ec334',...
    '068cp335',...
    '069lm336',...
    '070rm337',...
    '071gc338',...
    '072af339',...
    '073lf340',...
    '074vp341',...
    '075sb342',...
    '076lm343',...
    '077ro344',...
    '078ga345',...
    '079tf346',...
    '080rc348',...
    '081nb349',...
    '082nz347',...
    '083gv350',...
    '084vb351',...
    '085ed352',...
    '086gg369',...
    '087mw370',...
    '088sl371',...
    '089bs372',...
    '090md373',...
    '091si374',...
    '092nb375',...
    '093ah376',...
    '094er377',...
    '095gb378',...
    '096rf379',...
    '097mc401',...
    '098em402',...
    '099rc409',...
    '100as500',...
    '101vd501',...
    '102ab502',...
    '103cz503',...
    '104ag504',...
    '105sm505',...
    '106bl506',...
    '107lz507',...
    '108ca508',...
    '109aa509',...
    '110rf510',...
    '111am511',...
    '112cm512',...
    '113gt513',...
    '114mc514',...
    '115mc515',...
    '116cc516',...
    '117dg517',...
    '118mz518'
    };

% name of the task
task = 'remind';

% session
session = '01';

%subs_pic_used;
%subjects_pic_used = subjects{subs_pic_used};

% Run the preprocessing

% %%%%% The code below generates the subject meta data, but is commented
% since it requires all the raw data to be avaliable, which is outside of
% the scope of this study!

% %if you want all subs, run this line below
% %subs_pic_used = [1:1:118]';
% 
% %subs pic used
% subs_pic_used_sum_acc = zeros(size(subs_pic_used,1),7);
% subs_pic_used_sum_mag_gyr = zeros(size(subs_pic_used,1),7);
% 
% subs_pic_used_sum_abs_acc = zeros(size(subs_pic_used,1),7);
% subs_pic_used_sum_abs_gyr = zeros(size(subs_pic_used,1),7);
% 
% subs_pic_used_ntpts = zeros(size(subs_pic_used,1),7);
% 
% 
% 
% for isbj=1:length(subs_pic_used)
% 
%     thesubject = subjects{subs_pic_used(isbj)};
% 
%     fprintf('\n==========================================\n')
%     fprintf('Processing subject: %s\n',thesubject)
% 
%     fff_lufr = dir(fullfile(dir_data_raw,['sub-' thesubject],'nirs','*.lufr'));
% 
%     for irun=1:length(fff_lufr)
% 
%         % files and folders
%         % -----------------------------------------------------------------
% 
%         % folder and file lumomat raw
%         ifile = fff_lufr(irun).name;
%         ifolder = fff_lufr(irun).folder;
%         ifolderfile_in_lufr = fullfile(ifolder, ifile);
% 
%         % bids output folder
%         %bids_out_folder = fullfile(dir_data_bids, ['sub-' thesubject], ['ses-' session], 'nirs');
%         %if ~exist(bids_out_folder, 'dir')
%         %    mkdir(bids_out_folder)
%         %end        
% 
%         % load lufr (to see saturatinon and errors recording)
%         % -----------------------------------------------------------------
%         lufr = LumoData(ifolderfile_in_lufr);
% 
%         %avg_acc = squeeze(mean(mean(lufr.data.node_acc,1,"omitnan"),2));
%         %avg_gyr = squeeze(mean(mean(lufr.data.node_gyr,1,"omitnan"),2));
% 
%         avg_gyr_xyz = squeeze(mean(lufr.data.node_gyr,1,"omitnan"));
%         avg_acc_xyz = squeeze(mean(lufr.data.node_acc,1,"omitnan"));
% 
%         sub_avg_gyr_xyz{isbj,irun} = avg_gyr_xyz;
%         sub_avg_acc_xyz{isbj,irun} = avg_acc_xyz;
% 
%         %n = norm(avg_gyr_xyz);
%         mag_avg_gyr_xyz = vecnorm(avg_gyr_xyz,2,1); %2 default val, 1 means do across cols
%         mag_avg_acc_xyz = vecnorm(avg_acc_xyz,2,1); %2 default val, 1 means do across cols
% 
% 
%         subs_pic_used_sum_mag_acc(isbj,irun) = sum(mag_avg_acc_xyz);
%         subs_pic_used_sum_mag_gyr(isbj,irun) = sum(mag_avg_gyr_xyz);
% 
%         %subs_pic_used_sum_abs_acc(isbj,irun) = sum(abs(avg_acc));
%         %subs_pic_used_sum_abs_gyr(isbj,irun) = sum(abs(avg_gyr));
%         subs_pic_used_ntpts(isbj,irun) = size(avg_acc_xyz,2);
%     end
% end
% 
% meta_data_pic_subs_sm.subs_pic_used = subs_pic_used;
% 
% meta_data_pic_subs_sm.motion_data.avg_acc_xyz = avg_acc_xyz;
% meta_data_pic_subs_sm.motion_data.avg_gyr_xyz = avg_gyr_xyz;
% 
% meta_data_pic_subs_sm.motion_data.mag_avg_acc_xyz = mag_avg_acc_xyz;
% meta_data_pic_subs_sm.motion_data.mag_avg_gyr_xyz = mag_avg_gyr_xyz;
% 
% meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_acc = subs_pic_used_sum_mag_acc;
% meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_gyr = subs_pic_used_sum_mag_gyr;
% meta_data_pic_subs_sm.motion_data.subs_pic_used_ntpts = subs_pic_used_ntpts;
% 
% meta_data_pic_subs_sm.motion_data.sub_avg_gyr_xyz = sub_avg_gyr_xyz;
% meta_data_pic_subs_sm.motion_data.sub_avg_acc_xyz = sub_avg_acc_xyz;
% 
% meta_data_pic_subs_sm.subjects = subjects;
% meta_data_subs = meta_data_pic_subs_sm;
% 
% meta_data_all_subs = meta_data_pic_subs_sm;
% meta_data_all_subs.subs_used = meta_data_pic_subs_sm.subs_pic_used;
% meta_data_all_subs.subjects = subjects;
% 
% meta_data_all_subs = rmfield(meta_data_all_subs,"subs_pic_used");
% 
% meta_data_all_subs.motion_data.subs_used_sum_mag_acc  = meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_acc;  
% meta_data_all_subs.motion_data.subs_used_sum_mag_gyr = meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_gyr;
% meta_data_all_subs.motion_data.subs_used_ntpts = meta_data_pic_subs_sm.motion_data.subs_pic_used_ntpts;
% 
% %meta_data_all_subs = rmfield(meta_data_all_subs.motion_data,"subs_pic_used_sum_mag_acc");
% %meta_data_all_subs = rmfield(meta_data_all_subs.motion_data,"subs_pic_used_sum_mag_gyr");
% %meta_data_all_subs = rmfield(meta_data_all_subs.motion_data,"subs_pic_used_ntpts");

%% This loads the meta data which is generated in the code above, but the code above requires all the subject raw data, so it doesn't need to be ran again
%load the meta data that we have processe
load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\PAPER-figures-210426\meta_data_pic_subs_sm.mat");

total_subs_pic_used_ntpts = sum(meta_data_pic_subs_sm.motion_data.subs_pic_used_ntpts,2);

total_subs_pic_used_sum_mag_gyr = sum(meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_gyr,2);

total_subs_pic_used_sum_mag_acc = sum(meta_data_pic_subs_sm.motion_data.subs_pic_used_sum_mag_acc,2);

total_subs_pic_used_sum_mag_gyr_norm_tpts = total_subs_pic_used_sum_mag_gyr./total_subs_pic_used_ntpts;
total_subs_pic_used_sum_mag_acc_norm_tpts = total_subs_pic_used_sum_mag_acc./total_subs_pic_used_ntpts;

meta_data_pic_subs_sm.motion_data.total_subs_pic_used_ntpts = total_subs_pic_used_ntpts;

meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr = total_subs_pic_used_sum_mag_gyr;
meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc = total_subs_pic_used_sum_mag_acc;

meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr_norm_tpts = total_subs_pic_used_sum_mag_gyr_norm_tpts;
meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc_norm_tpts = total_subs_pic_used_sum_mag_acc_norm_tpts;

[rho(6),pval(6)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_mag_gyr_norm_tpts);
[rho(7),pval(7)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_mag_acc_norm_tpts);

%[rho(8),pval(8)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_abs_gyr_norm_tpts);
%[rho(9),pval(9)] = corr(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_abs_acc_norm_tpts);

[h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(pval)

figure()
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_mag_gyr_norm_tpts,'x')
xlabel("Mean alignment  error (mm)")
ylabel("total subs pic used sum abs gyr norm tpts (AU)")

figure()
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,total_subs_pic_used_sum_mag_acc_norm_tpts,'x')
xlabel("Mean alignment  error (mm)")
ylabel("total_subs_pic_used_sum_abs_acc_norm_tpts")
%% plot correlations seen in paper - use this
title_size = 14;
axis_label_size = 12;

figure()
subplot(2,3,1)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.hc,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Head Circumference (cm)",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Head Circumference (cm)",'FontSize',title_size,'FontName','Times New Roman')

subplot(2,3,2)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.age_acq,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Age at acquisition (days)",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Age at acquisition (days)",'FontSize',title_size,'FontName','Times New Roman')

subplot(2,3,3)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.bw,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Birth weight (gr)",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Birth weight (gr)",'FontSize',title_size,'FontName','Times New Roman')

subplot(2,3,4)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.GA,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Gestational age (days)",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Gestational age (days)",'FontSize',title_size,'FontName','Times New Roman')

subplot(2,3,5)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr_norm_tpts,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Average |\omega| (deg s^{-1})",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Average |\omega| (deg s^{-1})",'FontSize',title_size,'FontName','Times New Roman')

subplot(2,3,6)
plot(avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic,meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc_norm_tpts,'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
xlabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
ylabel("Average |\alpha| (g)",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Average |\alpha| (g)",'FontSize',title_size,'FontName','Times New Roman')

%% sleep state sum
subN_n_active_sleep = [5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	39	40	41	42	43	44	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	64	65	66	67	68	69	70	71	72	73	74	75	76	77	78	79	80	81	82	83	86	87	88	89	90	91	92	93	94	95	96	98	99	100	101	102	103	104	105	106	107	108	109	110	111	112	113	114	115	116	117	118;
9	15	19	10	20	4	15	17	20	18	10	19	12	20	10	19	18	16	4	19	11	5	14	12	19	18	14	15	18	4	11	18	17	15	18	1	20	20	11	13	6	20	20	18	20	2	14	19	14	3	13	18	20	6	20	2	18	1	17	7	20	20	11	7	16	15	14	13	9	12	11	10	14	19	19	13	12	16	20	10	11	11	19	20	16	19	19	9	9	11	7	16	20	10	19	10	9	0	13	11	7	12	12	4	5	8	8	3	16];


for i=1:size(subs_pic_used,1)
    idx_sleep_sub_SN = find(subN_n_active_sleep(1,:)==subs_pic_used(i));
    if size(idx_sleep_sub_SN,2) ==0
        idx_sleep_sub_SN_all(i,1) = -1;
    else
        idx_sleep_sub_SN_all(i,1) = idx_sleep_sub_SN;
    end
end

use_sub = idx_sleep_sub_SN_all>0;

subN_n_active_sleep_SM = subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))';

meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr_norm_tpts;
meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc_norm_tpts;

[rho(1), p(1)] = corr(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr_norm_tpts(use_sub,:));
[rho(2), p(2)] = corr(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc_norm_tpts(use_sub,:));

avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic = mean(euc_dist_model_src_det_stormn_src_det_allsubs_pic,2);

[rho(3), p(3)] = corr(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic(use_sub,:));

title_size = 14;
axis_label_size = 12;

figure()
subplot(1,3,1)
plot(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_gyr_norm_tpts(use_sub,:),'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
ylabel("Average |\omega| (deg s^{-1})",'FontSize',axis_label_size,'FontName','Times New Roman')
xlabel("Sum active sleep",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Average |\omega| (deg s^{-1})",'FontSize',title_size,'FontName','Times New Roman')

subplot(1,3,2)
plot(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',meta_data_pic_subs_sm.motion_data.total_subs_pic_used_sum_mag_acc_norm_tpts(use_sub,:),'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
ylabel("Average |\alpha| (g)",'FontSize',axis_label_size,'FontName','Times New Roman')
xlabel("Sum active sleep",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Average |\alpha| (g)",'FontSize',title_size,'FontName','Times New Roman')

subplot(1,3,3)
plot(subN_n_active_sleep(2,idx_sleep_sub_SN_all(use_sub))',avg_euc_dist_model_src_det_stormn_src_det_allsubs_pic(use_sub,:),'x','Color',[140/255 140/255 255/255],'MarkerSize',8)
ylabel("Mean alignment error (mm)",'FontSize',axis_label_size,'FontName','Times New Roman')
xlabel("Sum active sleep",'FontSize',axis_label_size,'FontName','Times New Roman')
title("Mean alignment error (mm)",'FontSize',title_size,'FontName','Times New Roman')
%% mother holding and displacement
Subject   = [25 95 26 19 28 62 21 92 53 24 73 86 60 14 74 30 36 42 43 13 ...
             88 32 90 58 40 80 12 85 87 77 44 65 98 89 54 23 29 31 41 55 ...
             56 81 63 67 66 33 8 96 39]';

MotherHolding = [0 0 1 0 0 0.5 0 1 0 1 1 0 0 0 0 1 0 0 1 0 ...
                 0 0 0 0 0 0 0 1 0 0 1 1 0.5 0 1 1 0 1 1 1 ...
                 0 0 1 0 1 1 0.5 0 0]';

MeanDisp_mm = [4.3796 4.6312 5.0966 5.5846 5.6867 5.8046 7.0374 7.1855 ...
               7.2549 7.2942 7.5401 7.5991 7.7603 7.9428 8.1050 8.2312 ...
               8.3982 8.4778 8.4832 8.6311 8.8829 9.9051 10.0421 ...
               10.1112 10.9733 11.3017 11.3305 11.5163 11.6345 ...
               11.7558 11.8839 12.0728 12.3854 12.6014 12.7821 ...
               13.3231 13.7831 13.9277 14.0840 14.1668 15.0555 ...
               15.1958 15.3255 16.8202 16.8968 17.0693 17.4698 ...
               18.0520 20.7898]';

% change this!!!!
%for looking at acc or vel use these 2 lines
%MeanDisp_mm = total_subs_pic_used_sum_mag_acc_norm_tpts;
%MeanDisp_mm = total_subs_pic_used_sum_mag_gyr_norm_tpts;

%for sleep state use these 3 lines
%MeanDisp_mm = subN_n_active_sleep_SM;
MotherHolding = MotherHolding(use_sub);
Subject = Subject(use_sub);
MeanDisp_mm = MeanDisp_mm(use_sub);

T = table(Subject, MotherHolding, MeanDisp_mm);

% Extract groups
disp_no   = T.MeanDisp_mm(T.MotherHolding == 0);
disp_half = T.MeanDisp_mm(T.MotherHolding == 0.5);
disp_yes  = T.MeanDisp_mm(T.MotherHolding == 1);

% Combine into cell array (required by daviolinplot)
%Y = {disp_no, disp_half, disp_yes};
Y = {disp_no, disp_yes};

groupNames = {'Mother holding = 0', ...
              %'Mother holding = 0.5', ...
              'Mother holding = 1'};
figure('Color','w','Position',[100 100 800 450])

colors = [
    0.6 0.6 0.6;   % no
    0.2 0.6 0.8    % yes
];

addpath("E:\PadovaPostDoc\daviolinplot")
daviolinplot(Y, ...
    'groups',        groupNames, ...
    'violin',        'full', ...
    'colors',   colors, ...
    'scatter',       1, ...
    'jitter',        1, ...
    'scatteralpha',  0.6, ...
    'box',           1, ...
    'boxwidth',      0.3 ...
     );

%ylabel('Mean probe displacement (mm)')
%title('Mother holding vs probe displacement')
ylabel('Avg Acc magnitude (m/s^2)')
xlabel("Mother holding")
xticklabels({"No holding","Holding"})
title('Mother holding vs Avg Acc magnitude')
set(gca,'FontSize',12,'LineWidth',1.2)
hold on
pairs = [1 2];   % comparisons
pvals = zeros(size(pairs,1),1);

for i = 1:size(pairs,1)
    x = Y{pairs(i,1)};
    y = Y{pairs(i,2)};

    %if nx && ny
        [~,p] = ttest2(x,y);
    %else
        p = ranksum(x,y);
    %end

    pvals(i) = p;
end
% Height settings
ymax = max(cellfun(@max,Y));
yrange = range(cellfun(@max,Y));
y0 = ymax + 0.05*yrange;
dy = 0.07*yrange;

for i = 1:size(pairs,1)
    x1 = pairs(i,1);
    x2 = pairs(i,2);
    y  = y0 + (i-1)*dy;

    % Draw bar
    plot([x1 x1 x2 x2],[y-0.01 y y y-0.01],'k','LineWidth',1.5)

    % Significance stars
    if pvals(i) < 0.001
        stars = '***';
    elseif pvals(i) < 0.01
        stars = '**';
    elseif pvals(i) < 0.05
        stars = '*';
    else
        stars = 'n.s.';
    end

    text(mean([x1 x2]), y+0.01, stars, ...
        'HorizontalAlignment','center', ...
        'FontSize',12, 'FontWeight','bold')
end

%% Mother holding subject yes no violin plot
Y = {disp_no, disp_yes};

groupNames = {'Mother holding = 0', ...
              'Mother holding = 1'};

% ── Adjustable settings ──────────────────────────────────────
fontSize = 14;               % <-- change font size here
fontName = 'Times New Roman';
% ─────────────────────────────────────────────────────────────

figure('Color','w','Position',[100 100 800 450])

colors = [
    140/255 140/255 255/255;   % pastel blue  (no holding)
    1.00 0.71 0.76   % pastel pink  (holding)
];

daviolinplot(Y, ...
    'groups',        groupNames, ...
    'violin',        'full', ...
    'colors',        colors, ...
    'scatter',       1, ...
    'jitter',        1, ...
    'scatteralpha',  0.6, ...
    'box',           1, ...
    'boxwidth',      0.5 ...   % smaller = narrower violins + closer together
     );

ylabel('Average |\alpha| (g)')
xlabel('Mother holding')
xticklabels({"No holding", "Holding"})
title('Mother holding vs Average |\alpha| (g)')

% Apply font and size to axes
set(gca, ...
    'FontSize',  fontSize, ...
    'FontName',  fontName, ...
    'LineWidth', 1.2)

% Tighten x-axis so violins appear closer
xlim([0.3, 2.7])

hold on

pairs  = [1 2];
pvals  = zeros(size(pairs,1),1);

for i = 1:size(pairs,1)
    x = Y{pairs(i,1)};
    y = Y{pairs(i,2)};
    [~,~] = ttest2(x,y);       % kept for reference
    pvals(i) = ranksum(x,y);   % non-parametric test
end

% Significance bar heights
ymax   = max(cellfun(@max, Y));
yrange = range(cellfun(@max, Y));
y0     = ymax + 0.05*yrange;
dy     = 0.07*yrange;

for i = 1:size(pairs,1)
    x1 = pairs(i,1);
    x2 = pairs(i,2);
    yh = y0 + (i-1)*dy;

    % Draw significance bar
    plot([x1 x1 x2 x2], [yh-0.01 yh yh yh-0.01], ...
        'k', 'LineWidth', 1.5)

    % Stars
    if     pvals(i) < 0.001;  stars = '***';
    elseif pvals(i) < 0.01;   stars = '**';
    elseif pvals(i) < 0.05;   stars = '*';
    else;                      stars = 'n.s.';
    end

    text(mean([x1 x2]), yh + 0.01, stars, ...
        'HorizontalAlignment', 'center', ...
        'FontSize',   fontSize, ...
        'FontName',   fontName, ...
        'FontWeight', 'bold')
end

% Apply Times New Roman + font size to ALL text in figure
set(findall(gcf, '-property', 'FontName'), 'FontName', fontName)
set(findall(gcf, '-property', 'FontSize'), 'FontSize', fontSize)

%% Run this to generate results in paper
%45srcs
%60dets

names_of_files = dir;
names_of_files = {names_of_files.name};

n_sensor_files = 0;
for i=1:size(names_of_files,2)
    if length(names_of_files{1,i}) == 62;
        n_sensor_files = n_sensor_files+1;

        name_char = names_of_files{1,i};
        subN_files(i,1) = str2num(name_char(5:7));
    end
end

sub_file_loc = zeros(size(week_GA_subs,1),2);
sub_file_loc(:,1) = 1:1:size(week_GA_subs,1);
%find unqiue subs
for i=1:size(names_of_files,2)
    %name_char = names_of_files{1,i};
    %sub_file_loc(i,1) = str2num(name_char(5:7));
    if size(min(find(subN_files(:,1)== i)),1)>0;
        sub_file_loc(i,2) = min(find(subN_files(:,1)== i));  
        %sub_file_loc(i,2) = 
    end
end

%unique(week_GA_subs(:,1))
n_sensor_files_unique = nnz(sub_file_loc(:,2));
all_sub_stormnet_dothub_reg_src3D   = zeros(45,3,size(sub_file_loc,1));
all_sub_stormnet_dothub_reg_det3D   = zeros(60,3,size(sub_file_loc,1));

for i=1:size(sub_file_loc,1)
    if sub_file_loc(i,2) > 0
        load(names_of_files{sub_file_loc(i,2)});
        all_sub_stormnet_dothub_reg_src3D(:,:,i) = reg_stormnet_coords.sub_stormnet_dothub_reg_src3D;
        all_sub_stormnet_dothub_reg_det3D(:,:,i) = reg_stormnet_coords.sub_stormnet_dothub_reg_det3D;
    end
end

unique_week_GA_subs = unique(week_GA_subs(:,1));

avg_GA_all_sub_stormnet_dothub_reg_src3D = zeros(45,3,nnz(unique_week_GA_subs));
avg_GA_all_sub_stormnet_dothub_reg_det3D = zeros(60,3,nnz(unique_week_GA_subs));

std_GA_all_sub_stormnet_dothub_reg_src3D = zeros(45,3,nnz(unique_week_GA_subs));
std_GA_all_sub_stormnet_dothub_reg_det3D = zeros(60,3,nnz(unique_week_GA_subs));

unique_week_GA_subs = unique_week_GA_subs(find(unique_week_GA_subs>0));

%this means we get the non zero subs, so the mean below is already acting
%on non zeros!
subs_non_zero = mean(mean(all_sub_stormnet_dothub_reg_src3D));
subs_non_zero = find(subs_non_zero>0);

for i=1:size(unique_week_GA_subs,1)
    subs_week_GA_N = find(week_GA_subs(:,1)==unique_week_GA_subs(i));
    subs_week_GA_N = intersect(subs_non_zero,subs_week_GA_N);
    
    avg_GA_all_sub_stormnet_dothub_reg_src3D(:,:,i) = mean(all_sub_stormnet_dothub_reg_src3D(:,:,subs_week_GA_N),3);
    std_GA_all_sub_stormnet_dothub_reg_src3D(:,:,i) = std(all_sub_stormnet_dothub_reg_src3D(:,:,subs_week_GA_N),0,3);

    avg_GA_all_sub_stormnet_dothub_reg_det3D(:,:,i) = mean(all_sub_stormnet_dothub_reg_det3D(:,:,subs_week_GA_N),3);
    std_GA_all_sub_stormnet_dothub_reg_det3D(:,:,i) = std(all_sub_stormnet_dothub_reg_det3D(:,:,subs_week_GA_N),0,3);

end
%% Load template co-ords from mesh models of piccola and grande weeks 37-42
%weekGA_subs_p_G; %col 1 weekGA %col 2 sub N %col 3 pic (1) grande (2)

%load meshes of pic 37-42 GA
mesh37_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-37-735nm.mat");
mesh38_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-38-735nm.mat");
mesh39_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-39-735nm.mat");
mesh40_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-40-735nm.mat");
mesh41_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-41-735nm.mat");
mesh42_pic = load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\mesh_creation_test\mesh-piccola-week-42-735nm.mat");

subs_pic_used = intersect(subs_non_zero,find(weekGA_subs_p_G(:,3)==1));
subs_grande_used = intersect(subs_non_zero,find(weekGA_subs_p_G(:,3)==2));

euc_dist_model_src_stormn_src_allsubs_pic = zeros(size(subs_pic_used,1),size(all_sub_stormnet_dothub_reg_src3D,1));
euc_dist_model_det_stormn_det_allsubs_pic = zeros(size(subs_pic_used,1),size(all_sub_stormnet_dothub_reg_det3D,1));

for i=1:size(subs_pic_used,1)

    %choose right mesh for template
    switch weekGA_subs_p_G(subs_pic_used(i),1)
        case 37
            src_template = mesh37_pic.mesh.source.coord;
            det_template = mesh37_pic.mesh.meas.coord;
        case 38
            src_template = mesh38_pic.mesh.source.coord;
            det_template = mesh38_pic.mesh.meas.coord;
        case 39
            src_template = mesh39_pic.mesh.source.coord;
            det_template = mesh39_pic.mesh.meas.coord;
        case 40
            src_template = mesh40_pic.mesh.source.coord;
            det_template = mesh40_pic.mesh.meas.coord;
        case 41
            src_template = mesh41_pic.mesh.source.coord;
            det_template = mesh41_pic.mesh.meas.coord;
        case 42
            src_template = mesh42_pic.mesh.source.coord;
            det_template = mesh42_pic.mesh.meas.coord;
    end


    euc_dist_model_src_stormn_src_allsubs_pic(i,:) = diag(pdist2(all_sub_stormnet_dothub_reg_src3D(:,:,subs_pic_used(i)),src_template));
    euc_dist_model_det_stormn_det_allsubs_pic(i,:) = diag(pdist2(all_sub_stormnet_dothub_reg_det3D(:,:,subs_pic_used(i)),det_template));

end

mean(euc_dist_model_src_stormn_src_allsubs_pic,2);
mean(euc_dist_model_det_stormn_det_allsubs_pic,2);

euc_dist_model_src_det_stormn_src_det_allsubs_pic = [euc_dist_model_src_stormn_src_allsubs_pic euc_dist_model_det_stormn_det_allsubs_pic];
figure()
histogram(euc_dist_model_src_det_stormn_src_det_allsubs_pic)
xlabel("Euclidean error / mm")
ylabel("Frequency / N")

mean(std(euc_dist_model_src_det_stormn_src_det_allsubs_pic))
mean(mean(euc_dist_model_src_det_stormn_src_det_allsubs_pic))
median(mean(euc_dist_model_src_det_stormn_src_det_allsubs_pic))
max(max(euc_dist_model_src_det_stormn_src_det_allsubs_pic))
min(min(euc_dist_model_src_det_stormn_src_det_allsubs_pic))

mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic = mean([euc_dist_model_src_stormn_src_allsubs_pic euc_dist_model_det_stormn_det_allsubs_pic],2);

mean(mean(mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic))
median(mean(mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic))
max(max(mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic))
min(min(mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic))

figure()
histogram(mean_euc_dist_model_src_det_stormn_src_det_allsubs_pic)
xlabel("Euclidean error / mm")
ylabel("Frequency / N")

euc_dist_model_src_det_stormn_src_det_allsubs_pic;

subs_pic_used(find(mean(euc_dist_model_src_stormn_src_allsubs_pic,2) == max(mean(euc_dist_model_src_stormn_src_allsubs_pic,2)) ) );
%biggest delta is sub39, with a mean src euc delta of 20.56 mm

%Biggest
sub_max_error = subs_pic_used(find(mean(euc_dist_model_src_stormn_src_allsubs_pic,2) == max(mean(euc_dist_model_src_stormn_src_allsubs_pic,2)) ) )

%smallest
sub_min_error = subs_pic_used(find(mean(euc_dist_model_src_stormn_src_allsubs_pic,2) == min(mean(euc_dist_model_src_stormn_src_allsubs_pic,2)) ) )

%median
sub_median_error = subs_pic_used(find(mean(euc_dist_model_src_stormn_src_allsubs_pic,2) == median(mean(euc_dist_model_src_stormn_src_allsubs_pic,2)) ) )

load("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(weekGA_subs_p_G(sub_max_error,1))+"-weeks\AllMeshes_"+num2str(weekGA_subs_p_G(sub_max_error,1))+"weeks.mshs","-mat");

coord_src =all_sub_stormnet_dothub_reg_src3D(:,:,sub_max_error);
coord_det =all_sub_stormnet_dothub_reg_det3D(:,:,sub_max_error);

%% Plot the template co-ords for the case study subjects
save_fig = 0; %if figures get saved, 0 = no, 1 = yes
src_det_size = 16;
line_size = 6;

views_fig = [180 25;90 0;-90 0;0 25; 180 90];

eeg_10_5_lm = ["AFz" "AF3" "AF4" "F7" "F3" "Fz" "F4" "F8" "T7" "C3" "Cz" "C4" "T8" "P3" "Pz" "P4" "P7" "P8"];

%change this to change which of the 3 case study subjects you look at
subN = sub_max_error;
%subN = sub_median_error;
%subN = sub_min_error;

subN_3 = [sub_max_error sub_median_error sub_min_error];

coord_src =all_sub_stormnet_dothub_reg_src3D(:,:,subN);
coord_det =all_sub_stormnet_dothub_reg_det3D(:,:,subN);

load("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(weekGA_subs_p_G(subN,1))+"-weeks\AllMeshes_"+num2str(weekGA_subs_p_G(subN,1))+"weeks.mshs","-mat");

 switch weekGA_subs_p_G(subN,1)
        case 37
            src_template = mesh37_pic.mesh.source.coord;
            det_template = mesh37_pic.mesh.meas.coord;
        case 38
            src_template = mesh38_pic.mesh.source.coord;
            det_template = mesh38_pic.mesh.meas.coord;
        case 39
            src_template = mesh39_pic.mesh.source.coord;
            det_template = mesh39_pic.mesh.meas.coord;
        case 40
            src_template = mesh40_pic.mesh.source.coord;
            det_template = mesh40_pic.mesh.meas.coord;
        case 41
            src_template = mesh41_pic.mesh.source.coord;
            det_template = mesh41_pic.mesh.meas.coord;
        case 42
            src_template = mesh42_pic.mesh.source.coord;
            det_template = mesh42_pic.mesh.meas.coord;
    end
%template src det
for k=1:size(views_fig,1)
 figure()
    plotmesh_iso2(gmSurfaceMesh.node(:,1:3), gmSurfaceMesh.face, ...
        'FaceColor',[151 151 151]/255)
    axis off
    hold on
    plot3(src_template(:,1), ...
        src_template(:,2), ...
        src_template(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0], ...
        'LineStyle','none','Marker','diamond')

    plot3(det_template(:,1), ...
        det_template(:,2), ...
        det_template(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1], ...
        'LineStyle','none','Marker','diamond')
    for i=1:size(eeg_10_5_lm,2)
        plot3(tenFive.positions(find(tenFive.labels == eeg_10_5_lm(i)),1),tenFive.positions(find(tenFive.labels == eeg_10_5_lm(i)),2),tenFive.positions(find(tenFive.labels == eeg_10_5_lm(i)),3),'o','Color', [1 0.5 0],'MarkerSize',src_det_size+6,'LineWidth',2,'MarkerFaceColor',[1 0.5 0])
    end

    view([views_fig(k,:)])
    set(gcf, 'Position', get(0, 'Screensize'));
    if save_fig == 1;
        saveas(gcf,"tem_probe_eegLM_sub"+num2str(subN)+"_weekGA_"+num2str(weekGA_subs_p_G(subN,1))+"_view_"+num2str(views_fig(k,:))+".png")
    end
end
%% Plotting the registered src det with displacement lines
for k=1:size(views_fig,1)

    figure()
    plotmesh_iso2(gmSurfaceMesh.node(:,1:3), gmSurfaceMesh.face, ...
        'FaceColor',[151 151 151]/255)
    axis off
    hold on

    % --- Plot sources and detectors (original points) ---
    plot3(coord_src(:,1), coord_src(:,2), coord_src(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[1 0 1],'MarkerFaceColor',[1 0 1], ...
        'LineStyle','none','Marker','o')

    plot3(coord_det(:,1), coord_det(:,2), coord_det(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[1 0 1],'MarkerFaceColor',[1 0 1], ...
        'LineStyle','none','Marker','o')

    plot3(src_template(:,1), ...
        src_template(:,2), ...
        src_template(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[0 1 1],'MarkerFaceColor',[0 1 1], ...
        'LineStyle','none','Marker','diamond')

    plot3(det_template(:,1), ...
        det_template(:,2), ...
        det_template(:,3), ...
        'MarkerSize',src_det_size,'MarkerEdgeColor',[0 1 1],'MarkerFaceColor',[0 1 1], ...
        'LineStyle','none','Marker','diamond')

   

    % Compute distances for sources
    srcA = coord_src;
    srcB = src_template;

    nSrc = min(size(srcA,1), size(srcB,1));
    srcDist = vecnorm(srcA(1:nSrc,:) - srcB(1:nSrc,:), 2, 2);

    % Normalize distances to [0,1]
    srcDistNorm = (srcDist - min(srcDist)) / (max(srcDist) - min(srcDist) + eps);

    % Choose colormap
    %cmap = parula(256);
    load("E:\PadovaPostDoc\slanCM\slanCM_Data.mat")
    cmap = slandarerCM(1).Colors{1, 2} ; %plasma


    for i = 1:nSrc
        cIdx = max(1, round(srcDistNorm(i) * 255) + 1);
        plot3([srcA(i,1), srcB(i,1)], ...
            [srcA(i,2), srcB(i,2)], ...
            [srcA(i,3), srcB(i,3)], ...
            'Color', cmap(cIdx,:), 'LineWidth', line_size)
    end


    % Compute distances for detectors
    detA = coord_det;
    detB = det_template;

    nDet = min(size(detA,1), size(detB,1));
    detDist = vecnorm(detA(1:nDet,:) - detB(1:nDet,:), 2, 2);

    % Normalize distances to [0,1]
    detDistNorm = (detDist - min(detDist)) / (max(detDist) - min(detDist) + eps);

    for i = 1:nDet
        cIdx = max(1, round(detDistNorm(i) * 255) + 1);
        plot3([detA(i,1), detB(i,1)], ...
            [detA(i,2), detB(i,2)], ...
            [detA(i,3), detB(i,3)], ...
            'Color', cmap(cIdx,:), 'LineWidth', line_size)
    end


    axis equal
    colormap(cmap)
    cb = colorbar;
    cb.Label.String = 'Source / Detector displacement (mm)';
    clim([0 max([srcDist ;detDist])])


    % ---- Make colorbar larger (manual positioning) ----
    cb.Position = [0.88 0.15 0.03 0.7];   % [left bottom width height]

    % ---- Control tick label font size ----
    cb.FontSize = 14;                    % tick label size

    % ---- Optional: label formatting ----
    cb.Label.String = 'Displacement (mm)';
    cb.Label.FontSize = 16;
    cb.Label.FontWeight = 'bold';
    view([views_fig(k,:)])
    set(gcf, 'Position', get(0, 'Screensize'));
    if save_fig == 1;
        saveas(gcf,"sm_tem_probe_displ_sub"+num2str(subN)+"_weekGA_"+num2str(weekGA_subs_p_G(subN,1))+"_view_"+num2str(views_fig(k,:))+".png")
    end
end

%histo of dist stats
probeDist = [detDist;srcDist];
%% paper code violin plots figure 3
addpath("E:\PadovaPostDoc\daviolinplot");

sub_min_error=25;
sub_median_error=40;
sub_max_error=39;

probeDist_subj1 =euc_dist_model_src_det_stormn_src_det_allsubs_pic(find(subs_pic_used == sub_min_error),:);
probeDist_subj2=euc_dist_model_src_det_stormn_src_det_allsubs_pic(find(subs_pic_used == sub_median_error),:);
probeDist_subj3=euc_dist_model_src_det_stormn_src_det_allsubs_pic(find(subs_pic_used == sub_max_error),:);
probeDist_cohort=mean(euc_dist_model_src_det_stormn_src_det_allsubs_pic,1);
probeDist_cohort_all=euc_dist_model_src_det_stormn_src_det_allsubs_pic;



% Combine data into a single vector
Y = [
    probeDist_subj1(:);
    probeDist_subj2(:);
    probeDist_subj3(:);
    probeDist_cohort(:)
];

data_123_allcohort = {
    probeDist_subj1(:), ...
    probeDist_subj2(:), ...
    probeDist_subj3(:), ...
    probeDist_cohort_all(:)   % 49*105
    };

quartiles_1 = prctile(data_123_allcohort{1, 1}  , [25, 50, 75]);
quartiles_2 = prctile(data_123_allcohort{1, 2}  , [25, 50, 75]);
quartiles_3 = prctile(data_123_allcohort{1, 3}  , [25, 50, 75]);
quartiles_all = prctile(data_123_allcohort{1, 4}  , [25, 50, 75]);


% Grouping variable (one group per subject/cohort)
groups = [
    ones(numel(probeDist_subj1),1);
    2*ones(numel(probeDist_subj2),1);
    3*ones(numel(probeDist_subj3),1);
    4*ones(numel(probeDist_cohort),1)
];

% Colors for the four groups
colors = [
    255/255 139/255 0/255;   % Subject 1
    32/255 102/255 187/255;   % Subject 2
    255/255 215/255 235/255;   % Subject 3
    255/255 162/255 220/255    % Cohort
];

%ttest
data = {
    probeDist_subj1(:)
    probeDist_subj2(:)
    probeDist_subj3(:)
};

groupNames = {'Subject 1','Subject 2','Subject 3'};
nGroups = numel(data);

pvals = nan(nGroups);

for i = 1:nGroups
    for j = i+1:nGroups
        [~,p] = ttest(data{i}, data{j});  % PAIRED t-test
        pvals(i,j) = p;
    end
end

% Bonferroni correction
pvals_corr = pvals * nchoosek(nGroups,2);
pvals_corr(pvals_corr > 1) = 1;

sigStar = @(p) ...
    ternary(p < 0.001,'***', ...
    ternary(p < 0.01,'**', ...
    ternary(p < 0.05,'*','')));


figure; hold on

%first input was Y
h = daviolinplot(data_123_allcohort, ...
    'groups', groups, ...
    'violin', 'half', ...
    'colors', colors, ...
    'violinalpha', 0.7, ...
    'violinwidth', 1.2, ...
    'box', 2, ...                 % centered box
    'boxcolors', 'k', ...
    'boxalpha', 0.8, ...
    'scatter', 2, ...             % centered scatter
    'jitter', 1, ...
    'scattersize', 18, ...
    'scatteralpha', 0.6, ...
    'outliers', 1, ...
    'xtlabels', {'Best Case','Median Case','Worst Case','All'});

xlabel('Group')
ylabel('Probe displacement (mm)')
title('Euc dist tmp vs sn')

ylim([0 round(max(Y))+2]);

set(gca,'FontSize',16)
box off

%testsig stars
yl = ylim;
yBase = yl(2);
yStep = 0.05 * range(yl);

barCount = 0;
hold on

for i = 1:nGroups
    for j = i+1:nGroups

        p = pvals_corr(i,j);
        star = sigStar(p);

        if ~isempty(star)
            barCount = barCount + 1;
            y = yBase + barCount*yStep;

            % Horizontal bar
            plot([i j], [y y], 'k', 'LineWidth', 1.5)

            % Vertical ticks
            plot([i i], [y-yStep*0.25 y], 'k', 'LineWidth', 1.5)
            plot([j j], [y-yStep*0.25 y], 'k', 'LineWidth', 1.5)

            % Stars
            text(mean([i j]), y + yStep*0.1, star, ...
                'HorizontalAlignment','center', ...
                'FontSize',14,'FontWeight','bold')
        end
    end
end

ylim([yl(1), yBase + (barCount+2)*yStep])
%% load 4d infants models unique_week_GA_subs

for i=1:size(unique_week_GA_subs,1)
    load("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(unique_week_GA_subs(i))+"-weeks\AllMeshes_"+num2str(unique_week_GA_subs(i))+"weeks.mshs","-mat");

    subs_week_GA_N = find(week_GA_subs(:,1)==unique_week_GA_subs(i));
    subs_week_GA_N = intersect(subs_non_zero,subs_week_GA_N);

   
    figure()
    plotmesh_iso2(gmSurfaceMesh.node(:,1:3),gmSurfaceMesh.face,'FaceColor',[151 151 151]/255)
    hold on;
    plot3(avg_GA_all_sub_stormnet_dothub_reg_src3D(:,1,i),avg_GA_all_sub_stormnet_dothub_reg_src3D(:,2,i),avg_GA_all_sub_stormnet_dothub_reg_src3D(:,3,i),'.r','MarkerSize',20)
    %hold on
    plot3(avg_GA_all_sub_stormnet_dothub_reg_det3D(:,1,i),avg_GA_all_sub_stormnet_dothub_reg_det3D(:,2,i),avg_GA_all_sub_stormnet_dothub_reg_det3D(:,3,i),'.b','MarkerSize',20)
    title("4D model week "+num2str(unique_week_GA_subs(i))+" mesh with avg storm net co-ords")


    figure()
    plotmesh_iso2(gmSurfaceMesh.node(:,1:3),gmSurfaceMesh.face,'FaceColor',[151 151 151]/255)
    hold on;
    bubblechart3(avg_GA_all_sub_stormnet_dothub_reg_src3D(:,1,i),avg_GA_all_sub_stormnet_dothub_reg_src3D(:,2,i),avg_GA_all_sub_stormnet_dothub_reg_src3D(:,3,i),mean(std_GA_all_sub_stormnet_dothub_reg_src3D(:,:,i),2),'red')
    bubblechart3(avg_GA_all_sub_stormnet_dothub_reg_det3D(:,1,i),avg_GA_all_sub_stormnet_dothub_reg_det3D(:,2,i),avg_GA_all_sub_stormnet_dothub_reg_det3D(:,3,i),mean(std_GA_all_sub_stormnet_dothub_reg_det3D(:,:,i),2),'blue')
    title("4D model week "+num2str(unique_week_GA_subs(i))+" mesh with avg + std storm net co-ords N = "+size(subs_week_GA_N,1)+"")

end
%% The code for doing the HD-DOT
% DOT HBX
% HbO paper analysis 
% load correct mesh/jacobian
subjects = {...
    '001pv130', 1;...
    '002et131', 1;...
    '003ep132', 1;...
    '004ma133', 1;...
    '005cm134', 1;...
    '006rk135', 1;...
    '007es136', 1;...
    '008rv137', 1;...
    '009ym138', 1;...
    '010gb139', 1;...
    '011vz140', 1;...
    '012eb150', 1;...
    '013nm151', 1;...
    '014nb152', 1;...
    '015ms153', 1;...
    '016lg154', 1;...
    '017gb155', 1;...
    '018mp156', 1;...
    '019lr157', 1;...
    '020pb158', 1;...
    '021zn159', 1;...
    '022sc160', 1;...
    '023ev161', 1;...
    '024ac162', 1;...
    '025mc163', 1;...
    '026cu164', 1;...
    '027lt165', 1;...
    '028ml166', 1;...
    '029ym167', 2;...  # 2 file use the second
    '030am168', 1;...
    '031cm169', 1;...
    '032gf170', 1;...
    '033cn171', 1;...
    '034lb172', 1;...
    '035gc173', 1;...
    '036fv174', 1;...
    '037bt175', 1;...
    '038ge176', 1;...
    '039bm177', 1;...
    '040in178', 1;...
    '041mm179', 1;...
    '042ar180', 1;...
    '043gg181', 1;...
    '044gl202', 1;...
    '045mt203', 1;...
    '046gf204', 1;...
    '047rm205', 1;...
    '048dn206', 1;...  # 2 files use the first
    '049db207', 1;...
    '050cp208', 0;...  # 2 file check which one to use the experiment seems divided in different recordings
    '051dp209', 1;...
    '052ez210', 1;...
    '053pr211', 1;...
    '054mv212', 1;...
    '055bm213', 1;...
    '056mf214', 1;...
    '057gc215', 1;...
    '058ad216', 1;...
    '059nh217', 1;...
    '060ar218', 1;...
    '061eo219', 2;...  # 2 file use the second
    '062ac220', 1;...
    '063el221', 1;...
    '064lz331', 1;...
    '065zm332', 1;...
    '066ef333', 1;...  # 2 files use the first
    '067ec334', 1;...
    '068cp335', 1;...
    '069lm336', 1;...
    '070rm337', 1;...
    '071gc338', 1;...
    '072af339', 1;...
    '073lf340', 1;...
    '074vp341', 0;...  # 2 file both with only 3 blocks
    '075sb342', 1;...
    '076lm343', 2;...  # 3 files use the second
    '077ro344', 1;...
    '078ga345', 1;...
    '079tf346', 1;...
    '080rc348', 1;...
    '081nb349', 1;...
    '082nz347', 0;...  # 5 files check better which one to use the experiment seems divided in different recordings
    '083gv350', 1;...
    '084vb351', 0;...  # no first word
    '085ed352', 1;...
    '086gg369', 1;...
    '087mw370', 0;... %no data
    '088sl371', 1;...
    '089bs372', 0;... %split into 6 runs
    '090md373', 0;... %no data
    '091si374', 1;...
    '092nb375', 1;...
    '093ah376', 1;...
    '094er377', 1;...
    '095gb378', 1;...
    '096rf379', 1;...
    '097mc401', 0;... %not full data°
    '098em402', 1;...
    '099rc409', 1;... %new added 02 10 25

    '100as500',1;... %added subs new 22 10 25
    '101vd501',1;...
    '102ab502',1;...
    '103cz503',1;...
    '104ag504',1;...
    '105sm505',1;...
    '106bl506',1;...
    '107lz507',1;...
    '108ca508',1;...
    '109aa509',1;...
    '110rf510',1;...

    '111am511',1;... %added new subs 18 11 25
    '112cm512',1;...
    '113gt513',1;...
    '114mc514',1;...
    '115mc515',1;...
    '116cc516',1;...
    '117dg517',1;...
    '118mz518',1;
    };

% name of the task
task = 'remind';

% session
session = '01';

% figures file format
figformat = 'png';
load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\DATA_noSSR_sub25_39_40");
%%
subN = 40;
save_HbX = 0; %0 = dont save, 1 = save
use_SM = 1; %always keep as 1
stormnet_study = 1; %always keep as 1

%info on data!
%-5 20, -5to0 baseline
%no ssr
%sub 25 block 9 B %best
%sub39 block 9 B %worst
%sub40 block 1 A %median

if stormnet_study == 1
    switch subN
        case 25
            blockN = 9;
            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\sub25_redo_stormnetpaper_210126\HbX-025mc163-week-37-735nm_template-co-ords_Block_9_stim_B");
            tmpHbX = HbX_gmsurface;

            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\sub25_redo_stormnetpaper_210126\HbX-025mc163-week-37-735nm_stormnet-co-ords_Block_9_stim_B");
            snHbX = HbX_gmsurface;
        case 39
            blockN = 9;
            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\HbX-039bm177-week-41-735nm_template-co-ords_Block_9_stim_B");
            tmpHbX = HbX_gmsurface;

            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\HbX-039bm177-week-41-735nm_stormnet-co-ords_Block_9_stim_B");
            snHbX = HbX_gmsurface;
        case 40
            blockN = 1;
            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\HbX-040in178-week-38-735nm_template-co-ords_Block_1_stim_A");
            tmpHbX = HbX_gmsurface;

            load("E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Probe_Registration_HDDOT_newborn_study\HbX_data\HbX-040in178-week-38-735nm_stormnet-co-ords_Block_1_stim_A");
            snHbX = HbX_gmsurface;
    end
end

cond_name = ["A" "B"];

Ylhs_wvl1_2 = DATA(subN).dod_trl{blockN, 1};
%use SSR, commented out so no ssr is used
%Ylhs_wvl1_2 = DATA(subN).dod_trl_SSR{blockN, 1};

Ylhs_wv1 = Ylhs_wvl1_2(:,1:end/2);
Ylhs_wv2 = Ylhs_wvl1_2(:,end/2 +1:end);

subN_weekGA_subs_p_G = DATA(subN).weekGA_subs_p_G;

cap_size = [];

if subN_weekGA_subs_p_G(1,3) == 1
    cap_size = "piccola";
else
    cap_size = "grande";
end

load("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(subN_weekGA_subs_p_G(1,1))+"-weeks\AllMeshes_"+num2str(subN_weekGA_subs_p_G(1,1))+"weeks.mshs","-mat");
%% plot 
%views_fig = [180 25;90 0;-90 0;0 25; 180 90];
views_fig = [180 25];
k=1;

save_fig=0;
time_pts = 8; %use this for all subs 25 39 40

meshedgealpha = 0.1;
meshFaceAlpha = 0.5;
cluster_mark_size = 14;

HbO_A = tmpHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)));
HbO_B = snHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)));
HbO_C = HbO_A-HbO_B;

max_hbo = max([max(abs(  [HbO_A HbO_B HbO_C]))]);
max_hbo_AB = max([max(abs(  [HbO_A HbO_B]))]);

figure()
plotmesh_iso2([gmSurfaceMesh.node tmpHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)))],gmSurfaceMesh.face,'EdgeAlpha', meshedgealpha)
view(views_fig(1,:)); %TOP VIEW % used for infant week 30
axis off
clim([-max_hbo_AB max_hbo_AB])
colorbar('southoutside') % Places horizontal colorbar below the plot

figure()
t = tiledlayout(1, 3, 'TileSpacing', 'none', 'Padding', 'none'); 
subplot(1,3,1)
plotmesh_iso2([gmSurfaceMesh.node tmpHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)))],gmSurfaceMesh.face,'EdgeAlpha', meshedgealpha)
view(views_fig); %TOP VIEW % used for infant week 30
axis off
clim([-max_hbo max_hbo])

subplot(1,3,2)
plotmesh_iso2([gmSurfaceMesh.node snHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)))],gmSurfaceMesh.face,'EdgeAlpha', meshedgealpha)
view(views_fig); %TOP VIEW % used for infant week 30
axis off
clim([-max_hbo max_hbo])

subplot(1,3,3)
plotmesh_iso2([gmSurfaceMesh.node tmpHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)))-snHbX.HbO_lhs_gmsurface(:,find(DATA(subN).time==time_pts(1)))],gmSurfaceMesh.face,'EdgeAlpha', meshedgealpha)
view(views_fig); %TOP VIEW % used for infant week 30
axis off
clim([-max_hbo max_hbo])
set(gcf, 'Position', get(0, 'Screensize'));
    if save_fig == 1;
        saveas(gcf,"plain_tm_sm_delta_HbO_"+num2str(subN)+"_weekGA_"+num2str(subN_weekGA_subs_p_G(1,2))+"_view_"+num2str(views_fig(k,:))+"_block_"+num2str(blockN)+".png")
    end
%%
nodes = gmSurfaceMesh.node(:,1:3);
faces = gmSurfaceMesh.face;
N = size(nodes,1);

thr = 0.5 * max([abs(HbO_A); abs(HbO_B)]);

thr_pos = 0.5 * max([(HbO_A); (HbO_B)]);
thr_neg = abs(0.5 * min([(HbO_A); (HbO_B)]));

maskA_pos = HbO_A >  thr_pos;
maskA_neg = HbO_A < -thr_neg;

maskB_pos = HbO_B >  thr_pos;
maskB_neg = HbO_B < -thr_neg;


A = sparse(N,N);
for f = 1:size(faces,1)
    v = faces(f,:);
    A(v(1),v(2)) = 1;
    A(v(2),v(3)) = 1;
    A(v(3),v(1)) = 1;
end
A = A | A';

clustersA_pos = extract_clusters(maskA_pos, HbO_A, A, nodes);
clustersA_neg = extract_clusters(maskA_neg, HbO_A, A, nodes);

clustersB_pos = extract_clusters(maskB_pos, HbO_B, A, nodes);
clustersB_neg = extract_clusters(maskB_neg, HbO_B, A, nodes);

%get pos and neg clusters
Dmax = 35;  % mm (max ish for cap misalignment)

matches = [];
matches_neg = [];

%positive clusters part 1
for i = 1:numel(clustersA_pos)
    for j = 1:numel(clustersB_pos)

        d = norm(clustersA_pos(i).centroid - clustersB_pos(j).centroid);
        amp_ratio = abs(clustersA_pos(i).meanHbO / clustersB_pos(j).meanHbO);

        if d < Dmax && amp_ratio > 0.5 && amp_ratio < 2
            matches = [matches; i j d];
        end
    end
end
%positive clusters part 2
for k = 1:size(matches,1)
    i = matches(k,1);
    j = matches(k,2);

    disp_vec = clustersB_pos(j).centroid - clustersA_pos(i).centroid;

    cluster_motion(k).A = i;
    cluster_motion(k).B = j;
    cluster_motion(k).displacement_mm = norm(disp_vec);
    cluster_motion(k).direction = disp_vec;
end
%positive clusters part 3
for k = 1:size(matches,1)
    A_nodes = clustersA_pos(matches(k,1)).nodes;
    B_nodes = clustersB_pos(matches(k,2)).nodes;

    dice = 2*numel(intersect(A_nodes,B_nodes)) / ...
           (numel(A_nodes)+numel(B_nodes));

    cluster_motion(k).dice = dice;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% negative clusters below
%negative clusters part 1
for i = 1:numel(clustersA_neg)
    for j = 1:numel(clustersB_neg)

        d_neg = norm(clustersA_neg(i).centroid - clustersB_neg(j).centroid);
        amp_ratio_neg = abs(clustersA_neg(i).meanHbO / clustersB_neg(j).meanHbO);

        if d_neg < Dmax && amp_ratio_neg > 0.5 && amp_ratio_neg < 2
            matches_neg = [matches_neg; i j d];
        end
    end
end
%negative clusters part 2
for k = 1:size(matches_neg,1)
    i = matches_neg(k,1);
    j = matches_neg(k,2);

    disp_vec_neg = clustersB_neg(j).centroid - clustersA_neg(i).centroid;

    cluster_motion_neg(k).A = i;
    cluster_motion_neg(k).B = j;
    cluster_motion_neg(k).displacement_mm = norm(disp_vec_neg);
    cluster_motion_neg(k).direction = disp_vec_neg;
end
%negative clusters part 3
for k = 1:size(matches_neg,1)
    A_nodes_neg = clustersA_neg(matches_neg(k,1)).nodes;
    B_nodes_neg = clustersB_neg(matches_neg(k,2)).nodes;

    dice_neg = 2*numel(intersect(A_nodes_neg,B_nodes_neg)) / ...
           (numel(A_nodes_neg)+numel(B_nodes_neg));

    cluster_motion_neg(k).dice = dice_neg;
end

%% plot figures below
%for plotting, manually only keep clusters we want to show on the graph,
%since many many clusters are found and we just want to show the key ones
%are shown in the paper!
%see ppt on laptop for this 'stormnet paper figures'

subN
switch subN
    case 25
        %sub39:
        %Pos clusters of interest:C1 (left periph)C2 (frontal left)C5 (front ceontral)C7 (right central)
        %Neg clusters of interest:C1 (top frontal)C4 (top frontal)C5 (back)
        cluster_motion_plot = [cluster_motion(1);cluster_motion(6);cluster_motion(12);cluster_motion(28);cluster_motion(32);cluster_motion(38);cluster_motion(43);cluster_motion(48);];
        cluster_motion_neg_plot = [cluster_motion_neg(5);cluster_motion_neg(8);cluster_motion_neg(9);cluster_motion_neg(12)];


    case 39
        %sub39:
        %Pos clusters of interest:C1 (left periph)C2 (frontal left)C5 (front ceontral)C7 (right central)
        %Neg clusters of interest:C1 (top frontal)C4 (top frontal)C5 (back)
        cluster_motion_plot = [cluster_motion(1); cluster_motion(5);cluster_motion(8);cluster_motion(17);cluster_motion(22);cluster_motion(28);cluster_motion(34);];
        cluster_motion_neg_plot = [cluster_motion_neg(1);cluster_motion_neg(5);cluster_motion_neg(10);];


    case 40
        %sub40:
        %Pos clusters of interest:C1 (left periph)C2 (frontal left)C5 (front ceontral)C7 (right central)
        %Neg clusters of interest:C1 (top frontal)C4 (top frontal)C5 (back)
        %cluster_motion_plot = [cluster_motion];
        %cluster_motion_neg_plot = [cluster_motion_neg];

        cluster_motion_plot = [cluster_motion(1);cluster_motion(2);cluster_motion(6);cluster_motion(12)]; %12 was 24
        cluster_motion_neg_plot = [cluster_motion_neg(1);cluster_motion_neg(4);cluster_motion_neg(5);cluster_motion_neg(8)];
        %cluster_motion_plot = [cluster_motion(1);cluster_motion(2);cluster_motion(5);cluster_motion(7)];
        %cluster_motion_neg_plot = [cluster_motion_neg(1);cluster_motion_neg(4);cluster_motion_neg(5)];
end
%% check what all clusters look like!
figv=1;

    figure()
    plotmesh_iso2([nodes HbO_A],faces,'EdgeAlpha', meshedgealpha,'FaceAlpha', meshFaceAlpha)
    view(views_fig(figv,:)); %TOP VIEW % used for infant week 30
    axis off
    hold on
    for k = 1:numel(cluster_motion_plot)
        cA = clustersA_pos(cluster_motion_plot(k).A).centroid;
        cB = clustersB_pos(cluster_motion_plot(k).B).centroid;
        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        quiver3(cA(1),cA(2),cA(3), ...
            cB(1)-cA(1),cB(2)-cA(2),cB(3)-cA(3), ...
            0,'k','LineWidth',2)
        % --- Cluster label (placed halfway along arrow) ---
        midpt = (cA + cB) / 2;
        text(midpt(1), midpt(2), midpt(3), ...
           sprintf('C%d', k), ...
           'Color','k', ...
           'FontSize',10, ...
           'FontWeight','bold', ...
           'BackgroundColor','w', ...
           'Margin',1)
    end
    for k = 1:numel(cluster_motion_neg_plot)
        cA = clustersA_neg(cluster_motion_neg_plot(k).A).centroid;
        cB = clustersB_neg(cluster_motion_neg_plot(k).B).centroid;
        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        quiver3(cA(1),cA(2),cA(3), ...
            cB(1)-cA(1),cB(2)-cA(2),cB(3)-cA(3), ...
            0,'k','LineWidth',2)
        % --- Cluster label (placed halfway along arrow) ---
        midpt = (cA + cB) / 2;
        text(midpt(1), midpt(2), midpt(3), ... %sprintf('C%d', k), ...
           sprintf('C%d', k), ...
           'Color','k', ...
           'FontSize',8, ...
           'FontWeight','bold', ...
           'BackgroundColor','w', ...
           'Margin',1)
    end
    %axis off equal
    set(gcf, 'Position', get(0, 'Screensize'));
    if save_fig == 1;
        saveas(gcf,"tm_sm_delta_HbO_"+num2str(subN)+"_weekGA_"+num2str(subN_weekGA_subs_p_G(1,1))+"_view_"+num2str(views_fig(figv,:))+"_block_"+num2str(blockN)+".png")
    end


%% figs for paper clusters pos neg views all
max_hbo_AB = max([max(abs(  [HbO_A HbO_B]))]);

views_fig = [180 25;90 0;-90 0;0 25; 180 90];
%views_fig = [180 25];
figv=1;

cluster_mark_size = 14;
meshFaceAlpha = 0.75;

save_fig=0;
%positive clusters
for figv=1:size(views_fig,1)

    figure()
    subplot(1,3,1)
    plotmesh_iso2([nodes HbO_A],faces,'EdgeAlpha', meshedgealpha)
    clim([-max_hbo_AB max_hbo_AB]);
    hold on
    view(views_fig(figv,:)); %TOP VIEW % used for infant week 30
    for k = 1:numel(cluster_motion_plot)
        cA = clustersA_pos(cluster_motion_plot(k).A).centroid;
        cB = clustersB_pos(cluster_motion_plot(k).B).centroid;

        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        %plot3(cB(1),cB(2),cB(3),'co','MarkerFaceColor','b','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
    end
    for k = 1:numel(cluster_motion_neg_plot)
        cA = clustersA_neg(cluster_motion_neg_plot(k).A).centroid;
        cB = clustersB_neg(cluster_motion_neg_plot(k).B).centroid;

        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        %plot3(cB(1),cB(2),cB(3),'co','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
    end
    axis off
    subplot(1,3,2)
    plotmesh_iso2([nodes HbO_B],faces,'EdgeAlpha', meshedgealpha)
    clim([-max_hbo_AB max_hbo_AB]);
    hold on
    view(views_fig(figv,:)); %TOP VIEW % used for infant week 30
    axis off
    for k = 1:numel(cluster_motion_plot)
        cA = clustersA_pos(cluster_motion_plot(k).A).centroid;
        cB = clustersB_pos(cluster_motion_plot(k).B).centroid;

        %plot3(cA(1),cA(2),cA(3),'ro','MarkerFaceColor','r','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
    end
    for k = 1:numel(cluster_motion_neg_plot)
        cA = clustersA_neg(cluster_motion_neg_plot(k).A).centroid;
        cB = clustersB_neg(cluster_motion_neg_plot(k).B).centroid;

        %plot3(cA(1),cA(2),cA(3),'mo','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
    end
    subplot(1,3,3)
    plotmesh_iso2([nodes HbO_A],faces,'EdgeAlpha', meshedgealpha,'FaceAlpha', meshFaceAlpha)
    clim([-max_hbo_AB max_hbo_AB]);
    view(views_fig(figv,:)); %TOP VIEW % used for infant week 30
    axis off
    hold on
    for k = 1:numel(cluster_motion_plot)
        cA = clustersA_pos(cluster_motion_plot(k).A).centroid;
        cB = clustersB_pos(cluster_motion_plot(k).B).centroid;

        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')

        quiver3(cA(1),cA(2),cA(3), ...
            cB(1)-cA(1),cB(2)-cA(2),cB(3)-cA(3), ...
            0,'k','LineWidth',2)

        % --- Cluster label (placed halfway along arrow) ---
        midpt = (cA + cB) / 2;

        

    end
    for k = 1:numel(cluster_motion_neg_plot)
        cA = clustersA_neg(cluster_motion_neg_plot(k).A).centroid;
        cB = clustersB_neg(cluster_motion_neg_plot(k).B).centroid;

        plot3(cA(1),cA(2),cA(3),'diamond','MarkerFaceColor','c','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')
        plot3(cB(1),cB(2),cB(3),'o','MarkerFaceColor','m','MarkerSize',cluster_mark_size,'MarkerEdgeColor','k')

        quiver3(cA(1),cA(2),cA(3), ...
            cB(1)-cA(1),cB(2)-cA(2),cB(3)-cA(3), ...
            0,'k','LineWidth',2)
        % --- Cluster label (placed halfway along arrow) ---
        midpt = (cA + cB) / 2;

      
    end

    %axis off equal
    set(gcf, 'Position', get(0, 'Screensize'));
    if save_fig == 1;
        saveas(gcf,"tm_sm_delta_HbO_"+num2str(subN)+"_weekGA_"+num2str(subN_weekGA_subs_p_G(1,1))+"_view_"+num2str(views_fig(figv,:))+"_block_"+num2str(blockN)+".png")
    end

end

T = struct2table(cluster_motion_plot) %post clusters
T_neg = struct2table(cluster_motion_neg_plot) %neg clusters

%% functions

function clusters = extract_clusters(mask, HbO, A, nodes)

idx = find(mask);
G = graph(A(idx,idx));
bins = conncomp(G);
nC = max(bins);

clusters = struct;

for c = 1:nC
    ni = idx(bins==c);
    xyz = nodes(ni,:);
    vals = HbO(ni);

    clusters(c).nodes = ni;
    clusters(c).centroid = mean(xyz,1);
    clusters(c).meanHbO = mean(vals);
    clusters(c).peakHbO = max(abs(vals));
    clusters(c).extent = max(vecnorm(xyz - mean(xyz,1),2,2));
end
end


function out = ternary(cond,a,b)
if cond, out = a; else, out = b; end
end