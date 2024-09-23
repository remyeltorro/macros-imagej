/*
Preprocess a SPT stack and launch TrackMate script
*/


function track(movie,dir) {
	
	print("Folder: ",dir);

	// Load movie and calibrate
	open(dir+movie);
	Stack.setXUnit("um");
	Stack.setYUnit("um");
	run("Properties...", "channels=1 slices=1 frames=700 pixel_width="+pixelwidth+" pixel_height="+pixelwidth+" voxel_depth=1.0000 frame=["+timescale+" sec] global");

	// Remove the early frames before we reach single molecular regime
	run("Duplicate...", "title=slice duplicate range="+firstframe+"-700");
	selectWindow(movie);
	close();
	selectWindow("slice");
	rename("SPT_movie");
	run("32-bit");

	// Build static background
	run("Z Project...", "projection=Median");
	selectWindow("MED_SPT_movie");
	rename("median");
	run("Measure");
	mean_bg = getResult("Mean", 0);
	print("Mean background intensity = ",mean_bg);
	run("Clear Results");
	imageCalculator("Subtract create 32-bit stack", "SPT_movie","median");
	
	selectWindow("SPT_movie");
	close();
	
	selectWindow("median");
	close();
	
	selectWindow("Result of SPT_movie");
	rename("SPT");
	run("Add...", "value="+mean_bg+" stack");
	run("Enhance Contrast", "saturated=0.35");
	
	// Load Python tracking instructions 
	jythonText = File.openAsString(dir+'trackmate_script.py');
	selectWindow("SPT");
	print("Launching TrackMate... ");
	call("ij.plugin.Macro_Runner.runPython",jythonText, radius+' '+threshold+' '+maxlinkingdist+' '+maxframegap+' '+gapclosingdistance+' '+tabledir+' '+movie);
	close();
	
	print("Done. Proceeding to the next movie...");
	run("Collect Garbage");
	
}

run("Collect Garbage");

// Dialog box to set tracking parameters
Dialog.create("Parameters");
Dialog.addString("Pixel width [um] = ",0.133);
Dialog.addString("Frame gap [s] = ",0.05);
Dialog.addString("First Frame [frame] = ",300);

Dialog.addString("Blob radius [um] = ",0.25);
Dialog.addString("Threshold [a.u.] = ",70);
Dialog.addString("Maximum Linking Distance [um] = ",0.425);
Dialog.addString("Maximum Frame Gap [frame] = ",0);
Dialog.addString("Gap Closing Distance [um] = ",0.0);
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

// Load folder containing the movies

sdir = getDirectory("Select the folder that contains the SPT movies...");
movies = getFileList(sdir);
dirmacro = getInfo("macro.filepath");

// Create output folder
outputdir = sdir+File.separator+"output"+File.separator;
File.makeDirectory(outputdir);

// Create table folder
tabledir = sdir+File.separator+"tables"+File.separator;
File.makeDirectory(tabledir);


for (i=0;i<movies.length;i++){
	if(endsWith(movies[i], ".tif")){
		print("Processing movie ",movies[i]);
		track(movies[i],sdir);
		}
}

print("Done.");
