# Quick Start Guide - Poker Face Analysis

## TL;DR - What You Need to Do

1. **Install MATLAB toolboxes** (FieldTrip + CoSMoMVPA)
2. **Run 3 MATLAB scripts** in this order:
   - `step1_preprocessing.m` (~1 hour)
   - `step2b_markovchain.m` (~5 min)
   - `step2a_decoding.m` (~3 hours)
3. **Run the Python notebook** (`poker_face_analysis.ipynb`)

---

## Fastest Path to Results

### 1. Check if you have MATLAB
```bash
matlab -version
```

### 2. In MATLAB, install toolboxes
Download and add to path:
- **FieldTrip:** https://www.fieldtriptoolbox.org/download/
- **CoSMoMVPA:** http://www.cosmomvpa.org/download.html

```matlab
addpath('/path/to/fieldtrip')
ft_defaults
addpath(genpath('/path/to/CoSMoMVPA'))
```

### 3. Run the scripts (in MATLAB)
```matlab
% Navigate to project folder
cd /Users/ricobolos/Desktop/NEU172L_Final

% Run scripts in order (paths already fixed!)
step1_preprocessing     % ~1 hour
step2b_markovchain      % ~5 minutes
step2a_decoding         % ~3 hours (run overnight!)
```

### 4. Check you have the output files
```bash
ls derivatives/markov_chain_pred.mat
ls derivatives/*_decoding.mat | wc -l  # Should show: 62
```

### 5. Run your analysis
```bash
jupyter notebook poker_face_analysis.ipynb
```

---

## What I've Already Done For You

✅ **Fixed all MATLAB scripts** - paths are now correct
✅ **Created derivatives/ folder** - output will go here
✅ **Created Python analysis notebook** - ready to run after MATLAB
✅ **Created comprehensive guides:**
   - `RUN_MATLAB_ANALYSIS.md` - detailed MATLAB instructions
   - `ANALYSIS_GUIDE.md` - step-by-step Python analysis
   - `CLAUDE.md` - dataset documentation

---

## Files You'll Work With

### Input (what you have):
- `sub-XX/eeg/*.bdf` - Raw EEG data ✓
- `sub-XX/eeg/*_events.tsv` - Behavioral data ✓
- `participants.tsv` - Demographics ✓

### Scripts (ready to run):
- `step1_preprocessing.m` ✓ FIXED PATHS
- `step2a_decoding.m` ✓ FIXED PATHS
- `step2b_markovchain.m` ✓ FIXED PATHS

### Output (will be created):
- `derivatives/*.mat` - Processed results
- `poker_face_results.csv` - Your final analysis
- `poker_face_correlation.png` - Your figure

---

## Time Budget

| Task | Time | When to do it |
|------|------|---------------|
| Install toolboxes | 30 min | Now |
| Run step1_preprocessing | 1 hour | Today |
| Run step2b_markovchain | 5 min | Today |
| Run step2a_decoding | 3 hours | **Overnight** |
| Run Python analysis | 10 min | Tomorrow |
| **TOTAL** | **~5 hours** | **Over 2 days** |

---

## Expected Results

After running everything, you'll know:
- **Pearson's r** - correlation coefficient
- **p-value** - is it significant?
- **Scatter plot** - visualization of relationship
- **Answer to your hypothesis:** Do behaviorally predictable players have more decodable neural signals?

---

## Troubleshooting

### "Can't find FieldTrip"
```matlab
addpath('/path/to/fieldtrip')
ft_defaults
```

### "Can't find CoSMoMVPA"
```matlab
addpath(genpath('/path/to/CoSMoMVPA'))
```

### "File not found: sub-XX"
Check you're in the right directory:
```matlab
pwd  % Should show: /Users/ricobolos/Desktop/NEU172L_Final
```

### Scripts taking too long?
This is normal! Step 2a can take 3-4 hours. Run it overnight.

---

## Need More Details?

- **MATLAB issues:** See `RUN_MATLAB_ANALYSIS.md`
- **Python issues:** See `ANALYSIS_GUIDE.md`
- **Dataset questions:** See `CLAUDE.md`

---

## Questions?

Read the detailed guides above. Everything you need is documented!

Good luck! 🎲🧠
