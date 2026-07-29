% List of open inputs
% Import: Data File(s) - cfg_files
nrun = 1; % enter the number of runs here
jobfile = {'/project/3023001.03/FA_fMRI/Scripts/SCR/FA_fMRI_importSCRdata_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(1, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(EEGfile); % Import: Data File(s) - cfg_files
end
job_id = cfg_util('initjob', jobs);
sts    = cfg_util('filljob', job_id, inputs{:});
if sts
    cfg_util('run', job_id);
end
cfg_util('deljob', job_id);
