/*
Compute the median projection of a fluorescent stack and subtract it
*/

function preprocess(movie,dir) {
	run("Collect Garbage");

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
	//close();
	
	selectWindow("median");
	//close();
	
	selectWindow("Result of SPT_movie");
	rename("SPT");
	run("Add...", "value="+mean_bg+" stack");
		
	run("Collect Garbage");
	print("Done. Proceeding to the next movie...");	
	
}


run("Collect Garbage");

Dialog.create("Parameters");
Dialog.addString("Pixel width = ",0.133333);
Dialog.addString("Frame gap = ",0.05);
Dialog.addString("First Frame = ",300);

Dialog.addString("Radius = ",0.25);
Dialog.addString("Threshold = ",50);
Dialog.addString("Maximum Linking Distance = ",0.425);
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
