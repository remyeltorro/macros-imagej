/*
Preprocess a SPT stack and launch TrackMate script
*/

function preprocess(movie,dir) {
	run("Collect Garbage");
	print(dir);
	print(substring(movie,0,lengthOf(movie)-4));
	open(dir+movie);
	Stack.setXUnit("um");
	run("Properties...", "channels=1 slices=1 frames=700 pixel_width="+pixelwidth+" pixel_height="+pixelwidth+" voxel_depth=1.0000 frame=["+timescale+" sec] global");

	run("Duplicate...", "title=slice duplicate range="+firstframe+"-700");
	selectWindow(movie);
	close();
	
	selectWindow("slice");
	rename("SPT_movie");
	
	run("Z Project...", "projection=Median");
	selectWindow("MED_SPT_movie");
	rename("median");
	run("Measure");
	mean_bg = getResult("Mean", 0);
	print(mean_bg);
	run("Clear Results");
	imageCalculator("Subtract create 32-bit stack", "SPT_movie","median");
	
	selectWindow("SPT_movie");
	close();
	
	selectWindow("median");
	close();
	
	selectWindow("Result of SPT_movie");
	rename("SPT");
	run("Add...", "value="+mean_bg+" stack");
	
	roiManager("Open", dir+substring(movie,0,lengthOf(movie)-4)+'.zip');
	run("Select All");
	roiManager("Combine");
	run("Enhance Contrast", "saturated=0.35");
	
	jythonText = File.openAsString(dir+'trackmate_script.py');
	selectWindow("SPT");

	//waitForUser;


	//print(jythonText);
	print("Launching TrackMate... ");
	call("ij.plugin.Macro_Runner.runPython",jythonText, radius+' '+threshold+' '+maxlinkingdist+' '+maxframegap+' '+gapclosingdistance+' '+tabledir+' '+movie);
	//runMacroFile(path+"trackmate_script.py", "RADIUS=7.5");
	close();
	run("Collect Garbage");
	print("Done. Proceeding to the next movie...");

	selectWindow("ROI Manager");  // remove this and the next line to see that the results table is not cleared
	run("Close"); 
	
	
}



run("Collect Garbage");

Dialog.create("Parameters");
Dialog.addString("Pixel width = ",0.133);
Dialog.addString("Frame gap = ",0.05);
Dialog.addString("First Frame = ",300);

Dialog.addString("Radius = ",0.25);
Dialog.addString("Threshold = ",60);
Dialog.addString("Maximum Linking Distance = ",0.5);
Dialog.addString("Maximum Frame Gap = ",0);
Dialog.addString("Gap Closing Distance = ",0.0);
Dialog.show();

// Image parameters
pixelwidth = Dialog.getString();
timescale = Dialog.getString();
firstframe = Dialog.getString();

// Tracking parameters
radius = Dialog.getString();
threshold = Dialog.getString();
maxlinkingdist = Dialog.getString();
maxframegap = Dialog.getString();
gapclosingdistance = Dialog.getString();


sdir = getDirectory("Select the folder that contains the SPT movies...");
movies = getFileList(sdir);

dirmacro = getInfo("macro.filepath");

// Create output folder
outputdir = sdir+File.separator+"output"+File.separator;
File.makeDirectory(outputdir);

tabledir = sdir+File.separator+"tables"+File.separator;
File.makeDirectory(tabledir);


for (i=0;i<movies.length;i++){
	if(endsWith(movies[i], ".tif")){
		print(movies[i]);
		preprocess(movies[i],sdir);
		}
}
