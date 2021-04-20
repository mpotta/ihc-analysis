totROIs = 10 // # of concentric circles
firstRadius = 50
incRadius = 50 // radius step-size

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

// Load Overlay
run("Show Overlay");

// Move Probe and Background ROIs from Overlay into ROI Manager
run("To ROI Manager");

// Retrieve Probe
roiManager("Select", findROIByName("roi_0_probe"));
getSelectionCoordinates(x, y);

// Set Magnification Factor from Calibration File
//factor = 0.990097;
//run("Set Scale...", "distance=1 known="+factor+" unit=um");

// Define the focal point of the sequence.
x1 = x[0];
y1 = y[0];

xc = (x[0]+x[1])/2;
yc = (y[0]+y[1])/2;

x2 = x[1];
y2 = y[1];

length = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));

// Draw the circles.
for (i=0; i<totROIs; i++) {
	// Define the radius for the current circle
	r = firstRadius + i*incRadius;
	
	// Overlay functions use bounding boxes
	// https://imagej.nih.gov/ij/developer/macro/functions.html#Overlay

    //makeOval(x1 - r, y1 - r, r * 2, r * 2);
    //roiManager("Add");
    makeOval(x2 - r, y2 - r, r * 2, r * 2);
    roiManager("Add");
    makeRotatedRectangle(x1, y1, x2, y2, r * 2);
    roiManager("Add");

    // Merge ROI
    count = roiManager("count");
    //currentSelection = newArray(count-3,count-2,count-1);
	currentSelection = newArray(count-2,count-1);
	roiManager("select", currentSelection);
	roiManager("Combine");
	roiManager("Add");
	roiManager("delete");

	roiManager("Select", findROIByName("^(?!roi_).+"));
	roiManager("Rename", "roi_full_"+(i+1)+"_"+r);
	
	if (i!=0) {

		previousROI = findROIByName("^(roi_full_"+i+").+");
		currentROI = findROIByName("^(roi_full_"+(i+1)+").+");
		currentSelection = newArray(previousROI, currentROI);
		roiManager("select", currentSelection);
		roiManager("XOR");
		roiManager("Add");

		// Rename ROI
		roiManager("Select", findROIByName("^(?!roi_).+"));
		roiManager("Rename", "roi_"+(i+1)+"_"+r);
		roiManager("deselect")
	}
}

// ROI Clean up
roiManager("Select", findROIByName("^(roi_full_1).+"));
roiManager("Rename", "roi_1_"+firstRadius);

while(findROIByName("^(roi_full_).+") >= 0)
{
	roiManager("select", findROIByName("^(roi_full_).+"));
	roiManager("delete");
}

// Show the result
Overlay.show();

// Save ROIs to .tif
run("Save");