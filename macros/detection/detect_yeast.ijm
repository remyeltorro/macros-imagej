/*
Use top-hat prefiltering to detect yeast cells in brightfield images, measure cell properties and export table
*/


dir = getDirectory("Which folder contains the images?");
files = getFileList(dir);

// Loop over each file in folder
for (i=0;i<files.length;i++) {
	f = files[i];
	if (endsWith(f,".tif")) {
		// Open image if finishes with .tif
		open(f);
		Stack.getDimensions(w, h, channels, slices, frames); // extract number of frames
		for (j=1;j<=frames;j++) {
			// For every frame of stack perform Top-Hat filtering
			selectWindow(f);
			Stack.setFrame(j);
			run("Gray Scale Attribute Filtering", "operation=[Top Hat] attribute=Area minimum=100 connectivity=4");
			rename(j);
		}
		
		selectWindow(f);
		close();
		// Concatenate filtered images
		run("Images to Stack", "use");
		
		// Set threshold on Top-Hat filtered image
		run("Threshold...");
		waitForUser;
		
		// Analyze and save yeasts
		run("Analyze Particles...", "size=4-Infinity pixel circularity=0.10-1.00 display exclude clear include summarize add stack");
		
		selectWindow("Summary of Stack");
		saveAs("results", dir+"image_counts.csv");
		close("image_counts.csv");
		
		selectWindow("Results");
		saveAs("results", dir+"yeast_properties.csv");
		close("Results");

		if (roiManager("Count") > 0) {
			
			roiManager("Save", dir+"RoiSetYeast.zip");
			run("Select All");
			roiManager("delete");
			
			close("ROI Manager");
			
		}
		
		selectWindow("Stack");
		close();
		
		close("Threshold");
		
	}
}
  
