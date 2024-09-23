// Author: Rémy Torro (Laboratoire Adhésion & Inflammation)
// The macro will segment fluorescent cells, loop over every
// ROI and perform a measurement of the edge intensity.
// Version: 0.1
// Date: 01/05/2023

setAutoThreshold("Default dark");
run("Threshold...");
waitForUser;
run("Analyze Particles...", "size=40-Infinity display exclude clear include summarize add");


// Donught measurement
nbr_rois = roiManager("count");
print(nbr_rois);
roiManager("show none");
for (i=0; i<roiManager("count"); ++i) {
	
	print(i);
	roiManager("Select", i);
	roi_name = Roi.getName;
	// Downscaled version
	run("Scale... ", "x=0.9 y=0.9 centered centered");
	Roi.setName("ROI_downscaleImage");
	roiManager("Add");
	
	// Donught
	roiManager("select", newArray(i, nbr_rois));
	roiManager("XOR");
	roiManager("add");
	
	roiManager("deselect");
	roiManager("Select", nbr_rois+1);
	roiManager("measure");
	roiManager("delete");
	
	roiManager("Select", nbr_rois);
	roiManager("delete");
}
	
