# Immunohistochemistry Analysis

This [FIJI](https://imagej.net/Fiji "Fiji") Macro Library allows a user to perform semi-automated quantification of 2D Fluorescent Microscopy Images.

## Macro Library

### Install Macros
 1. Download the .ijm macro files. 
 2. In [Fiji](https://imagej.net/Fiji
    "Fiji"), install the macros by _Plugins > Install..._ and selecting the .ijm file. 
 3. Restart Fiji and the macro will now be an option in the _Plugins_ menu dropdown.

### Process Images
 1. Place Images of Interest from the Same Animal, Slide and SLice in a folder.
 2. Conform to the naming convention as 
```mBY15/raw_images/mBY15_Slide2_Slice4_11.5X_GFAP.tif``` for Image of Interest
```mBY15/raw_images/mBY15_Slide2_Slice4_11.5X_Control_GFAP.tif``` for Control (Healthy Tissue).
2. Import each Image into FIJI. Insert two Regions of Interest (ROIs) and save as Overlay.
```roi_0_probe``` represents the Locus of Points characterizing Probe Insertion
```roi_background``` represents Brain Tissue hypothesized to be least impacted by Surgical Insult. Used for Normalization of Intensity Levels.

### How to Use
1. Provide ```ihc-analysis/code/macros/Process_Folder.ijm``` with 
	1. ```input``` with the Input Folder Path
	2. ```output``` with the Output Folder Path
	3. ```macros``` with the Macro Library Path
2. Provide ```ihc-analysis/code/macros/Process_Folder.ijm``` with 
	3. ```totROIs``` with the number of concentric Regions of Interest (ROIs) to be drawn.
	4. ```factor``` with Magnification Factor if Calibration Metadat is available externally.
3. Run ```ihc-analysis/code/macros/Process_Folder.ijm```

## Quantitative Analysis

### Install Python Environment
 1. ```cd ihc-analysis```
 2. ```pip install venv <path-to-virtual-env>```
 3. ```source <path-to-virtual-env>/bin/activate ```
 4. ```pip install -r requirements.txt```

### How to Use
1. Provide the ```ihc-analysis/code/plots/ihc_config.cfg``` with
	1. ```DIRECTORY``` with the Folder Path to the .csv files to be processed
	2. ```SAVE_PLOTS``` with true to save generated plots
2. Run ```python ihc-analysis/code/plots/ihc_plotting.py```

## Appendix

### Immunohistochemistry Map

|	Interest	| Marker |	Antibody	|	Emission	|
|----------------|----------------|----------------|----------------|
|Neuron Bodies| Nissl |Neurotrace 647|Infrared|
|Astrocytes| GFAP |Alexa Fluor 568|Red|
|Blood Brain Barrier| IgG |Anti-Mouse 488|Green|
|Microglia	| CD68 |Alexa Fluor 405|Blue|
