
CONTACT / CITATION
------------------
Guy Perkins, University of Padova, guyantony.perkins@unipd.it, 26 10 26

This readme from this point below was partly created using generative AI.

There are two codes:

1) stormnet_co_ords_reg_to_head_model_save_snirf.m

For each newborn subject, this MATLAB script:
  1. Reads the STORMNet layout file (sub-<ID>_layout_mni.txt), which holds
     the 3D positions of sources, detectors and cranial landmarks
     (nz, iz, lpa, rpa, cz).
  2. Selects the 4D infant head model matching the subject's gestational
     age (weeks 37-42).
  3. Registers the subject's optodes to the model with an affine
     transformation (DOTHUB_affineMap) computed from the cranial landmarks,
     then snaps sources/detectors onto the scalp surface (bringPtsToSurf).
  4. Writes the registered coordinates into a copy of the subject's SNIRF
     file (*_nirs_REG.snirf) and saves them as a .mat file
     (*_reg_stormnet_coords.mat).

Subjects that already have a *_reg_stormnet_coords.mat file are skipped.
Subjects without a layout_mni.txt file are reported and skipped.

-- This code is not expected to be ran to generate the registered co-ordinates, since it requires all of the raw data snirf files, which is outside the scope of this paper.
The output of this code is then used in 2) , which are saved in .mat files loaded by the next script below.

2) plotmatlabsensorscode_210426_For_Paper

This code is explained fully below, and can be ran using the run all with the correct toolboxes and data downloaded. 

Users will need to modify the paths for where the data is stored, it is reccomended to create a duplicated set up of the file structure.

Here's the file structure the first script reads from.

E:\PadovaPostDoc\
│
├── iso2mesh-master\                          (toolbox)
├── homer3-1.80.2\                            (toolbox)
├── fdr_bh\                                   (toolbox)
├── daviolinplot\                             (toolbox)
├── slanCM\                                   (toolbox)
│   └── slanCM_Data.mat
│
├── BabyGluCo\
│   └── 4D_models_infants\
│       ├── 37-weeks\
│       │   └── AllMeshes_37weeks.mshs
│       ├── 38-weeks\
│       │   └── AllMeshes_38weeks.mshs
│       ├── 39-weeks\ ... 40-weeks\ ... 41-weeks\
│       └── 42-weeks\
│           └── AllMeshes_42weeks.mshs
│           (each .mshs is loaded with load(...,"-mat") and provides
│            gmSurfaceMesh, tenFive, etc.)
│
└── Sleeping_Memory_NewBorns\
    │
    ├── lumomat-master\                       (toolbox)
    │
    ├── Code\
    │   └── mesh_creation_test\
    │       ├── mesh-piccola-week-37-735nm.mat
    │       ├── mesh-piccola-week-38-735nm.mat
    │       ├── mesh-piccola-week-39-735nm.mat
    │       ├── mesh-piccola-week-40-735nm.mat
    │       ├── mesh-piccola-week-41-735nm.mat
    │       └── mesh-piccola-week-42-735nm.mat
    │
    ├── DATA\
    │   └── data_sensors_matfiles\            (script cd's here; contains the
    │       │                                  registered-coordinate files)
    │       └── sub-XXX...mat                 (one per subject; filename
    │                                          length = 62 characters;
    │                                          characters 5-7 = subject number;
    │                                          contains reg_stormnet_coords)
    │
    └── Probe_Registration_HDDOT_newborn_study\
        ├── eucdist-pic_subs_probes_all.mat
        ├── subs_pic_used.mat
        ├── DATA_noSSR_sub25_39_40.mat
        │
        ├── PAPER-figures-210426\
        │   └── meta_data_pic_subs_sm.mat
        │
        └── HbX_data\
            ├── HbX-039bm177-week-41-735nm_template-co-ords_Block_9_stim_B.mat
            ├── HbX-039bm177-week-41-735nm_stormnet-co-ords_Block_9_stim_B.mat
            ├── HbX-040in178-week-38-735nm_template-co-ords_Block_1_stim_A.mat
            ├── HbX-040in178-week-38-735nm_stormnet-co-ords_Block_1_stim_A.mat
            │
            └── sub25_redo_stormnetpaper_210126\
                ├── HbX-025mc163-week-37-735nm_template-co-ords_Block_9_stim_B.mat
                └── HbX-025mc163-week-37-735nm_stormnet-co-ords_Block_9_stim_B.mat

%this is commented out so is not needed, but included for context:

D:\RE-MIND\DATA-RE-MIND\DATA-original\        (only used by the commented-out
│                                              motion extraction block)
└── sub-<ID>\
    └── nirs\
        └── *.lufr                            (raw LUMO files)
```

Notes:
- **Sensor files:** the code only keeps files in `data_sensors_matfiles` whose name is exactly 62 characters long, and reads the subject number from characters 5 to 7 (for example `sub-025...`).
- **Not needed to run:** `D:\RE-MIND\...` is only used by the commented-out block, so you can ignore it when running with the provided metadata.
- **File contents:**
  - `eucdist-pic_subs_probes_all.mat` provides `euc_dist_model_src_det_stormn_src_det_allsubs_pic`.
  - `meta_data_pic_subs_sm.mat` provides `meta_data_pic_subs_sm`, including `motion_data`.
  - `DATA_noSSR_sub25_39_40.mat` provides the `DATA` struct.
  - Each `HbX-...mat` provides `HbX_gmsurface`.
- **Toolbox locations:** the toolboxes (`iso2mesh-master`, `homer3`, and so on) can sit anywhere, as long as the paths at the top of the script point to them.

==============================================================================
README
Probe registration (STORMNet) vs. template alignment error and its impact on
HD-DOT reconstructions in newborns
==============================================================================

OVERVIEW
--------
This MATLAB script reproduces the analyses and figures of the newborn
HD-DOT study on probe (cap) placement accuracy. It compares the 3D
source/detector coordinates registered on each infant (STORMNet / dothub
registration) against the coordinates of age-matched 4D infant head-mesh
templates (weeks 37-42 gestational age, "piccola"/small and "grande"/large
cap), and then relates the resulting alignment error to:
  - subject metadata (head circumference, age at acquisition, birth weight,
    body length, gestational age)
  - head motion (accelerometer / gyroscope from the LUMO system)
  - sleep state (amount of active sleep)
  - whether the mother was holding the infant
It also shows how alignment error changes HbO reconstructions (template vs.
registered coordinates) for three case-study subjects (best, median, worst).

The script is organised in cells (sections, "%%") and is meant to be run
section by section.


REQUIREMENTS
------------
MATLAB (with Statistics and Machine Learning Toolbox: corr, pdist2,
ranksum, ttest, ttest2, prctile) plus the following external toolboxes:

  - iso2mesh      : mesh handling and plotting (plotmesh_iso2)
  - lumomat       : reading LUMO .lufr files (LumoData)
  - Homer3 (1.80.2): fNIRS processing (setpaths)
  - fdr_bh        : FDR correction (D. Groppe, MATLAB File Exchange #27418)
  - daviolinplot  : violin plots
  - slanCM        : colormaps (slandarerCM, "plasma")


SETUP
-----
All paths are hard-coded to E:\PadovaPostDoc\... Before running, edit them
to match your machine:
  - dir_iso2mesh, dir_lumomat, dir_homer, fdr_bh, daviolinplot, slanCM
  - dir_mat_sensors : folder with the registered-coordinate .mat files
  - the load(...) calls for meshes, 4D models, HbX data and metadata
  - dir_data_raw    : raw data folder (only needed for the commented-out
                      motion extraction block)
Note: the script starts with "clear all; close all; clc; restoredefaultpath".


INPUT DATA (loaded by the script)
---------------------------------
  - data_sensors_matfiles/*.mat  : registered coordinates per subject
                                   (reg_stormnet_coords: source 45x3,
                                   detector 60x3)
  - mesh-piccola-week-3X-735nm.mat (X=7..2): template source/detector
                                   coordinates, piccola cap, weeks 37-42
  - 4D_models_infants/<week>-weeks/AllMeshes_<week>weeks.mshs : head meshes
  - eucdist-pic_subs_probes_all.mat : precomputed Euclidean distances
  - subs_pic_used.mat              : indices of "piccola" subjects used
  - meta_data_pic_subs_sm.mat      : metadata incl. precomputed motion data
  - DATA_noSSR_sub25_39_40.mat     : DOD data for subjects 25, 39, 40
  - HbX_data/*.mat                 : HbO/HbR reconstructions on the gray-matter
                                   surface (template vs. STORMNet coordinates)


WHAT EACH SECTION DOES
----------------------
1. Setup and subject info
   Adds toolboxes to the path; defines gestational age (weeks) and cap size
   (1 = piccola, 2 = grande) for 118 subjects.

2. Probe displacement vs. subject statistics
   Correlates mean alignment error (per subject) with head circumference,
   age at acquisition, birth weight, gestational age and length.

3. Alignment vs. motion (accelerometer / gyroscope)
   Loads precomputed motion metadata, normalises by number of time points,
   correlates with alignment error, applies FDR (fdr_bh) and plots.
   (The raw-data extraction from .lufr files is commented out because it
   needs the raw dataset.)

4. Plots of the paper correlations (2x3 figure)

5. Sleep state
   Correlates the amount of active sleep with motion and alignment error.

6. Mother holding vs. displacement
   Violin plots (daviolinplot) of motion for "holding" vs. "no holding",
   with a Wilcoxon rank-sum test and significance stars.

7. Main results: alignment error
   Builds per-subject registered source/detector arrays, computes the
   Euclidean distance to the matching template (by GA week) for each
   source/detector, produces histograms and summary stats (mean, median,
   min, max), and identifies the best, median and worst subjects
   (sub 25, 40, 39).

8. Case-study visualisation
   Plots template and registered probe positions on the infant head mesh
   with EEG 10-5 landmarks, with displacement lines colour-coded by
   magnitude, from several views. Set save_fig = 1 to save PNGs.

9. Violin plots (Figure 3)
   Best/median/worst subjects vs. whole cohort, paired t-tests with
   Bonferroni correction and significance bars.

10. Average GA models
   Per-GA-week mean and std of the registered coordinates, plotted on the
   4D model (points and bubble charts).

11. HD-DOT analysis
   Subject list with recording-selection flags (0 = excluded, 2 = use second
   file, etc.).
   Loads HbO for template vs. STORMNet coordinates (blocks: sub 25 block 9
   B, sub 39 block 9 B, sub 40 block 1 A; time point 8 s, baseline -5 to
   0 s, no SSR) and plots HbO maps and their difference.

12. Cluster analysis
   Thresholds HbO at 50% of the maximum, extracts connected clusters on the
   mesh (positive and negative), matches clusters between template and
   registered reconstructions (distance < 35 mm, amplitude ratio 0.5-2),
   and computes cluster displacement, direction and Dice overlap.
   Selected clusters per subject are plotted with arrows for the paper
   figures.

Local functions:
  - extract_clusters : connected-cluster extraction on the mesh
  - ternary          : inline conditional helper


KEY SETTINGS
------------
  - subN       : subject for the HD-DOT section (25, 39 or 40)
  - save_fig / save_HbX : 0 = do not save, 1 = save
  - time_pts   : time point (s) of the HbO map (8 s)
  - Dmax       : maximum cluster matching distance (35 mm)
  - views_fig  : camera views [azimuth elevation]


OUTPUTS
-------
  - Correlation coefficients and p-values (FDR-corrected)
  - Figures: scatter plots, violin plots, histograms, probe-displacement
    maps, HbO maps, cluster-displacement maps
  - Tables of matched-cluster displacement/Dice (positive and negative)


NOTES / CAVEATS
---------------
  - Some indexing (e.g. cluster_motion(k) selections) is manually tuned
    for subjects 25, 39 and 40.
  - Several lines are commented-out or marked "change this" (e.g. the
    MeanDisp_mm alternatives for acc/gyr/sleep).
  - Paths are Windows-specific.

==============================================================================
