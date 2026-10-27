%% Load dirs

clear, close all
restoredefaultpath
clc


dir_func = 'E:\PadovaPostDoc\Sleeping_Memory_NewBorns\Code\functions'
% Add the paths
addpath(genpath(dir_func))

%iso2mesh
dir_iso2mesh = 'E:\PadovaPostDoc\iso2mesh-master'
% Add the paths
addpath(genpath(dir_iso2mesh))

% Homer3
% Path to the Homer folder
%dir_homer = 'C:\Users\anafl\Documents\MATLAB\Homer3-1.80.2';
dir_homer = 'E:\PadovaPostDoc\homer3-1.80.2';

% Add Homer3
current_path = pwd;
cd(dir_homer)
setpaths
cd(current_path)

%% Subject index 

%thesubject = 'sub-063el221';
%thesubject = 'sub-040in178';

subjects_idx = [1:1:118]';
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
    '092nb375', ... %added 25 05 25 
    '093ah376', ...
    '094er377', ...
    '095gb378', ...
    '096rf379', ...
    '097mc401', ... %not full data°
    '098em402', ...
    '099rc409',... %doing these from 06 03 26
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

    % figures file format
    figformat = 'png';


    %load snirf from
    dir_data_bids = 'D:\RE-MIND\DATA-RE-MIND\DATA-bids';
%%
for i=116 %:size(subjects,2) %was 1:size subjects,2
    clearvars snirf subject_week_idx
    %thesubject = 'sub-055bm213';
    %thesubject = 'sub-040in178';
    
    thesubject = subjects{i}
    subjectN = str2num(thesubject(1:3));

    foldername = fullfile('D:\RE-MIND\DATA-RE-MIND\DATA-original',['sub-' thesubject],'sensors');
    filename = sprintf('%s_layout_mni.txt',['sub-' thesubject]);
    
    %check if the mni txt file exists for the subject
    if exist(fullfile(foldername,filename)) > 0

        %if the updated stormnet file is there, skip subject
        isbj = subjectN;
        thesubject = subjects{isbj};
        
        % bids input folder
        bids_folder = fullfile(dir_data_bids, ['sub-' thesubject], ['ses-' session], 'nirs');
        % files
        fff_snirf_all = dir(fullfile(bids_folder,'*_nirs.snirf'));
        irun=1
        % output folder
        output_folder = fullfile(dir_data_bids, ['sub-' thesubject], ['ses-' session], 'nirs');
        ifile = sprintf('sub-%s_ses-%s_task-%s_run-%02d_reg_stormnet_coords.mat',thesubject, session, task, irun);
        fullfilename = fullfile(output_folder, ifile);
        if (exist(fullfilename)) > 0
            "SNIRF and Stormnet already updated for subject "+num2str(subjectN)+" "
        else
            layout = readtable(fullfile(foldername,filename));

            %load mesh model 4D infants
            %if no data from google sheet, set as 38 weeks
            %participants re-mind google sheet
            subject_week_idx = [1:1:118;
                39	38	41	39	41	41	39	40	39	39	39	40	40	38	40	37	38	39	40	41	40	41	39	41	37	40	38	39	39	40	38	39	39	40	39	38	39	41	41	38	40	38	40	40	39	37	38	40	38	42	39	40	39	41	38	39	40	37	38	39	40	38	41	41	38	40	38	39	39	37	41	38	42	38	42	38	40	41	39	39	40	38	40	40	41		38	39	40	39	40		38	39	40	38	38	40	39	41 38 39 40 37 41 42 39 38 39 40 37 41 39 41 41 40 40 40 42 40]';

            weekN_J = subject_week_idx(find(subject_week_idx(:,1)==subjectN),2);
            %load("Jacobian_infant"+num2str(weekN_J)+"week_850nm.mat")
            %load("mesh_infant"+num2str(weekN_J)+"week_850nm.mat")
            load("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(weekN_J)+"-weeks\AllMeshes_"+num2str(weekN_J)+"weeks.mshs","-mat");

            %% Get co-ords from stormnet txt and do dothub reg
            landmarks = {'nz','iz','lpa','rpa','cz'};
            caploc = {'left_triangle','middle_triangle','right_triangle','top'};
            headloc = {'lefteye','nosetip','righteye'};

            [~,~,idx_lmarks] = intersect(landmarks,layout{:,1},'stable');
            [~,~,idx_caploc] = intersect(caploc,layout{:,1},'stable');
            [~,~,idx_headloc] = intersect(headloc,layout{:,1},'stable');
            idx_detlayout = false(size(layout{:,1}));
            idx_srclayout = false(size(layout{:,1}));
            for i=1:size(layout,1)
                if regexp(layout{i,1}{1},'s\d')==1
                    idx_srclayout(i) = 1;
                end
                if regexp(layout{i,1}{1},'d\d')==1
                    idx_detlayout(i) = 1;
                end
            end

            coord_src = layout{idx_srclayout,2:4};
            coord_det = layout{idx_detlayout,2:4};
            coord_landmark = layout{idx_lmarks,2:4};
            coord_caploc = layout{idx_caploc,2:4};
            coord_headloc = layout{idx_headloc,2:4};

            % Load cranial landmarks and optode positions of the subject
            %load('subjOptPos')

            subjSrcPos = coord_src;
            subjDetPos = coord_det;
            subjCL = coord_landmark;
            landmarks = {'nz','iz','lpa','rpa','cz'};

            % cranialL = [
            % 0.58 	 35.48 	 -14.98;
            % -0.15 	 -67.86 	 -15.95;
            % -39.97 	 -13.52 	 -23.77;
            % 33.49 	 -14.13 	 -23.15;
            % -2.85 	 -18.42 	 62.21;
            % ];
            %get cranial Lm from 4d model landmarks, cz is from 10-5 eeg points
            cranialL = zeros(5,3);
            lm_pts_data = importdata("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(weekN_J)+"-weeks\LandmarkPoints_"+num2str(weekN_J)+"weeks.txt");
            cranialL(1:2,:) = lm_pts_data.data(1:2,:);
            cranialL(3,:) = lm_pts_data.data(4,:); %as al and ar are wrong way around in 4d model lm
            cranialL(4,:) = lm_pts_data.data(3,:);

            eeg_10_5_pts = importdata("E:\PadovaPostDoc\BabyGluCo\4D_models_infants\"+num2str(weekN_J)+"-weeks\10-5_Points_"+num2str(weekN_J)+"weeks.txt");
            cranialL(5,:) = eeg_10_5_pts.data(1,:); %Cz is first point

            % Register with affine transformation
            %idxCz = find(strcmpi(tenFiveLabel,'Cz')); % Find position of Cz for the atlas
            %cranialL(5,:) = tenFive(idxCz,1:3); % add Cz as fifth cranial landmark of the atlas


            % Compute affine transformation between cranial landmarks of subject and
            % atlas -> A is the 3x3 matrix of rotations, scales and shears while b is
            % the translation vector of the T matrix in slide 37
            [A,B] = DOTHUB_affineMap(subjCL,cranialL);
            % Apply T transformation to optode positions to register them to atlas
            subjSrcPosReg = ((A*subjSrcPos') + repmat(B,1,size(subjSrcPos,1)))';
            subjDetPosReg = ((A*subjDetPos') + repmat(B,1,size(subjDetPos,1)))';

            % Bring source and detector positions on node of mesh
            face_idx_ext_surf = faceneighbors(headVolumeMesh.elem(:,1:4),'surface');
            node_idx_ext_surf = unique(face_idx_ext_surf(:));
            surf = headVolumeMesh.node(node_idx_ext_surf,1:3); % creates the surface

            subjSrcPosReg = bringPtsToSurf(surf,subjSrcPosReg);
            subjDetPosReg = bringPtsToSurf(surf,subjDetPosReg);

            %Four vars we want to save and update in the snirf files
            sub_stormnet_dothub_reg_src3D = subjSrcPosReg;
            sub_stormnet_dothub_reg_det3D = subjDetPosReg;
            lm_pts_4D = cranialL;
            lm_4D_label = landmarks;


            %% load snirf

            %for isbj=1:length(subjects)
            %thesubject = subjects{isbj};
            isbj = subjectN;
            thesubject = subjects{isbj};

            % bids input folder
            bids_folder = fullfile(dir_data_bids, ['sub-' thesubject], ['ses-' session], 'nirs');

            % files
            fff_snirf_all = dir(fullfile(bids_folder,'*_nirs.snirf'));

            for irun=1:length(fff_snirf_all)

                fprintf('\n==========================================\n')
                fprintf('Updating probe pos subject: %s run %d\n',thesubject, irun)

                % output folder
                output_folder = fullfile(dir_data_bids, ['sub-' thesubject], ['ses-' session], 'nirs');
                if ~isfolder(output_folder)
                    mkdir(output_folder)
                end

                err_counter = 0;
                %cfgi = cfg;

                info = [];
                info.subjectID = thesubject;
                info.task = task;
                info.session = session;
                info.run = irun;
                info.included = true;
                info.rejection_reason = [];


                try

                    % LOAD DATA
                    % -----------------------------------------------------------------

                    % load snirf
                    fff_snirf = dir(fullfile(bids_folder,sprintf('*run-%02d_nirs.snirf', irun)));
                    ifolderfile_in_snirf = fullfile(fff_snirf(1).folder, fff_snirf(1).name);
                    snirf = SnirfLoad(ifolderfile_in_snirf);




                catch
                    warning('The data could no be loaded...')
                    info.included = false;
                    info.rejection_reason = 'the data could no be loaded';
                end



                if info.included
                    %update co ords in snirf file
                    snirf.probe.sourcePos3D  = sub_stormnet_dothub_reg_src3D;

                    snirf.probe.detectorPos3D = sub_stormnet_dothub_reg_det3D;

                    snirf.probe.landmarkPos3D = lm_pts_4D;

                    snirf.probe.landmarkLabels = lm_4D_label';




                    %save snirf file
                    % snirf data file
                    ifile = sprintf('sub-%s_ses-%s_task-%s_run-%02d_nirs_REG.snirf',thesubject, session, task, irun);
                    fullfilename = fullfile(output_folder, ifile);
                    snirf.Save(fullfilename);

                    reg_stormnet_coords.sub_stormnet_dothub_reg_src3D = sub_stormnet_dothub_reg_src3D;
                    reg_stormnet_coords.sub_stormnet_dothub_reg_det3D = sub_stormnet_dothub_reg_det3D;
                    reg_stormnet_coords.lm_pts_4D = lm_pts_4D;
                    reg_stormnet_coords.lm_4D_label = lm_4D_label';
                    %save registered co-ords
                    ifile = sprintf('sub-%s_ses-%s_task-%s_run-%02d_reg_stormnet_coords.mat',thesubject, session, task, irun);
                    fullfilename = fullfile(output_folder, ifile);
                    save(fullfilename,"reg_stormnet_coords");

                    "Updated snirf for subject "+num2str(subjectN)+" session "+num2str(session)+" and run "+num2str(irun)+" "

                end



            end

        end
    else
    "MNI.txt file not found for subject "+num2str(subjectN)+" "
    
    
    end


end


    
