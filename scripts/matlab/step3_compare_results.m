%% Step C: Compare Habit vs. Surprise Decoding Accuracy
%
% Objectives:
%   1. Load the decoding results for 'Habit' and 'Surprise' conditions.
%   2. Extract peak decoding accuracy from the 'Decision' window (0-500ms).
%   3. Perform a paired t-test (Habit vs. Surprise).
%   4. Plot the time-course of decoding accuracy for both conditions.

clearvars; clc;

%% 1. Setup Paths and Parameters
path_to_data = '../data'; % Ensure this points to your data folder
pair_ids = [1:9,11:22,25:34]; % Same valid pairs as before
num_pairs = length(pair_ids);
num_participants = num_pairs * 2;

% Define Time Window of Interest (Decision Phase)
% The time bins in the decoding results correspond to:
% Bin 1: 0.00 - 0.25s
% Bin 2: 0.25 - 0.50s
% Bin 3: 0.50 - 0.75s ... etc.
% We want the first 2-3 bins (approx 0 to 750ms) where the decision happens.
time_bins_of_interest = 12:15; 

% Storage for Peak Accuracies (62 participants x 2 conditions)
% Column 1: Habit, Column 2: Surprise
peak_accuracies = nan(num_participants, 2);

% Storage for Full Time Courses (for plotting later)
% 62 participants x 20 time bins (approx)
time_course_habit = [];
time_course_surprise = [];

%% 2. Loop Through All Participants
row_counter = 1;

for p = 1:num_pairs
    pair = pair_ids(p);
    
    for ppt = 1:2
        % Construct filenames
        file_habit = fullfile(path_to_data, 'derivatives', ...
            sprintf('pair-%02d_player-%01d_task-RPS_decoding_Habit.mat', pair, ppt));
        file_surprise = fullfile(path_to_data, 'derivatives', ...
            sprintf('pair-%02d_player-%01d_task-RPS_decoding_Surprise.mat', pair, ppt));
        
        % Check if both files exist (some might have been skipped due to low trial counts)
        if exist(file_habit, 'file') && exist(file_surprise, 'file')
            
            % --- Load Habit Data ---
            dat = load(file_habit, 'decoding_accuracy');
            % decoding_accuracy{1} is "Self Current Response"
            res_habit = dat.decoding_accuracy{1}.samples; 
            
            % --- Load Surprise Data ---
            dat = load(file_surprise, 'decoding_accuracy');
            res_surprise = dat.decoding_accuracy{1}.samples;
            
            % --- Extract Peaks ---
            % We look for the maximum value in the decision window
            peak_accuracies(row_counter, 1) = max(res_habit(time_bins_of_interest));
            peak_accuracies(row_counter, 2) = max(res_surprise(time_bins_of_interest));
            
            % --- Store Time Courses ---
            % We assume standard 20 time bins from the previous script
            time_course_habit(row_counter, :) = res_habit(1:20);
            time_course_surprise(row_counter, :) = res_surprise(1:20);
            
            fprintf('Processed Pair %d Player %d\n', pair, ppt);
        else
            fprintf('Skipping Pair %d Player %d (Missing Data)\n', pair, ppt);
        end
        
        row_counter = row_counter + 1;
    end
end

%% 3. Clean Missing Data (NaNs)
% Remove rows where data was missing (skipped participants)
valid_rows = ~isnan(peak_accuracies(:,1));
peak_accuracies = peak_accuracies(valid_rows, :);
time_course_habit = time_course_habit(valid_rows, :);
time_course_surprise = time_course_surprise(valid_rows, :);

fprintf('\nAnalysis included %d valid participants.\n', sum(valid_rows));

%% 4. Statistical Test (Paired t-test)
[h, p_val, ci, stats] = ttest(peak_accuracies(:,1), peak_accuracies(:,2));

fprintf('\n=== Statistical Results ===\n');
fprintf('Mean Peak Accuracy (Habit):    %.2f%%\n', mean(peak_accuracies(:,1)) * 100);
fprintf('Mean Peak Accuracy (Surprise): %.2f%%\n', mean(peak_accuracies(:,2)) * 100);
fprintf('T-Statistic: %.4f\n', stats.tstat);
fprintf('P-Value:     %.5f\n', p_val);

if p_val < 0.05
    fprintf('RESULT: SIGNIFICANT DIFFERENCE FOUND!\n');
else
    fprintf('RESULT: No significant difference.\n');
end

%% 5. Visualization
figure('Color','w', 'Position', [100, 100, 1000, 400]);

% --- Subplot 1: Bar Chart of Means ---
subplot(1,2,1);
means = mean(peak_accuracies) * 100;
sems = std(peak_accuracies) / sqrt(size(peak_accuracies,1)) * 100;

b = bar(means, 'FaceColor', 'flat');
b.CData(1,:) = [0.2 0.6 0.8]; % Blue for Habit
b.CData(2,:) = [0.8 0.4 0.2]; % Orange for Surprise
hold on;

% Error Bars
errorbar(1:2, means, sems, 'k.', 'LineWidth', 2);
xticklabels({'Habit', 'Surprise'});
ylabel('Peak Decoding Accuracy (%)');
title('Peak Decoding Performance');
ylim([30 45]); % Adjust based on data (Chance is 33%)
yline(33.3, 'k--', 'Chance', 'HandleVisibility', 'off'); % Hides this line from legend
grid on;

% --- Subplot 2: Time Course ---
subplot(1,2,2);
% Create a dummy x-axis (1 to 20)
x_axis = 1:20; 

mean_trace_habit = mean(time_course_habit) * 100;
mean_trace_surprise = mean(time_course_surprise) * 100;

% FIX: Assign handles (h1, h2) to the plots
h1 = plot(x_axis, mean_trace_habit, 'b-', 'LineWidth', 2); hold on;
h2 = plot(x_axis, mean_trace_surprise, 'r-', 'LineWidth', 2);

% Add vertical lines to separate the phases
% We set HandleVisibility to off just in case, though the specific legend call below fixes it mostly
xline(8.5, 'k--', 'Response Start', 'HandleVisibility', 'off');
xline(16.5, 'k--', 'Feedback Start', 'HandleVisibility', 'off');
legend([h1, h2], {'Habit', 'Surprise'});

xlabel('Time Bins (250ms each)');
ylabel('Accuracy (%)');
title('Decoding Accuracy: Decision -> Response -> Feedback');
yline(33.3, 'k--', 'Chance', 'HandleVisibility', 'off');
xlim([1 20]);
grid on;
