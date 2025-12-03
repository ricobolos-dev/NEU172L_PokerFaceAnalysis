# Running MATLAB Analysis Scripts

## Overview
You have the raw .bdf EEG files and need to run the MATLAB processing pipeline to generate the data for your Poker Face analysis.

---

## Required Software

### 1. MATLAB Installation
- [ ] MATLAB R2019b or later recommended
- Check: Run `matlab -version` in terminal

### 2. Required Toolboxes
- [ ] **FieldTrip** (version 20240110 used in original study)
  - Download: https://www.fieldtriptoolbox.org/download/
  - Installation: Add to MATLAB path

- [ ] **CoSMoMVPA** (for decoding analysis)
  - Download: http://www.cosmomvpa.org/download.html
  - Installation: Add to MATLAB path

### 3. Install Toolboxes in MATLAB
```matlab
% Add FieldTrip to path (adjust path to where you downloaded it)
addpath('/path/to/fieldtrip')
ft_defaults

% Add CoSMoMVPA to path
addpath(genpath('/path/to/CoSMoMVPA'))
```

---

## Processing Pipeline

There are **3 scripts** that must be run **in order**:

### Step 1: Preprocessing (REQUIRED FIRST)
**Script:** `step1_preprocessing.m`
**Input:** Raw .bdf files
**Output:** Preprocessed .mat files in `derivatives/`
**Time:** ~30-60 minutes
**Toolboxes:** FieldTrip

**What it does:**
- Reads raw .bdf EEG files
- Identifies and interpolates noisy channels
- Downsamples from 2048 Hz to 256 Hz
- Epochs data around trials
- Saves to `derivatives/pair-XX_player-X_task-RPS_eeg.mat`

### Step 2a: Neural Decoding
**Script:** `step2a_decoding.m`
**Input:** Preprocessed .mat files from Step 1
**Output:** `derivatives/pair-XX_player-X_task-RPS_decoding.mat`
**Time:** ~2-4 hours (computationally intensive)
**Toolboxes:** FieldTrip + CoSMoMVPA

**What it does:**
- Decodes player choices from EEG data
- Uses Linear Discriminant Analysis (LDA)
- Performs cross-validation
- **This is what gives you NEURAL DECODABILITY scores!**

### Step 2b: Markov Chain (Can run independently)
**Script:** `step2b_markovchain.m`
**Input:** Behavioral .tsv files (already have)
**Output:** `derivatives/markov_chain_pred.mat`
**Time:** ~5-10 minutes
**Toolboxes:** None!

**What it does:**
- Analyzes behavioral patterns
- Predicts next move based on previous trials
- Tests different window sizes (5-100 trials)
- **This is what gives you BEHAVIORAL PREDICTABILITY scores!**

---

## CRITICAL: Path Configuration

The scripts expect data in `../data/` but your data is in the current directory.

**YOU MUST EDIT ALL THREE SCRIPTS** before running them!

### Change Required (Lines 13-16 in each script):

**FIND:**
```matlab
path_to_data = '../data';
```

**REPLACE WITH:**
```matlab
path_to_data = '.';  % Data is in current directory
```

### Or use the fixed versions I'll create for you (see below)

---

## Running the Scripts

### Option A: Using Fixed Versions (RECOMMENDED)
I'll create fixed versions with correct paths:
- `step1_preprocessing_FIXED.m`
- `step2a_decoding_FIXED.m`
- `step2b_markovchain_FIXED.m`

### Option B: Manual Editing
Edit the original scripts yourself.

---

## Step-by-Step Execution

### 1. Create Derivatives Folder
```bash
cd /Users/ricobolos/Desktop/NEU172L_Final
mkdir -p derivatives
```

### 2. Open MATLAB
```bash
cd /Users/ricobolos/Desktop/NEU172L_Final
matlab
```

### 3. In MATLAB, add toolboxes to path
```matlab
% Add FieldTrip (adjust to your installation path)
addpath('/Applications/MATLAB/fieldtrip-20240110')
ft_defaults

% Add CoSMoMVPA (adjust to your installation path)
addpath(genpath('/Applications/MATLAB/CoSMoMVPA'))

% Verify they're installed
which ft_preprocessing  % Should show FieldTrip path
which cosmo_crossvalidation_measure  % Should show CoSMoMVPA path
```

### 4. Run Step 1 (Preprocessing)
```matlab
% This will take 30-60 minutes
step1_preprocessing_FIXED

% Check output
ls derivatives/pair-*_player-*_eeg.mat
```

**Expected output:** 62 files (31 pairs × 2 players)

### 5. Run Step 2b (Markov Chain) - FAST!
```matlab
% This only takes ~5-10 minutes
step2b_markovchain_FIXED

% Check output
ls derivatives/markov_chain_pred.mat
```

**Expected output:** 1 file containing behavioral predictability scores

### 6. Run Step 2a (Decoding) - SLOW!
```matlab
% WARNING: This will take 2-4 HOURS!
% Consider running overnight or in background
step2a_decoding_FIXED

% Check progress (it prints pair numbers as it goes)
% Check output
ls derivatives/pair-*_player-*_decoding.mat
```

**Expected output:** 62 files (31 pairs × 2 players)

---

## Troubleshooting

### Error: "Undefined function 'ft_preprocessing'"
**Problem:** FieldTrip not in MATLAB path
**Solution:**
```matlab
addpath('/path/to/fieldtrip')
ft_defaults
```

### Error: "Undefined function 'cosmo_crossvalidation_measure'"
**Problem:** CoSMoMVPA not in MATLAB path
**Solution:**
```matlab
addpath(genpath('/path/to/CoSMoMVPA'))
```

### Error: "Cannot find file: ../data/sub-01/..."
**Problem:** Path not configured correctly
**Solution:** Make sure you changed `path_to_data = '../data';` to `path_to_data = '.';`

### Error: "Out of memory"
**Problem:** Not enough RAM for decoding
**Solution:**
- Close other applications
- Run one pair at a time (modify script loop)
- Use a computer with more RAM (16GB+ recommended)

### Warning: Missing channels
**Problem:** Some EEG channels are noisy
**Solution:** This is expected! The script handles it automatically using `participants.tsv`

---

## Parallel Processing (Optional Speed-up)

If you have MATLAB Parallel Computing Toolbox:

In `step2a_decoding_FIXED.m`, line 209, change:
```matlab
ma.nproc = 1;  % Default: single core
```
To:
```matlab
ma.nproc = 4;  % Use 4 cores (adjust based on your CPU)
```

This can speed up Step 2a significantly!

---

## After Running All Scripts

You should have:
```
derivatives/
├── pair-01_player-1_task-RPS_eeg.mat (preprocessed EEG)
├── pair-01_player-1_task-RPS_decoding.mat (neural decoding)
├── pair-01_player-2_task-RPS_eeg.mat
├── pair-01_player-2_task-RPS_decoding.mat
├── ... (for all 31 pairs × 2 players)
└── markov_chain_pred.mat (behavioral predictability)
```

Total files: 62 + 62 + 62 + 1 = **187 files**

---

## Then Run Your Poker Face Analysis!

Once you have all the derivatives:
```bash
jupyter notebook poker_face_analysis.ipynb
```

The Python notebook will read the `.mat` files and perform your correlation analysis!

---

## Time Estimates

| Step | Time | Can Run in Background? |
|------|------|----------------------|
| Step 1 (Preprocessing) | 30-60 min | Yes |
| Step 2b (Markov) | 5-10 min | No (too fast) |
| Step 2a (Decoding) | 2-4 hours | **Yes - recommended!** |
| **Total** | **3-5 hours** | |

**Recommendation:** Run Step 1 and 2b today (~40-70 min total), then run Step 2a overnight.

---

## Need Help?

1. Check MATLAB console for error messages
2. Verify toolbox installation: `which ft_preprocessing`
3. Check file paths are correct
4. Ensure you have enough disk space (~5-10 GB for derivatives)
5. Make sure MATLAB has at least 8GB RAM available

Good luck!
