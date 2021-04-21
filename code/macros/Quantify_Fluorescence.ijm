print("Entering Quantify_Fluorescence: " + getTitle());

// Move ROIs from Overlay into ROI Manager
run("To ROI Manager");

totROIs = roiManager("count"); // Inclusive of Probe & Background

// Set Measurements
run("Set Measurements...", "area mean standard display redirect=None decimal=3");

currentSelection = findROIByName(".*roi_background.*");
roiManager("select", currentSelection);
roiManager("Measure");
roiManager("Deselect");

for (i=1; i<totROIs-1; i++) {
	// Select current ROI
	currentSelection = findROIByName(".*roi_"+i+".+");
	roiManager("select", currentSelection);
	
	// Background Subtraction (if required)
	// Thresholding (if required)
	// Normalization (if required)
	
	// Add ROI Measurement to Results
	roiManager("Measure");

	// Deselect current selection
	roiManager("Deselect");
}

print("Completed Quantify_Fluorescence: " + getTitle());
print("Exiting Quantify_Fluorescence: " + getTitle()); 
close("*");
close("Roi Manager");

function findROIByName(roiName) { 
	nR = roiManager("Count"); 
 
	for (i=0; i<nR; i++) { 
		roiManager("Select", i); 
		rName = Roi.getName(); 
		if (matches(rName, roiName)) { 
			return i; 
		} 
	} 
	return -1; 
}