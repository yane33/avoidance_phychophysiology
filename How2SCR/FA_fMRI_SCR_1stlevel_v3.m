% List of open inputs
% Non-Linear Model: Model Filename - cfg_entry
% Non-Linear Model: Data File - cfg_files
% Non-Linear Model: Timing File - cfg_files
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
% Non-Linear Model: Index - cfg_entry
nrun = 1; % enter the number of runs here
jobfile = {'/project/3023001.03/FA_fMRI/Scripts/SCR/FA_fMRI_SCR_1stlevel_v3_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(12, nrun);
for crun = 1:nrun
    inputs{1, crun} = outputname; % Non-Linear Model: Model Filename - cfg_entry
    inputs{2, crun} = cellstr(datafile); % Non-Linear Model: Data File - cfg_files
    inputs{3, crun} = cellstr(timingfile); % Non-Linear Model: Timing File - cfg_files
    inputs{4, crun} = LRLT; % Non-Linear Model: Index - cfg_entry
    inputs{5, crun} = LRMT; % Non-Linear Model: Index - cfg_entry
    inputs{6, crun} = LRHT; % Non-Linear Model: Index - cfg_entry
    inputs{7, crun} = MRLT; % Non-Linear Model: Index - cfg_entry
    inputs{8, crun} = MRMT; % Non-Linear Model: Index - cfg_entry
    inputs{9, crun} = MRHT; % Non-Linear Model: Index - cfg_entry
    inputs{10, crun} = HRLT; % Non-Linear Model: Index - cfg_entry
    inputs{11, crun} = HRMT; % Non-Linear Model: Index - cfg_entry
    inputs{12, crun} = HRHT; % Non-Linear Model: Index - cfg_entry
end
job_id = cfg_util('initjob', jobs);
sts    = cfg_util('filljob', job_id, inputs{:});
if sts
    cfg_util('run', job_id);
end
cfg_util('deljob', job_id);
