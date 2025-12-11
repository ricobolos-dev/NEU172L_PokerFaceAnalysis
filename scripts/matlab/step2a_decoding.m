%% Decoding script:
%   - Decode own & opponent's response for current & previous trial
%
% Toolboxes needed: fieldtrip (we used version 20240110 here), cosmomvpa
%
% Notes:
%   - We excluded pair 10 (major CMS issues for ppt 2), 23 (no triggers),
%   and 24 (major CMS issues for ppt 2 - first 32 trials only)

clearvars; clc;

%% Set the path
path_to_data = '../data';

%% Set parameters
pair_ids = [1:9,11:22,25:34];   % Pair IDs (Pair 10 (major CMS issues for ppt 2), 23 (no triggers), 24 (major CMS issues for ppt 2 for first first 32 trials) were excluded)
num_pairs = size(pair_ids,2);   % Number of pairs
num_trials = 480;
num_chan = 64;

%% Loop over pairs
% Pre-allocate the output
decoding_accuracy = cell(1,4);
searchlight_acc = cell(1,4);
pair_idx = reshape(1:num_pairs*2,[2,num_pairs])';

for p = 1:num_pairs

    % Get the pair ID
    pair = pair_ids(1,p);
    fprintf('Loading pair %.0f of %.0f\n',p,num_pairs);

    % Load in the behaviour
    events = readtable(fullfile(path_to_data,num2str(pair,'sub-%02d'),'eeg',num2str(pair,'sub-%02d_task-RPS_events.tsv')),'Filetype','text','delimiter','\t');

    % We need the following columns:
    % Column 5 - Player 1 played: 1) Rock 2) Paper 3) Scissors
    % Column 7 - Player 2 played: 1) Rock 2) Paper 3) Scissors
    % Column 9 - Outcome: 1) draw, 2) player 1 wins, 3) player 2 wins
    events = events(:,[5,7,9]);

    % Get the behavioural responses in the right format
    % Column 1 - This player played: 1) Rock 2) Paper 3) Scissors
    % Column 2 - Other player played: 1) Rock 2) Paper 3) Scissors
    % Column 3 - Outcome: 1) draw, 2) this wins, 3) other player wins
    % Column 4 - In the previous trial, this player played: 1) Rock 2) Paper 3) Scissors
    % Column 5 - In the previous trial, the other player played: 1) Rock 2) Paper 3) Scissors
    % Get the data for player 1
    Player_1_Behav = [table2array(events),[nan,nan;table2array(events(1:end-1,1:2))]];
    % Get the data for player 2
    Player_2_Behav = [table2array(events(:,[2,1])),zeros(num_trials,1),[nan,nan;table2array(events(1:end-1,[2,1]))]];
    % Change coding of column 3 for player 2 (outcome) to code outcome relative to player 2
    Player_2_Behav(Player_1_Behav(:,3)==1,3) = 1;
    Player_2_Behav(Player_1_Behav(:,3)==2,3) = 3;
    Player_2_Behav(Player_1_Behav(:,3)==3,3) = 2;
    all_behav_data = cat(3,Player_1_Behav,Player_2_Behav);

    % Set random seed
    rng(p);

    % Loop over the 2 players in the pair
    for ppt = 1:2

        fprintf('   ppt %.0f\n',ppt);   
        load(sprintf('%s/derivatives/pair-%02d_player-%01d_task-RPS_eeg.mat',path_to_data,pair,ppt));
        
        % Re-reference to the average reference
        cfg=[];
        cfg.reref      = 'yes';
        cfg.refchannel = 1:64;
        eeg_data = ft_preprocessing(cfg,eeg_data);
        
        % Split the data into 3 parts
        cfg = [];
        cfg.latency = [-0.2 2];
        eeg_data_partA = ft_selectdata(cfg,eeg_data);
        cfg.latency = [1.8 4];
        eeg_data_partB = ft_selectdata(cfg,eeg_data);
        cfg.latency = [3.8 5];
        eeg_data_partC = ft_selectdata(cfg,eeg_data);
        
        % Shift time labels
        for trial_num = 1:num_trials
            eeg_data_partB.time{trial_num} = eeg_data_partA.time{trial_num};
            eeg_data_partC.time{trial_num} = eeg_data_partA.time{trial_num}(1,1:length(eeg_data_partC.time{trial_num}));
        end
        
        % Baseline-correction
        cfg = [];
        cfg.demean = 'yes';
        cfg.baselinewindow = [-0.2 0];
        eeg_data_partA = ft_preprocessing(cfg,eeg_data_partA);
        eeg_data_partB = ft_preprocessing(cfg,eeg_data_partB);
        eeg_data_partC = ft_preprocessing(cfg,eeg_data_partC);
        
        % Get the behavioural responses
        behav_data = all_behav_data(:,:,ppt);
        
        % Remove the first trial of each block (indices 1, 41, 81...)
        rem_idx = 1:40:480; 
        
        % Apply removal to behavior and EEG
        behav_data(rem_idx,:) = [];
        sel_idx = 1:num_trials;
        sel_idx(rem_idx) = [];
        
        cfg = [];
        cfg.trials = sel_idx;
        eeg_data_partA = ft_selectdata(cfg,eeg_data_partA);
        eeg_data_partB = ft_selectdata(cfg,eeg_data_partB);
        eeg_data_partC = ft_selectdata(cfg,eeg_data_partC);
        
        % Average into time bins
        time_windows_AB = [0:0.25:1.75;0.25:0.25:2]';
        time_windows_C = [0:0.25:0.75;0.25:0.25:1]';
        
        eeg_data = eeg_data_partA;
        eeg_data.trial = []; eeg_data.time = [];
        
        for trial_num = 1:size(eeg_data_partA.trial,2)
            temp_A = zeros(num_chan,size(time_windows_AB,1));
            temp_B = zeros(num_chan,size(time_windows_AB,1));
            for w_idx = 1:size(time_windows_AB,1)
                temp_A(:,w_idx) = mean(eeg_data_partA.trial{trial_num}(:,eeg_data_partA.time{trial_num}>time_windows_AB(w_idx,1)&eeg_data_partA.time{trial_num}<time_windows_AB(w_idx,2)),2);
                temp_B(:,w_idx) = mean(eeg_data_partB.trial{trial_num}(:,eeg_data_partB.time{trial_num}>time_windows_AB(w_idx,1)&eeg_data_partB.time{trial_num}<time_windows_AB(w_idx,2)),2);
            end
            temp_C = zeros(num_chan,size(time_windows_C,1));
            for w_idx = 1:size(time_windows_C,1)
                temp_C(:,w_idx) = mean(eeg_data_partC.trial{trial_num}(:,eeg_data_partC.time{trial_num}>time_windows_C(w_idx,1)&eeg_data_partC.time{trial_num}<time_windows_C(w_idx,2)),2);
            end
            eeg_data.trial{trial_num} = [temp_A,temp_B,temp_C];
            eeg_data.time{trial_num} = [time_windows_AB(:,2);time_windows_AB(:,2)+2;time_windows_C(:,2)+4]';
        end
        
        % Convert to CosmoMVPA
        cfg = [];
        cfg.keeptrials = 'yes';
        ds_full = cosmo_meeg_dataset(ft_timelockanalysis(cfg,eeg_data));
        
        % Attach labels (VariableNames: self, other, result, selfp, otherp)
        ds_full.sa = table2struct(array2table(behav_data,'VariableNames',{'self','other','result','selfp','otherp'}),'toscalar',1);
        
        % 1. Load the Habit Vector
        trial_file = fullfile(path_to_data, 'derivatives', sprintf('pair-%02d_player-%01d_task-RPS_trialclass.mat', pair, ppt));
        if ~exist(trial_file, 'file')
            continue; 
        end
        load(trial_file, 'habit_vector'); 
        
        % 2. Sync Habit Vector with EEG
        habit_vector(rem_idx) = []; 
        
        % 3. Balance Trials
        idx_habit = find(habit_vector == 1);
        idx_surprise = find(habit_vector == 0);
        
        n_min = min(length(idx_habit), length(idx_surprise));
        if n_min < 20
            fprintf('Pair %d Player %d: Not enough trials (N=%d). Skipping.\n', pair, ppt, n_min);
            continue;
        end
        
        rng(pair*100 + ppt); 
        idx_habit_sub = randsample(idx_habit, n_min);
        idx_surprise_sub = randsample(idx_surprise, n_min);
        
        cond_indices = {idx_habit_sub, idx_surprise_sub};
        cond_names = {'Habit', 'Surprise'};

        % 4. Run Decoding Loop
        for c = 1:2
            current_idx = cond_indices{c};
            current_cond = cond_names{c};
            
            decoding_accuracy = cell(1,4);
            searchlight_acc = cell(1,4);
            
            for test = 1:4
                ds_sel = ds_full; % Start with full preprocessed dataset
                
                % Set Targets based on test ID
                if test == 1, targets = ds_sel.sa.self;
                elseif test == 2, targets = ds_sel.sa.other;
                elseif test == 3, targets = ds_sel.sa.selfp;
                elseif test == 4, targets = ds_sel.sa.otherp;
                end
                
                ds_sel.sa.targets = targets;
                
                % MASKING
                % Filter 1: Valid targets (not NaN)
                % Filter 2: Trials belonging to current condition (Habit or Surprise)
                % MASKING: Filter for (1) Valid Targets (Not NaN and Not 0) AND (2) Current Condition
                mask = ~isnan(targets) & targets > 0; 
                mask(~ismember(1:length(targets), current_idx)) = false;
                
                % Apply slice
                ds_sel = cosmo_slice(ds_sel, mask);

                % % 1. Define Frontal Channels
                % frontal_chan_labels = {'Fp1','Fp2','AF7','AF3','AFz','AF4','AF8','F7','F5','F3','F1','Fz','F2','F4','F6','F8'};
                % 
                % % 2. Create Mask using cosmo_dim_match
                % % This function looks up the channel names in the dataset 
                % % and finds the features that match your list.
                % try
                %     mask_frontal = cosmo_dim_match(ds_sel, 'chan', frontal_chan_labels);
                % 
                %     % 3. Apply the Spatial Slice (Dimension 2 = Features)
                %     ds_sel = cosmo_slice(ds_sel, mask_frontal, 2);
                % 
                % catch ME
                %     % Fallback warning if channels are named differently in your specific file
                %     warning('Could not match frontal channels. Using all channels instead. Error: %s', ME.message);
                % end
                
                
                % 1. Count trials for EACH class (Rock, Paper, Scissors)
                % We need to know the limit of the RAREST move.
                classes = unique(ds_sel.sa.targets);
                class_counts = zeros(size(classes));
                for i = 1:length(classes)
                    class_counts(i) = sum(ds_sel.sa.targets == classes(i));
                end
                
                % Find the count of the move played least often
                min_class_count = min(class_counts);
                
                % 2. Calculate safe parameters
                % We prefer averaging 4 trials, but we must adapt if data is scarce.
                avg_count = 4;
                
                % Calculate max possible chunks for count=4
                % Formula: We need (n_chunks * avg_count) <= min_class_count
                n_chunks = floor(min_class_count / avg_count);
                
                % If we can't even support 2 chunks with count=4, reduce strictness
                if n_chunks < 2
                     % Try reducing average count to 2
                     n_chunks = floor(min_class_count / 2);
                     avg_count = 2;
                     
                     % If still not enough, drop to count=1 (no averaging, just balancing)
                     if n_chunks < 2
                         n_chunks = min_class_count; 
                         avg_count = 1;
                     end
                end
                
                % Cap chunks at 10 (standard maximum)
                if n_chunks > 10
                    n_chunks = 10;
                end
                
                % 3. Safety Check: If we still don't have enough data for 2 chunks
                if n_chunks < 2
                    fprintf('   Skipping %s (Cond: %s): Too few trials for rarest class (%d)\n', sprintf('P%d', ppt), current_cond, min_class_count);
                    continue; 
                end
                
                % 4. Apply Chunking and Averaging
                ds_sel.sa.chunks = (1:numel(ds_sel.sa.targets))'; % Initialize
                ds_sel.sa.chunks = cosmo_chunkize(ds_sel, n_chunks);
                
                % Run averaging with our safely calculated 'avg_count'
                ds_sel = cosmo_average_samples(ds_sel, 'count', avg_count, 'repeats', 20, 'seed', 1);
                
                % ============================================================
                
                % Decoding Analysis
                nh = cosmo_interval_neighborhood(ds_sel,'time','radius',0);
                measure = @cosmo_crossvalidation_measure;
                ma = struct();
                ma.partitions = cosmo_nfold_partitioner(ds_sel);
                ma.classifier = @cosmo_classify_lda;
                ma.output = 'accuracy';
                
                % Run Searchlight
                res = cosmo_searchlight(ds_sel,nh,measure,ma);
                res.sa.pair = pair;
                res.sa.player = ppt;
                decoding_accuracy{test} = res;
            end
            
            % Save
            save_name = sprintf('pair-%02d_player-%01d_task-RPS_decoding_%s.mat', pair, ppt, current_cond);
            save(fullfile(path_to_data, 'derivatives', save_name), 'decoding_accuracy');
        end

        clearvars eeg_data eeg_data_partA eeg_data_partB eeg_data_partC ds_full ds_sel habit_vector decoding_accuracy searchlight_acc;
    
    end % End Participant Loop
end % Loop over pairs
