# Immunohistochemistry Analysis

This [FIJI](https://imagej.net/Fiji "Fiji") Macro Library allows a user to perform semi-automated quantification of 2D Fluorescent Microscopy Images.

![](IHCAnalysisDemo.gif)

## Macro Library

### Install Macros
 1. Download the .ijm macro files. 
 2. In [Fiji](https://imagej.net/Fiji
    "Fiji"), install the macros by _Plugins > Install..._ and selecting the .ijm file. 
 3. Restart Fiji and the macro will now be an option in the _Plugins_ menu dropdown.

### Process Images
 1. Place Images of Interest from the Same Animal, Slide and Slice in a folder of the form ```mBY15_Slide2_Slice4```
 2. Conform to the naming convention as 
```mBY15/raw_images/mBY15_Slide2_Slice4_11.5X_GFAP.tif``` for Image of Interest
```mBY15/raw_images/mBY15_Slide2_Slice4_11.5X_Control_GFAP.tif``` for Control (Healthy Tissue).
2. For the Fluorescence markers, import each image into FIJI. Insert two Regions of Interest (ROIs) and save as Overlay.
```roi_0_probe``` represents the Locus of Points characterizing probe insertion
```roi_background``` represents brain tissue hypothesized to be least impacted by Surgical Insult. Used for Normalization of Intensity Levels.
3. For the Cell Counter, import each experiment and control images into FIJI. Insert two Regions of Interest (ROIs) and save as Overlay.
```roi_0_probe``` represents the Locus of Points characterizing probe insertion. Add only to the experiment image.
```roi_background``` represents brain tissue in the healthy hemisphere. Add only to the control image.
5. Apply Calibration to all Images by setting scale in FIJI -> Analyze Menu -> Set Scale

### How to Use Fluorescence Quantification
1. Provide ```ihc-analysis/code/macros/Process_Folder_Fluorescence.ijm``` 
	1. ```input``` with the Input Folder Path
	2. ```output``` with the Output Folder Path
	3. ```macros``` with the Macro Library Path if not installed
2. Provide ```ihc-analysis/code/macros/Draw_ROIs.ijm``` with
	1. ```totROIs``` with the number of concentric Regions of Interest (ROIs) to be drawn
	2. ```step``` with the step-size used for drawing concentric ROIs
	3. ```factor``` [Optional] with Magnification Factor if Calibration Metadata is available externally
3. Run ```ihc-analysis/code/macros/Process_Folder_Fluorescence.ijm``` for each folder of the form ```mBY15_Slide2_Slice4```
4. This will generate results file of the form ```ResultsFluorescence_mBY15_Slide2_Slice4_8056.csv``` in the Output path

### How to Use Cell Counter
1. Provide ```ihc-analysis/code/macros/Process_Folder_Count_Cells.ijm``` 
	1. ```input``` with the Input Folder Path
	2. ```output``` with the Output Folder Path
	3. ```macros``` with the Macro Library Path if not installed
2. Provide ```ihc-analysis/code/macros/Count_Cells.ijm``` and ```ihc-analysis/code/macros/Count_Cells_Control.ijm```
	1. ```size``` with the Size Range. Default is set to ```30-3000 μm²```
3. Run ```ihc-analysis/code/macros/Process_Folder_Count_Cells.ijm``` for each folder of the form ```mBY15_Slide2_Slice4```
4. This will generate results file of the form ```SummaryCellCount_mBY15_Slide2_Slice4_8056.csv``` in the Output path

## Quantitative Analysis

### Install Python Environment
 1. ```cd ihc-analysis```
 2. ```pip install venv <path-to-virtual-env>```
 3. ```source <path-to-virtual-env>/bin/activate ```
 4. ```pip install -r requirements.txt```

### How to Use
1. Provide the ```ihc-analysis/code/plots/ihc_config.cfg``` with
	1. ```DIRECTORY``` with the Folder Path to the .csv files to be processed
	2. ```STEP``` with the step-size used for drawing concentric ROIs
2. Run ```python ihc-analysis/code/plots/ihc_plotting.py```

## Appendix

### Immunohistochemistry Map

|	Interest	| Marker |	Antibody	|	Emission	|
|----------------|----------------|----------------|----------------|
|Neuron Bodies| Nissl |Neurotrace 647|Infrared|
|Astrocytes| GFAP |Alexa Fluor 568|Red|
|Blood Brain Barrier| IgG |Anti-Mouse 488|Green|
|Microglia	| CD68 |Alexa Fluor 405|Blue|
