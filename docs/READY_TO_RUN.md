# ✅ READY TO RUN!

## Installation Complete

Both required MATLAB toolboxes are now installed:
- ✅ **FieldTrip** - in `fieldtrip/` folder
- ✅ **CoSMoMVPA** - in `CoSMoMVPA/` folder
- ✅ **Derivatives folder** - created for output

---

## Quick Start - Run Everything Now

### Option 1: Automatic (Easiest)
Open MATLAB and run:
```matlab
cd /Users/ricobolos/Desktop/NEU172L_Final
RUN_ALL_ANALYSIS
```
This will:
1. Setup toolboxes
2. Run preprocessing (~1 hour)
3. Run Markov chain (~5 min)
4. Ask if you want to run decoding (~3 hours)

### Option 2: Step-by-Step
Open MATLAB and run each step individually:
```matlab
cd /Users/ricobolos/Desktop/NEU172L_Final

% Setup (run once per session)
setup_toolboxes

% Step 1: Preprocessing (~1 hour)
step1_preprocessing

% Step 2b: Markov chain (~5 min)
step2b_markovchain

% Step 2a: Neural decoding (~3 hours - run overnight!)
step2a_decoding
```

---

## What Each Script Does

### `setup_toolboxes.m`
- Adds FieldTrip and CoSMoMVPA to MATLAB path
- Verifies installation
- **Run this first!**

### `step1_preprocessing.m`
- Reads raw .bdf EEG files
- Interpolates noisy channels
- Downsamples to 256 Hz
- **Output:** 62 preprocessed .mat files in `derivatives/`
- **Time:** ~1 hour

### `step2b_markovchain.m`
- Analyzes behavioral patterns
- Calculates how predictable each player is
- **Output:** `derivatives/markov_chain_pred.mat`
- **Time:** ~5 minutes
- **No FieldTrip needed!**

### `step2a_decoding.m`
- Decodes player choices from brain activity
- Uses machine learning (LDA)
- **Output:** 62 decoding .mat files in `derivatives/`
- **Time:** ~3 hours (RUN OVERNIGHT!)

---

## Expected Output Files

After running all scripts, you should have:

```
derivatives/
├── pair-01_player-1_task-RPS_eeg.mat          (from step1)
├── pair-01_player-1_task-RPS_decoding.mat     (from step2a)
├── pair-01_player-2_task-RPS_eeg.mat          (from step1)
├── pair-01_player-2_task-RPS_decoding.mat     (from step2a)
├── ... (repeat for all 31 pairs)
└── markov_chain_pred.mat                      (from step2b)
```

**Total files:** 187 files
- 62 preprocessed EEG files
- 62 decoding result files
- 62 more files (searchlight results)
- 1 Markov chain file

---

## Verify Installation Before Running

```matlab
cd /Users/ricobolos/Desktop/NEU172L_Final
setup_toolboxes
```

You should see:
```
==============================================
Checking FieldTrip installation...
✓ FieldTrip installed correctly!
  Location: .../fieldtrip/ft_preprocessing.m

Checking CoSMoMVPA installation...
✓ CoSMoMVPA installed correctly!
  Location: .../CoSMoMVPA/mvpa/cosmo_crossvalidation_measure.m
==============================================

Ready to run analysis scripts!
```

---

## Timeline Recommendation

### Today (Monday):
**9:00 AM** - Start preprocessing
```matlab
setup_toolboxes
step1_preprocessing  % ~1 hour
```

**10:00 AM** - Run Markov chain
```matlab
step2b_markovchain  % ~5 minutes
```

**10:10 AM** - Start neural decoding (let it run)
```matlab
step2a_decoding  % ~3 hours
```

**1:00 PM** - Check it finished successfully
```matlab
ls derivatives/*_decoding.mat | wc -l  % Should show: 62
```

**1:10 PM** - Run Python analysis!
```bash
jupyter notebook poker_face_analysis.ipynb
```

**1:30 PM** - You have your results!

---

## Quick Checks

### After step1_preprocessing:
```matlab
ls derivatives/*_eeg.mat
% Should list 62 files
```

### After step2b_markovchain:
```matlab
load('derivatives/markov_chain_pred.mat')
size(Mean_Accuracy)  % Should be: 31 x 2 x 100
```

### After step2a_decoding:
```matlab
load('derivatives/pair-01_player-1_task-RPS_decoding.mat')
decoding_accuracy{1}  % Should show structure with accuracy data
```

---

## If Something Goes Wrong

### Error: "Undefined function 'ft_preprocessing'"
**Problem:** FieldTrip not in path
**Fix:**
```matlab
addpath('/Users/ricobolos/Desktop/NEU172L_Final/fieldtrip')
ft_defaults
```

### Error: "Undefined function 'cosmo_crossvalidation_measure'"
**Problem:** CoSMoMVPA not in path
**Fix:**
```matlab
addpath(genpath('/Users/ricobolos/Desktop/NEU172L_Final/CoSMoMVPA'))
```

### Scripts run but no output files
**Problem:** Check derivatives folder exists
**Fix:**
```matlab
mkdir derivatives
```

### Out of memory errors
**Problem:** Not enough RAM
**Fix:**
- Close other applications
- Process one pair at a time (modify loop in scripts)

---

## After MATLAB Completes

Run your Python analysis:
```bash
cd /Users/ricobolos/Desktop/NEU172L_Final
jupyter notebook poker_face_analysis.ipynb
```

Execute all cells and you'll get:
- ✓ Correlation coefficient (Pearson's r)
- ✓ P-value and significance test
- ✓ Scatter plot visualization
- ✓ Answer to your hypothesis!

---

## You're All Set!

Everything is installed and configured. Just open MATLAB and run:
```matlab
cd /Users/ricobolos/Desktop/NEU172L_Final
RUN_ALL_ANALYSIS
```

Good luck! 🧠🎲
