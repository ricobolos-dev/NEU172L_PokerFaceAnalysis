%% Test script - Process just ONE pair to verify everything works
% This should take ~2-3 minutes instead of 1 hour
%
% Run this first to make sure the pipeline works, then run the full analysis

clear; clc;

fprintf('\n');
fprintf('========================================================\n');
fprintf('  TEST RUN - Processing ONE pair only\n');
fprintf('========================================================\n');
fprintf('\n');

%% Setup
fprintf('Setting up toolboxes...\n');
setup_toolboxes
fprintf('\n');

%% Modify step1_preprocessing to process just pair 1
fprintf('Preprocessing pair 01 only (this is a test)...\n');
fprintf('This should take 2-3 minutes.\n\n');

% Set parameters inline for testing
path_to_data = '../..';  % Data is two directories up from scripts/matlab/
identify_bad_channels = false;
interpolate_bad_channels = true;
num_trials = 480;
pair_ids = [1];  % ONLY PROCESS PAIR 1
num_pairs = 1;
FS = 2048;

% Load demographics
participants = readtable('../../participants.tsv','FileType','text','Delimiter','\t');

% Create derivatives folder
if ~exist('../../derivatives','dir')
    mkdir('../../derivatives');
end

start_time = tic;

% Process pair 1
for p = 1:num_pairs
    pair = pair_ids(1,p);
    fprintf('Loading pair %.0f of %.0f\n',p,num_pairs);

    % Get trigger times
    events_filename = fullfile(path_to_data,num2str(pair,'sub-%02d'),'eeg',num2str(pair,'sub-%02d_task-RPS_events.tsv'));
    events = readtable(events_filename,'FileType','text','Delimiter','\t');
    stimonsample = events.onset_sample;

    prestim = 0.2;
    poststim = 5;
    TRL = [stimonsample-ceil(prestim*FS),ceil(stimonsample+poststim*FS)];
    TRL(:,3) = TRL(:,1)-stimonsample;

    raw_filename = fullfile(path_to_data,num2str(pair,'sub-%02d'),'eeg',num2str(pair,'sub-%02d_task-RPS_eeg.bdf'));
    hdr = ft_read_header(raw_filename);

    for ppt = 1:2
        fprintf('   ppt %.0f\n',ppt);

        chan_idx = [contains(hdr.label,'2-A')+contains(hdr.label,'2-B'),contains(hdr.label,'1-A')+contains(hdr.label,'1-B')];
        orig_label = hdr.label(chan_idx(:,ppt)==1);

        cfg = [];
        cfg.datafile = raw_filename;
        cfg.trl = TRL;
        cfg.channel = orig_label;
        data_epoch = ft_preprocessing(cfg);

        layout = ft_prepare_layout(struct('layout','biosemi64.lay'));
        data_epoch.label(1:64) = layout.label(1:64);
        data_epoch.dimord = 'chan_time';

        % Interpolate bad channels
        if interpolate_bad_channels
            chan_to_fix = participants(strcmp(participants.participant_id,num2str(pair,'sub-%02d')),[6,10]);
            chan_to_fix = table2cell(chan_to_fix(1,ppt));
            if ~isempty(chan_to_fix{1})
                load('../../biosemi64.mat');
                elec = [];
                elec.pnt = biosemi64;
                elec.label = data_epoch.label;
                cfg = [];
                cfg.method = 'distance';
                cfg.neighbourdist = .5;
                neighbours = ft_prepare_neighbours(cfg, elec);

                cfg = [];
                cfg.method = 'spline';
                cfg.badchannel = split(chan_to_fix{1},', ')';
                cfg.neighbours = neighbours;
                cfg.elec = elec;
                data_epoch = ft_channelrepair(cfg, data_epoch);
            end
        end

        % Downsample
        cfg = [];
        cfg.resamplefs = 256;
        cfg.detrend = 'no';
        eeg_data = ft_resampledata(cfg, data_epoch);

        % Save
        save(sprintf('../../derivatives/pair-%02d_player-%01d_task-RPS_eeg.mat',pair,ppt),'eeg_data');
    end
end

elapsed = toc(start_time);
fprintf('\n✓ Test preprocessing complete! Time: %.1f minutes\n\n', elapsed/60);

fprintf('Check the output:\n');
fprintf('  ls ../../derivatives/pair-01_*.mat\n\n');
fprintf('If this worked, you can run the full analysis with RUN_ALL_ANALYSIS\n');
