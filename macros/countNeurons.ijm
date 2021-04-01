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

totROIs = roiManager("count"); // Inclusive of Probe

// Thresholding
run("8-bit");
setAutoThreshold("Default");

for (i=1; i<totROIs; i++) {
	currentSelection = findROIByName("^(roi_"+i+").+");
	roiManager("select", currentSelection);
	// Background Subtraction
	// Normalization
	// Count Cells
	run("Analyze Particles...", "size=0-Infinity circularity=0.00-1.00 clear summarize");
}

saveResults()
close("*")