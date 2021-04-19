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
	getDateAndTime(year, month, week, day, hour, min, sec, msec);
	
	fileName = "/Results_" + imageTitle + "_" + day+month+year+"_"+hour+min+sec;
	saveAs("Results", filePath + fileName + ".csv");
}

//run("Show Overlay");
//run("To ROI Manager");
totROIs = roiManager("count"); // Inclusive of Probe

// Set Measurements
run("Set Measurements...", "area mean standard display redirect=None decimal=3");

for (i=1; i<totROIs; i++) {
	// Select current ROI
	currentSelection = findROIByName("^(roi_"+i+").+");
	roiManager("select", currentSelection);
	
	// Background Subtraction (if required)
	// Thresholding (if required)
	// Normalization (if required)
	
	// Add ROI Measurement to Results
	roiManager("Measure");
}

//saveResults();