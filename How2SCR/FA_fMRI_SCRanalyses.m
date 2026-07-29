% Script to run SCR analyses with PsPM
% Programmed by Anneloes Hulsman (2022)
% Matlab version: 2021, PsPM version: 5.0

clear all
close all

addpath('/home/affneu/annhuls/PsPM_v6/');%PsPM folder
addpath('/project/3023001.03/FA_fMRI/Scripts/SCR');
physdata_dir = '/project/3023001.03/FA_fMRI/Data/Physiology/Raw';
pspm_dir = '/project/3023001.03/FA_fMRI/Data/Physiology/PsPM';
stats_dir = '/project/3023001.03/FA_fMRI/Data/Physiology/PsPM/Stats/';
processing = 5; % 1=import SCR data, 2=move pspm files to different directory, 3= run 1st level, 4= export betas
subjects = [5:8, 10:16, 19, 22:26, 28:30, 101, 102, 104:107, 110:114]; % all subjects 


%% Loop through subjects
for subj = subjects
    %makes sure the subject number matches the string of the files

    if subj<10
        sub = ['sub' '00' num2str(subj)];
    elseif subj>9&subj<100 
        sub = ['sub' '0' num2str(subj)];
    else
        sub = ['sub' num2str(subj)];
    end

    disp(['Starting on: ' sub ''])


    %% 1. Import SCR data in PsPM
    if find(processing==1) > 0 % if processing = 1, start importing SCR data
        filename = ([num2str(sub),'.eeg']); % initiates filename of each .eeg file
        EEGfile = fullfile(physdata_dir, filename); % reads .eeg file
        FA_fMRI_importSCRdata % runs batch that imports SCR data
    end

    %% 2. Move PsPM files to different folder
    if find(processing==2) > 0 % if processing = 2, move pspm file to pspm folder
        cd(physdata_dir)
        EEGmatfile = (['pspm_', num2str(sub),'.mat']);
        movefile(EEGmatfile, pspm_dir)
    end


    %% 3. Run PsPM model
    if find(processing==3) > 0 % if processing = 3, run model

        datafilename = (['pspm_', num2str(sub),'.mat']); 
        datafile = fullfile(pspm_dir, "Data", datafilename); 

        timingfilename = (['timing_' num2str(sub), '.mat']);
        timingfile = fullfile(pspm_dir, "Timing", timingfilename);

        conditionsfilename = (['conditions_' num2str(sub), '.mat']);
        conditionsfile = fullfile(pspm_dir, "Conditions", conditionsfilename);
        load(conditionsfile);

        LRLT = cell2mat(conditions(1,1));
        LRMT = cell2mat(conditions(1,2));
        LRHT = cell2mat(conditions(1,3));
        MRLT = cell2mat(conditions(1,4));
        MRMT = cell2mat(conditions(1,5));
        MRHT = cell2mat(conditions(1,6));
        HRLT = cell2mat(conditions(1,7));
        HRMT = cell2mat(conditions(1,8));
        HRHT = cell2mat(conditions(1,9));

        outputname = (['1stlevel_model_', num2str(sub)]);
        outputdir = fullfile(pspm_dir, "Output/Model1");
        FA_fMRI_SCR_1stlevel_v3
    end

    %% 4. Export betas
    if find(processing==4) > 0 % if processing = 4, export betas
        modelfilename = (['1stlevel_model_', num2str(sub),'.mat']); 
        modelfile = fullfile(pspm_dir, "Output", modelfilename); 
        outputname = (['stats_', num2str(sub)]);        
        cd(stats_dir)

        FA_fMRI_SCR_exportbetas

    end

    
end



