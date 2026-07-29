% creates a .mat file from the marker data that contains all event onsets
% and offsets for model definition in PsPM
% assuming one file per subject

clear all;

physiologydir = '/project/3023001.03/FA_fMRI/Data/Physiology/Raw'; % phsyiology data directory
outputdir = '/project/3023001.03/FA_fMRI/Data/Physiology/PsPM/Timing'; % output directory

cd (physiologydir);
datafiles = dir('*.vmrk');

for i = [1,3:size(datafiles)] % for each vmrk file in this directory
    cd(physiologydir);
    datafile = fopen(datafiles(i).name);
    subj(i).name = (datafiles(i).name(1:6)); % read subject name (i.e., first 6 characters in filename)
    subj(i).data = textscan(datafile, '%s %s %f', 'headerlines', 12, 'delimiter', ','); % put the data in a struct

    % create variables for each event
    offer_onset = 0; % markers: S11, 21, 31, 12, 22, 32, 13, 23, 33
    response = 0;
    anticipation_onset = 0; % marker: S8
    outcome_onset = 0; % markers: S14, 15, 16, 24, 25, 26, 34, 35, 36, 50, 60, 70, 80
    neg_outcome_onset =0;
    pos_outcome_onset =0;
    neutral_outcome_onset = 0;
    ITI = 0; % marker: S9

    % create counters for each event
    offer_onset_c = 0;
    response_c = 0;
    outcome_onset_c = 0;
    neg_outcome_onset_c =0;
    pos_outcome_onset_c =0;
    neutral_outcome_onset = 0;
    ITI_c = 0;
    missing_c = 0;

    codes = subj(i).data{2};
    mpoints = subj(i).data{3};
    count = 0;
    events = cell(1,5);

    SR = 5000; % sampling rate

    for l = 1:size(codes,1) % for each line in the markerfile
        code = codes{l};
        switch code
            case {'S 11', 'S 12', 'S 13', 'S 21', 'S 22', 'S 23', 'S 31', 'S 32', 'S 33'} % offer phase: S11, 21, 31, 12, 22, 32, 13, 23, 33
                offer_onset_c = offer_onset_c + 1;
                subj(i).offer_onset(offer_onset_c,1) = (mpoints(l,1))/SR;

            case {'S  7'} % response; if no response was given this would be 2.5s after trial onset
                response_c = response_c + 1;
                subj(i).response(response_c,1) = (mpoints(l,1))/SR;
                subj(i).anticipation_onset(response_c,1) = (mpoints(l,1))/SR;

                % if this is followed by S16, S26, S36 (indicators of late response) then count as missing!
                for a = 1:80 % checks a few lines further for markers of no response
                    if strcmp(codes{l+a}, 'S 16') || strcmp(codes{l+a}, 'S 26') ||  strcmp(codes{l+a}, 'S 36')
                        missing_c = missing_c + 1;
                        subj(i).response(response_c,1) = -1;
                    end
                end

            case {'S 14', 'S 15', 'S 16', 'S 24', 'S 25', 'S 26', 'S 34', 'S 35', 'S 36', 'S 50', 'S 60', 'S 70', 'S 80'}
                outcome_onset_c = outcome_onset_c + 1;
                subj(i).outcome_onset(outcome_onset_c,1) = (mpoints(l,1))/SR;


                if strcmp(codes{l}, 'S 14') || strcmp(codes{l}, 'S 24') || strcmp(codes{l}, 'S 34') || strcmp(codes{l}, 'S 15') ||  strcmp(codes{l}, 'S 25') ||  strcmp(codes{l}, 'S 35') ||  strcmp(codes{l}, 'S 16') ||  strcmp(codes{l}, 'S 26') ||  strcmp(codes{l}, 'S 36') % markers of negative outcomes
                    subj(i).neg_outcome_onset(outcome_onset_c,1) = (mpoints(l,1))/SR;
                else
                    subj(i).neg_outcome_onset(outcome_onset_c,1) = -1;
                end


                if strcmp(codes{l}, 'S 50') || strcmp(codes{l}, 'S 60') % markers of positive outcomes
                    subj(i).pos_outcome_onset(outcome_onset_c,1) = (mpoints(l,1))/SR;
                else
                    subj(i).pos_outcome_onset(outcome_onset_c,1) = -1;
                end

                if strcmp(codes{l}, 'S 70') || strcmp(codes{l}, 'S 80') % markers of neutral outcomes
                    subj(i).neutral_outcome_onset(outcome_onset_c,1) = (mpoints(l,1))/SR;
                else
                    subj(i).neutral_outcome_onset(outcome_onset_c,1) = -1;

                end


            case {'S  9'} % ITI
                ITI_c = ITI_c + 1;
                subj(i).ITI(ITI_c,1) = (mpoints(l,1))/SR;

        end
    end

    % IMPORTANT: the cells need to be named 'events' for PsPM to work!!!
    events{1}(:,1) = subj(i).offer_onset;
    events{1}(:,2) = subj(i).outcome_onset;

    events{2} = subj(i).response;

    events{3} = subj(i).neg_outcome_onset;
    events{4} = subj(i).pos_outcome_onset;
    events{5} = subj(i).neutral_outcome_onset;


    cd(outputdir);
    save ((['timing_', num2str(subj(i).name), '.mat']), 'events');

end

