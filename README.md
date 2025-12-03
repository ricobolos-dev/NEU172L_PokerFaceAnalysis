# The "Poker Face" Analysis

**Neural Decoding of Competitive Decision-Making in Rock-Paper-Scissors**

**Authors:** Rico Bolos, Shelly Chen, Yichen Zeng

---

## Project Overview

This project investigates whether players who are behaviorally easy to predict (i.e., play in patterns) are also "easier to read" neurally. We correlate **behavioral predictability** (Markov chain accuracy) with **neural decodability** (EEG decoding accuracy) in a competitive Rock-Paper-Scissors task.

**Hypothesis:** Players with high behavioral predictability will also have higher neural decoding accuracy, suggesting that behavioral patterns are supported by distinct neural patterns.

---

## Dataset

This analysis uses the **Neural Decoding of Competitive Decision-Making in Rock-Paper-Scissors** dataset:

- **62 participants** (31 pairs) played 480 games of Rock-Paper-Scissors
- **64-channel EEG** recorded during gameplay
- **Dataset:** [OpenNeuro ds006761](https://openneuro.org/datasets/ds006761)
- **Paper:** Moerel et al. (2025). *Social Cognitive And Affective Neuroscience*, nsaf101.
- **OSF Repository:** https://doi.org/10.17605/OSF.IO/YJXKN

---

## Repository Contents

### Analysis Scripts
- `poker_face_analysis.ipynb` - Main Python analysis notebook (correlation analysis)
- `step1_preprocessing.m` - MATLAB script for EEG preprocessing
- `step2a_decoding.m` - MATLAB script for neural decoding analysis
- `step2b_markovchain.m` - MATLAB script for behavioral predictability analysis

### Helper Scripts
- `setup_toolboxes.m` - MATLAB setup and verification
- `RUN_ALL_ANALYSIS.m` - Master script to run complete MATLAB pipeline

### Documentation
- `READY_TO_RUN.md` - Quick start guide
- `QUICKSTART.md` - Fast overview
- `RUN_MATLAB_ANALYSIS.md` - Detailed MATLAB instructions
- `ANALYSIS_GUIDE.md` - Python analysis walkthrough
- `CLAUDE.md` - Dataset documentation
- `FinalProposal.pdf` - Original project proposal

---

## Getting Started

### Prerequisites

**Software:**
- MATLAB (R2019b or later)
- Python 3.7+ with Jupyter Notebook
- Git

**MATLAB Toolboxes:**
- [FieldTrip](https://www.fieldtriptoolbox.org/download/) (EEG analysis)
- [CoSMoMVPA](http://www.cosmomvpa.org/download.html) (multivariate pattern analysis)

**Python Packages:**
```bash
pip install numpy pandas matplotlib seaborn scipy
```

---

## Installation

### 1. Clone this repository
```bash
git clone https://github.com/YOUR_USERNAME/NEU172L_Final.git
cd NEU172L_Final
```

### 2. Download the dataset
**Important:** The raw EEG data files (.bdf) are NOT included in this repository (they're 80GB total!).

Download the dataset from [OpenNeuro](https://openneuro.org/datasets/ds006761):
```bash
# Using DataLad (recommended)
datalad install https://github.com/OpenNeuroDatasets/ds006761.git
datalad get sub-*/eeg/*.bdf

# Or download manually from OpenNeuro website
```

Place the `sub-XX/` folders in the project directory.

### 3. Install MATLAB toolboxes
```bash
# FieldTrip
git clone https://github.com/fieldtrip/fieldtrip.git

# CoSMoMVPA
git clone https://github.com/CoSMoMVPA/CoSMoMVPA.git
cd CoSMoMVPA
make install
cd ..
```

### 4. Create derivatives folder
```bash
mkdir derivatives
```

---

## Running the Analysis

### Option 1: Automatic (Recommended)
Open MATLAB and run:
```matlab
cd /path/to/NEU172L_Final
RUN_ALL_ANALYSIS
```

### Option 2: Step-by-Step

#### MATLAB Processing (~4 hours total)
```matlab
% Setup toolboxes
setup_toolboxes

% Step 1: Preprocess raw EEG data (~1 hour)
step1_preprocessing

% Step 2b: Calculate behavioral predictability (~5 minutes)
step2b_markovchain

% Step 2a: Perform neural decoding (~3 hours - run overnight!)
step2a_decoding
```

#### Python Analysis (~10 minutes)
```bash
jupyter notebook poker_face_analysis.ipynb
```

Execute all cells to get your results!

---

## Expected Output

After running the complete pipeline:

### MATLAB Outputs (in `derivatives/`)
- `pair-XX_player-X_task-RPS_eeg.mat` - Preprocessed EEG (62 files)
- `pair-XX_player-X_task-RPS_decoding.mat` - Neural decoding results (62 files)
- `markov_chain_pred.mat` - Behavioral predictability scores

### Python Outputs
- `poker_face_results.csv` - Raw correlation data
- `poker_face_summary.csv` - Statistical summary
- `poker_face_correlation.png` - Scatter plot visualization

---

## Results Preview

The analysis calculates:
- **Pearson's r** - Correlation coefficient between behavioral predictability and neural decodability
- **p-value** - Statistical significance
- **95% Confidence Intervals**
- **Effect size interpretation**

Results will show whether behaviorally predictable players ("transparent" strategies) also have more decodable neural signals.

---

## Project Structure

```
NEU172L_Final/
├── README.md                           # This file
├── poker_face_analysis.ipynb           # Main analysis notebook
├── step1_preprocessing.m               # EEG preprocessing
├── step2a_decoding.m                   # Neural decoding
├── step2b_markovchain.m                # Behavioral analysis
├── setup_toolboxes.m                   # MATLAB setup
├── RUN_ALL_ANALYSIS.m                  # Master script
├── *.md                                # Various guides
├── sub-XX/                             # Raw data (NOT in repo, download separately)
│   └── eeg/
│       ├── *.bdf                       # Raw EEG files (2-3GB each)
│       ├── *_events.tsv                # Behavioral data
│       └── *_eeg.json                  # Metadata
├── fieldtrip/                          # FieldTrip toolbox (install separately)
├── CoSMoMVPA/                          # CoSMoMVPA toolbox (install separately)
└── derivatives/                        # Processed data (generated by scripts)
    ├── *_eeg.mat                       # Preprocessed EEG
    ├── *_decoding.mat                  # Decoding results
    └── markov_chain_pred.mat           # Behavioral predictability
```

---

## Timeline

| Step | Time | Notes |
|------|------|-------|
| Install toolboxes | 30 min | One-time setup |
| Preprocessing | 1 hour | Run step1_preprocessing.m |
| Markov chain | 5 min | Run step2b_markovchain.m |
| Neural decoding | 3 hours | Run step2a_decoding.m (overnight!) |
| Python analysis | 10 min | Run poker_face_analysis.ipynb |
| **Total** | **~5 hours** | Spread over 1-2 days |

---

## Troubleshooting

See detailed guides:
- `READY_TO_RUN.md` - Complete setup instructions
- `RUN_MATLAB_ANALYSIS.md` - MATLAB troubleshooting
- `ANALYSIS_GUIDE.md` - Python notebook guide

Common issues:
- **"Undefined function 'ft_preprocessing'"** → Run `setup_toolboxes.m`
- **"Out of memory"** → Close other applications, need 8GB+ RAM
- **"File not found: sub-XX"** → Download the dataset from OpenNeuro

---

## Citation

If you use this analysis approach, please cite:

**Original Dataset:**
```
Moerel, D., Grootswagers, T., Chin, J. L., Ciardo, F., Nijhuis, P., Quek, G. L.,
Smit, S. & Varlet, M. (2025). Neural decoding of competitive decision-making in
Rock-Paper-Scissors. Social Cognitive And Affective Neuroscience, nsaf101.
doi: https://doi.org/10.1093/scan/nsaf101
```

---

## License

- **Code:** MIT License (this repository)
- **Dataset:** CC0 (OpenNeuro ds006761)

---

## Contact

For questions about this analysis:
- Rico Bolos
- Shelly Chen
- Yichen Zeng

For questions about the original dataset, see the [OSF repository](https://doi.org/10.17605/OSF.IO/YJXKN).

---

## Acknowledgments

- Original dataset authors: Moerel et al. (2025)
- FieldTrip toolbox developers
- CoSMoMVPA toolbox developers
- OpenNeuro for data hosting
