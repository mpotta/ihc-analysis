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

totROIs = roiManager("count"); // Inclusive of Probe

// Set Measurements
run("Set Measurements...", "area mean standard display redirect=None decimal=3");

for (i=1; i<totROIs; i++) {
	currentSelection = findROIByName("^(roi_"+i+").+");
	roiManager("select", currentSelection);
	// Background Subtraction
	// Thresholding
	// Normalization
	roiManager("Measure");
}
