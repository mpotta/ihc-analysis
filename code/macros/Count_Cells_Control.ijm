print("Entering Count_Cells_Control: " + getTitle());

//Move ROIs from Overlay into ROI Manager
run("To ROI Manager");

totROIs = roiManager("count"); // Inclusive of Probe

// Thresholding
run("8-bit");
setAutoThreshold("Default");

currentSelection = findROIByName(".*roi_background.*");
roiManager("select", currentSelection);
run("Analyze Particles...", "size=30-300 clear summarize");
roiManager("Deselect");

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

print("Completed Count_Cells_Control: " + getTitle());
print("Exiting Count_Cells_Control: " + getTitle()); 