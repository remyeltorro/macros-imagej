/*
Detect NK cells from CFSE and PI fluorescence channels with bleach correction and direct thresholding
*/

function action(file,path){
	
	open(sdir+file);
	run("Split Channels");
	selectWindow("C1-"+file);
	close();
	selectWindow("C4-"+file);
	close();
	selectWindow("C2-"+file);
	rename("red");
	selectWindow("C3-"+file);
	rename("green");
	
	selectWindow("green");
	run("Bleach Correction", "correction=[Histogram Matching]");
	selectWindow("DUP_green");
	run("Threshold...");
	waitForUser;
	run("Analyze Particles...", "  show=Masks display summarize stack");

	selectWindow("Mask of DUP_green");
	run("Divide...", "value=255 stack");

	selectWindow("Summary of DUP_green");
	saveAs("Results", path+"green_areas.csv");

	selectWindow("red");
	imageCalculator("Multiply create 32-bit stack", "red","Mask of DUP_green");
	selectWindow("Result of red");
	rename("red_masked");
	run("Threshold...");
	waitForUser;

	run("Analyze Particles...", "display summarize stack");
	selectWindow("Summary of red_masked");
	saveAs("Results", path+"red_areas.csv");

	selectWindow("Mask of DUP_green");
	close();
	selectWindow("DUP_green");
	close();
	selectWindow("red");
	close();
	selectWindow("green");
	close();
	selectWindow("green_areas.csv");
	close();
	selectWindow("red_areas.csv");
	close();
		
}


run("Collect Garbage");
sdir = getDirectory("Select folder that contains the stack...");
files = getFileList(sdir);

for (i=0;i<files.length;i++){
	if(endsWith(files[i], ".tif")){
		print(files[i]);
		action(files[i],sdir);
		}
}
