%% Setup script for FieldTrip and CoSMoMVPA
% Run this once at the beginning of each MATLAB session
% Or add these lines to your startup.m file

% Add FieldTrip to path (go up two directories from scripts/matlab/)
addpath('../../fieldtrip')
ft_defaults

% Add CoSMoMVPA to path
addpath(genpath('../../CoSMoMVPA'))

% Verify installation
fprintf('\n==============================================\n');
fprintf('Checking FieldTrip installation...\n');
if exist('ft_preprocessing', 'file')
    fprintf('✓ FieldTrip installed correctly!\n');
    fprintf('  Location: %s\n', which('ft_preprocessing'));
else
    fprintf('✗ ERROR: FieldTrip not found!\n');
end

fprintf('\n');
fprintf('Checking CoSMoMVPA installation...\n');
if exist('cosmo_crossvalidation_measure', 'file')
    fprintf('✓ CoSMoMVPA installed correctly!\n');
    fprintf('  Location: %s\n', which('cosmo_crossvalidation_measure'));
else
    fprintf('✗ ERROR: CoSMoMVPA not found!\n');
end
fprintf('==============================================\n\n');

fprintf('Ready to run analysis scripts!\n\n');
