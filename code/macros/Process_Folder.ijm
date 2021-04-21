#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ File (label = "Macros directory", style = "directory") macros
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

processFolder(input);
saveResults(output + File.separator);

// function to save Results
function saveResults(outputPath) { 
	index = input.lastIndexOf("/");
	prefix = substring(input, index+1, input.length);
	getDateAndTime(year, month, week, day, hour, min, sec, msec);
	
	fileName = "/Results_" + prefix + "_" + day+month+year;
	saveAs("Results", output + File.separator + fileName + ".csv");
	print("Results Saved: " + fileName);
}

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Opening: " + file);
	open(input + File.separator + file);
	
	print("Invoke Draw_ROIs: " + file);
	runMacro(macros + File.separator + "Draw_ROIs.ijm");

	print("Opening: " + file);
	open(input + File.separator + file);

	print("Invoke Quantify_Fluorescence: " + file);
	runMacro(macros + File.separator + "Quantify_Fluorescence.ijm");
}