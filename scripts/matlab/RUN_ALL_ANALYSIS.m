%% Master script to run all analysis steps
% This will run the complete pipeline for the Poker Face analysis
%
% IMPORTANT: This will take 4-5 hours total!
% Consider running steps individually, especially step2a_decoding overnight.
%
% Steps:
%   1. Setup toolboxes
%   2. Preprocessing (~1 hour)
%   3. Markov chain (~5 minutes)
%   4. Neural decoding (~3 hours)

clear; clc;

fprintf('\n');
fprintf('========================================================\n');
fprintf('  POKER FACE ANALYSIS - Complete Pipeline\n');
fprintf('========================================================\n');
fprintf('\n');

%% Step 0: Setup
fprintf('STEP 0: Setting up toolboxes...\n');
fprintf('--------------------------------------------------------\n');
setup_toolboxes
fprintf('\n');

%% Step 1: Preprocessing
fprintf('STEP 1: Preprocessing EEG data...\n');
fprintf('--------------------------------------------------------\n');
fprintf('This will take approximately 1 hour.\n');
fprintf('Processing 31 pairs (62 players)...\n\n');

start_time = tic;
step1_preprocessing
elapsed = toc(start_time);
fprintf('\n✓ Preprocessing complete! Time: %.1f minutes\n\n', elapsed/60);

%% Step 2b: Markov Chain (behavioral predictability)
fprintf('STEP 2b: Running Markov chain analysis...\n');
fprintf('--------------------------------------------------------\n');
fprintf('This will take approximately 5-10 minutes.\n\n');

start_time = tic;
step2b_markovchain
elapsed = toc(start_time);
fprintf('\n✓ Markov chain complete! Time: %.1f minutes\n\n', elapsed/60);

%% Step 2a: Neural Decoding
fprintf('STEP 2a: Running neural decoding analysis...\n');
fprintf('--------------------------------------------------------\n');
fprintf('WARNING: This will take approximately 3-4 hours!\n');
fprintf('Consider running this step separately overnight.\n\n');

response = input('Continue with neural decoding? (y/n): ', 's');
if strcmpi(response, 'y')
    start_time = tic;
    step2a_decoding
    elapsed = toc(start_time);
    fprintf('\n✓ Neural decoding complete! Time: %.1f hours\n\n', elapsed/3600);

    fprintf('\n');
    fprintf('========================================================\n');
    fprintf('  ALL MATLAB PROCESSING COMPLETE!\n');
    fprintf('========================================================\n');
    fprintf('\n');
    fprintf('Next step: Run poker_face_analysis.ipynb in Python\n');
    fprintf('\n');
else
    fprintf('\nSkipping neural decoding.\n');
    fprintf('To run it later, execute: step2a_decoding\n\n');
end
