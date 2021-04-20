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

function saveResults() { 
	filePath = getDirectory("current");
	imageTitle = getTitle();
	index = imageTitle.indexOf(".");
	prefix = substring(imageTitle, 0, index);
	getDateAndTime(year, month, week, day, hour, min, sec, msec);
	
	fileName = "/Results_" + prefix + "_" + day+month+year+"_"+hour+min+sec;
	saveAs("Results", filePath + fileName + ".csv");
}

// Load Overlay
run("Show Overlay");

// Move ROIs from Overlay into ROI Manager
//run("To ROI Manager");

totROIs = roiManager("count"); // Inclusive of Probe & Background

// Set Measurements
run("Set Measurements...", "area mean standard display redirect=None decimal=3");

currentSelection = findROIByName("^(roi_background)");
roiManager("select", currentSelection);
roiManager("Measure");
roiManager("Deselect");

for (i=1; i<totROIs-1; i++) {
	// Select current ROI
	currentSelection = findROIByName("^(roi_"+i+").+");
	roiManager("select", currentSelection);
	
	// Background Subtraction (if required)
	// Thresholding (if required)
	// Normalization (if required)
	
	// Add ROI Measurement to Results
	roiManager("Measure");

	// Deselect current selection
	roiManager("Deselect");
}

//saveResults();