% List of open inputs
% Export Statistics: Model File(s) - cfg_files
% Export Statistics: Filename - cfg_entry
nrun = 1; % enter the number of runs here
jobfile = {'/project/3023001.03/FA_fMRI/Scripts/SCR/FA_fMRI_SCR_exportbetas_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(modelfile); % Export Statistics: Model File(s) - cfg_files
    inputs{2, crun} = outputname; % Export Statistics: Filename - cfg_entry
end
job_id = cfg_util('initjob', jobs);
sts    = cfg_util('filljob', job_id, inputs{:});
if sts
    cfg_util('run', job_id);
end
cfg_util('deljob', job_id);
