print("Entering Count_Cells: " + getTitle());

// Move ROIs from Overlay into ROI Manager
run("To ROI Manager");

totROIs = roiManager("count"); // Inclusive of Probe

// Thresholding
run("8-bit");
setAutoThreshold("Default");

currentSelection = findROIByName(".*roi_background.*");
roiManager("select", currentSelection);
run("Analyze Particles...", "size=40-3000 clear summarize");
roiManager("Deselect");

for (i=1; i<totROIs-1; i++) {
	currentSelection = findROIByName(".*(roi_"+i+").+");
	roiManager("select", currentSelection);
	run("Analyze Particles...", "size=30-230 clear summarize");
}

print("Completed Count_Cells: " + getTitle());
print("Exiting Count_Cells: " + getTitle()); 
//close("*");
//close("Roi Manager");

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