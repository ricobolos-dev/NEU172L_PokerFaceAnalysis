# Dataset Guide

This file provides documentation about the dataset structure and how to work with the data in this repository.

## Dataset Overview

This is a BIDS-formatted EEG dataset containing neural recordings from a competitive Rock-Paper-Scissors (RPS) experiment. The dataset includes 64-channel EEG data from 62 participants (31 pairs) collected at Western Sydney University's MARCS Institute.

**Study**: Neural decoding of competitive decision-making in Rock-Paper-Scissors
**Citation**: Moerel, D., Grootswagers, T., Chin, J. L., Ciardo, F., Nijhuis, P., Quek, G. L., Smit, S. & Varlet, M. (2025). Social Cognitive And Affective Neuroscience, nsaf101. doi: https://doi.org/10.1093/scan/nsaf101
**OSF Repository**: https://doi.org/10.17605/OSF.IO/YJXKN (contains analysis code)

## Dataset Structure

### BIDS Format
This dataset follows the Brain Imaging Data Structure (BIDS) v1.0.2 specification for organizing neuroimaging data.

### Directory Organization
```
NEU172L_Final/
├── dataset_description.json       # BIDS metadata
├── participants.json               # Participant field descriptions
├── participants.tsv                # Participant demographics and metadata
├── README.txt                      # Experiment details
└── sub-XX/                         # Subject folders (sub-01 through sub-34, excluding sub-10, sub-23, sub-24)
    └── eeg/
        ├── sub-XX_task-RPS_eeg.bdf     # Raw EEG data (Biosemi BDF format)
        ├── sub-XX_task-RPS_eeg.json    # EEG acquisition metadata
        ├── sub-XX_task-RPS_events.tsv  # Event markers and behavioral data
        └── sub-XX_task-RPS_events.json # Event field descriptions
```

### Key Data Files

**EEG Data (.bdf files)**:
- Format: Biosemi BDF (binary)
- Channels: 64 EEG channels
- Sampling rate: 2048 Hz
- Reference: CMS (Common Mode Sense)
- Ground: DRL (Driven Right Leg)
- Power line frequency: 50 Hz

**Events Data (.tsv files)**:
Each trial contains:
- `onset`: Event start time (seconds)
- `duration`: Event duration (seconds)
- `onset_sample`: Event start (samples)
- `trial_num`: Trial number (1-480)
- `player1_resp`: Player 1's choice (0=no response, 1=rock, 2=paper, 3=scissors)
- `player1_rt`: Player 1's reaction time (seconds, 100s for no response)
- `player2_resp`: Player 2's choice (0=no response, 1=rock, 2=paper, 3=scissors)
- `player2_rt`: Player 2's reaction time (seconds, 100s for no response)
- `outcome`: Game outcome (1=draw, 2=player 1 wins, 3=player 2 wins)

**Participants Data (participants.tsv)**:
- Each row represents one pair of participants
- Contains demographics (age, gender, handedness) for both players
- Lists pre-processing channels that were interpolated due to noise
- Total of 31 pairs (sub-01 through sub-34, with gaps at sub-10, sub-23, sub-24)

## Working with This Dataset

### Reading EEG Data
Use MNE-Python to read Biosemi BDF files:
```python
import mne
raw = mne.io.read_raw_bdf('sub-01/eeg/sub-01_task-RPS_eeg.bdf', preload=True)
```

### Reading Event Data
Use pandas to read TSV files:
```python
import pandas as pd
events = pd.read_csv('sub-01/eeg/sub-01_task-RPS_events.tsv', sep='\t')
```

### Subject Pairing
Each "participant_id" (sub-XX) represents a PAIR of participants. Player 1 and Player 2 data are both contained within the same subject folder. The EEG data is recorded from both players simultaneously.

### Pre-processing Notes
Some channels were identified as noisy and interpolated. Check `participants.tsv` columns `player1_pre_processing_channels_fixed` and `player2_pre_processing_channels_fixed` to see which channels were affected for each participant pair.

### Experiment Details
- Task: Competitive Rock-Paper-Scissors game
- Trials per pair: 480 games
- Duration: ~1 hour per session
- Response options: Rock (1), Paper (2), Scissors (3)
- Invalid trials have response code 0 and reaction time 100s