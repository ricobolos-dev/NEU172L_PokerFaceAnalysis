# Poker Face Analysis - Step-by-Step Guide

## Overview
This guide walks you through performing the "Poker Face" analysis: correlating neural decodability with behavioral predictability in the Rock-Paper-Scissors dataset.

---

## Prerequisites Checklist

### 1. Required Software
- [ ] Python 3.7+ installed
- [ ] Jupyter Notebook or JupyterLab installed
- [ ] Required Python packages:
  ```bash
  pip install numpy pandas matplotlib seaborn scipy
  ```

### 2. Required Data Files
You need the **output files** from the authors' MATLAB processing pipeline, not just the scripts.

**Critical:** The `derivatives/` folder with these files:
- [ ] `derivatives/markov_chain_pred.mat` (from step2b_markovchain.m)
- [ ] `derivatives/pair-01_player-1_task-RPS_decoding.mat` (and all other pairs/players)

---

## Step-by-Step Instructions

### **STEP 1: Get the Processed Data**

You have two options:

#### **Option A: Download from OSF (RECOMMENDED)**
1. Visit the OSF repository: https://doi.org/10.17605/OSF.IO/YJXKN
2. Navigate to the "Files" section
3. Download the `derivatives/` folder
4. Place it in your project directory: `/Users/ricobolos/Desktop/NEU172L_Final/derivatives/`

#### **Option B: Run MATLAB Scripts**
If you have MATLAB with required toolboxes (FieldTrip, CoSMoMVPA):
1. Ensure raw .bdf EEG files are in the correct location
2. Run the preprocessing and analysis scripts:
   ```matlab
   % In MATLAB:
   cd /Users/ricobolos/Desktop/NEU172L_Final
   step2a_decoding
   step2b_markovchain
   ```
3. This will create the `derivatives/` folder with all required .mat files

---

### **STEP 2: Verify Data Files**

Check that you have all required files:

```bash
# In terminal:
cd /Users/ricobolos/Desktop/NEU172L_Final

# Check if derivatives folder exists
ls -la derivatives/

# Count decoding files (should be 62 files for 31 pairs × 2 players)
ls derivatives/pair-*_player-*_decoding.mat | wc -l

# Check markov file exists
ls derivatives/markov_chain_pred.mat
```

**Expected output:**
- `derivatives/` folder exists
- 62 decoding files (one per player)
- 1 markov_chain_pred.mat file

---

### **STEP 3: Open the Analysis Notebook**

```bash
# Navigate to project directory
cd /Users/ricobolos/Desktop/NEU172L_Final

# Launch Jupyter Notebook
jupyter notebook poker_face_analysis.ipynb
```

Or open it in your preferred environment (VS Code, JupyterLab, etc.)

---

### **STEP 4: Run the Analysis**

Execute the notebook cells in order:

#### **Cell 1: Setup and Imports**
- Imports all required Python libraries
- Sets up plotting parameters
- **Expected output:** "✓ Libraries imported successfully"

#### **Cell 2: Set Paths**
- Defines paths to data files
- **Checks if derivatives folder exists**
- **If this fails:** You need to complete Step 1 above
- **Expected output:** "✓ Data path set" and "✓ Derivatives folder exists"

#### **Cell 3: Load Behavioral Predictability**
- Reads `markov_chain_pred.mat`
- Extracts `Mean_Accuracy` matrix
- **Expected output:** Shape (31, 2, 100) = 31 pairs × 2 players × 100 windows

#### **Cell 4: Extract Behavioral Scores**
- Averages across window sizes
- Creates 62 individual predictability scores
- **Expected output:** Mean, std, and range of behavioral predictability

#### **Cell 5: Load Neural Decodability**
- Reads all 62 decoding files
- Extracts "Self Response" decoding accuracy
- Finds peak accuracy in 0-500ms window
- **Expected output:** 62 neural decodability scores

#### **Cell 6: Create DataFrame**
- Combines behavioral and neural data
- **Expected output:** DataFrame with 62 rows (one per player)

#### **Cell 7: Summary Statistics**
- Shows descriptive statistics
- **Check:** All values should be reasonable (between 0 and 1)

#### **Cell 8: Correlation Analysis**
- **KEY ANALYSIS:** Calculates Pearson's r
- Reports p-value and confidence intervals
- **Expected output:**
  - Pearson's r value
  - p-value (significance)
  - 95% confidence interval
  - Effect size interpretation

#### **Cell 9: Visualization**
- Creates scatter plot
- Adds regression line
- Saves figure as `poker_face_correlation.png`
- **Expected output:** Beautiful scatter plot showing correlation

#### **Cell 10: Interpretation**
- Interprets results based on p-value and r
- Tests your hypothesis
- **Expected output:** Clear interpretation of findings

#### **Cell 11: Export Results**
- Saves data to CSV files
- **Output files:**
  - `poker_face_results.csv` (raw data)
  - `poker_face_summary.csv` (statistics)
  - `poker_face_correlation.png` (figure)

---

### **STEP 5: Interpret Your Results**

Based on the correlation analysis, you'll get one of three outcomes:

#### **Outcome 1: Positive Correlation (r > 0, p < 0.05)**
✓ **Hypothesis SUPPORTED**
- Players with high behavioral predictability have higher neural decodability
- Behavioral patterns are reflected in neural patterns
- "Transparent" strategies have "transparent" brain signals

#### **Outcome 2: No Correlation (p ≥ 0.05)**
○ **No significant relationship**
- Behavioral and neural measures are dissociated
- Behavioral patterns may not be directly reflected in neural signals
- Other factors may be at play

#### **Outcome 3: Negative Correlation (r < 0, p < 0.05)**
✗ **Opposite of prediction**
- Behaviorally predictable players have LESS decodable neural signals
- May suggest compensatory neural mechanisms
- Interesting finding worth investigating further

---

## Troubleshooting

### Problem: "derivatives/ folder not found"
**Solution:** Complete Step 1 - download the processed data from OSF

### Problem: "Markov chain file not found"
**Solution:** Ensure `derivatives/markov_chain_pred.mat` exists

### Problem: "Decoding file not found for pair-XX"
**Solution:** Some pairs (10, 23, 24) are excluded - this is expected. Other missing files indicate incomplete data download.

### Problem: Import errors (e.g., "No module named 'scipy'")
**Solution:** Install required packages:
```bash
pip install numpy pandas matplotlib seaborn scipy
```

### Problem: "Cannot read .mat file" or structure errors
**Solution:** Ensure you downloaded the correct MATLAB output files (not the raw data or scripts)

### Problem: Different number of players than expected
**Solution:**
- Expected: 62 players (31 pairs × 2)
- Pairs 10, 23, 24 are excluded (documented in original paper)
- Should have 31 pairs, not 34

---

## What to Include in Your Report

1. **Hypothesis statement** (from your proposal)
2. **Methods summary:**
   - How behavioral predictability was calculated (Markov chain)
   - How neural decodability was calculated (peak accuracy in 0-500ms)
   - Statistical test used (Pearson's r)
3. **Results:**
   - Correlation coefficient with p-value and CI
   - Scatter plot (poker_face_correlation.png)
   - Effect size interpretation
4. **Interpretation:**
   - Whether hypothesis was supported
   - What this means for the relationship between behavior and neural signals
5. **Limitations and future directions**

---

## Output Files

After running the analysis, you'll have:

| File | Description |
|------|-------------|
| `poker_face_results.csv` | Raw data (62 rows with behavioral and neural scores) |
| `poker_face_summary.csv` | Summary statistics (r, p-value, CI, etc.) |
| `poker_face_correlation.png` | Publication-quality figure |

---

## Timeline Estimate

- **Step 1 (Get data):** 15-30 minutes (download time depends on connection)
- **Step 2 (Verify):** 2 minutes
- **Step 3 (Open notebook):** 1 minute
- **Step 4 (Run analysis):** 5-10 minutes (mostly loading .mat files)
- **Step 5 (Interpret):** 15-30 minutes (understanding results)

**Total:** ~1 hour

---

## Contact for Help

If you encounter issues:
1. Check the original paper's methods section for clarification
2. Visit the OSF repository for documentation
3. Check MATLAB script comments for data structure details

Good luck with your analysis!
