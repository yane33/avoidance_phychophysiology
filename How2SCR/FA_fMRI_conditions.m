clear all;

physiologydir = '/project/3023001.03/FA_fMRI/Data/Physiology/Raw'; % phsyiology data directory
outputdir = '/project/3023001.03/FA_fMRI/Data/Physiology/PsPM/Conditions'; % output directory

cd (physiologydir);
datafiles = dir('*.vmrk');

for i = 1:size(datafiles); % for each vmrk file in this directory
    cd(physiologydir);
    datafile = fopen(datafiles(i).name);
    subj(i).name = (datafiles(i).name(1:6));
    subj(i).data = textscan(datafile, '%s %s %f', 'headerlines', 12, 'delimiter', ','); % put the data in a struct


    % creates variables for each event
    trial= 0; % S11, 21, 31, 12, 22, 32, 13, 23, 33
    LRLT = zeros(1,10);
    LRMT = zeros(1,10);
    LRHT = zeros(1,10);
    MRLT = zeros(1,10);
    MRMT = zeros(1,10);
    MRHT = zeros(1,10);
    HRLT = zeros(1,10);
    HRMT = zeros(1,10);
    HRHT = zeros(1,10);

    % counters for each event
    trial_c = 0;
    LRLT_c = 0;
    LRMT_c = 0;
    LRHT_c = 0;
    MRLT_c = 0;
    MRMT_c = 0;
    MRHT_c = 0;
    HRLT_c = 0;
    HRMT_c = 0;
    HRHT_c = 0;
    codes = subj(i).data{2};
    mpoints = subj(i).data{3};
    count = 0;
    events = cell(1,4);


    for l = 1:size(codes,1) % for each line in the markerfile
        code = codes{l};
        switch code
            case {'S 11'}
                trial_c = trial_c + 1;
                LRLT_c = LRLT_c + 1;
                subj(i).LRLT(1,LRLT_c) = trial_c;
            case {'S 21'}
                trial_c = trial_c + 1;
                LRMT_c = LRMT_c + 1;
                subj(i).LRMT(1,LRMT_c) = trial_c;
            case {'S 31'}
                trial_c = trial_c + 1;
                LRHT_c = LRHT_c + 1;
                subj(i).LRHT(1,LRHT_c) = trial_c;
            case {'S 12'}
                trial_c = trial_c + 1;
                MRLT_c = MRLT_c + 1;
                subj(i).MRLT(1,MRLT_c) = trial_c;
            case {'S 22'}
                trial_c = trial_c + 1;
                MRMT_c = MRMT_c + 1;
                subj(i).MRMT(1,MRMT_c) = trial_c;
            case {'S 32'}
                trial_c = trial_c + 1;
                MRHT_c = MRHT_c + 1;
                subj(i).MRHT(1,MRHT_c) = trial_c;
            case {'S 13'}
                trial_c = trial_c + 1;
                HRLT_c = HRLT_c + 1;
                subj(i).HRLT(1,HRLT_c) = trial_c;
            case {'S 23'}
                trial_c = trial_c + 1;
                HRMT_c = HRMT_c + 1;
                subj(i).HRMT(1,HRMT_c) = trial_c;
            case {'S 33'}
                trial_c = trial_c + 1;
                HRHT_c = HRHT_c + 1;
                subj(i).HRHT(1,HRHT_c) = trial_c;
        end
    end

    conditions{1} = subj(i).LRLT;
    conditions{2} = subj(i).LRMT;
    conditions{3} = subj(i).LRHT;
    conditions{4} = subj(i).MRLT;
    conditions{5} = subj(i).MRMT;
    conditions{6} = subj(i).MRHT;
    conditions{7} = subj(i).HRLT;
    conditions{8} = subj(i).HRMT;
    conditions{9} = subj(i).HRHT;

    cd(outputdir)
    save (['conditions_', num2str(subj(i).name), '.mat'], 'conditions');
end


                