/*
Segment independently with StarDist three ADCC channels
*/


function segment_frame(file,file2,file3) {
	open(blue_frames_dir+File.separator+file);
	selectWindow(file);
	rename("blue");
	setMinAndMax(1200, 27786);
	run("Apply LUT");
	run("Gaussian Blur...", "sigma=4");
	
	open(red_frames_dir+File.separator+file2);
	selectWindow(file2);
	rename("red");
	setMinAndMax(450, 10401);
	run("Apply LUT");
	run("Gaussian Blur...", "sigma=4");
	
	open(green_frames_dir+File.separator+file3);
	selectWindow(file3);
	rename("green");
	setMinAndMax(2900, 61621);
	run("Apply LUT");
	run("Gaussian Blur...", "sigma=4");
	
	selectWindow("blue");
	run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+"blue"+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.1', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	selectWindow("Label Image");
	saveAs("Tiff", labels_folder_blue+File.separator+file.substring(0,file.length-4)+".tif");
	close();
	roiManager("Select", 0);
	run("Select All");
	roiManager("Save", rois_folder+File.separator+file.substring(0,file.length-4)+"_blue.zip");
	roiManager("Delete");
	selectWindow("blue");
	close();
	
	selectWindow("red");
	run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+"red"+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.1', 'nmsThresh':'0.5', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	selectWindow("Label Image");
	saveAs("Tiff", labels_folder_red+File.separator+file.substring(0,file.length-4)+".tif");
	close();
	roiManager("Select", 0);
	run("Select All");
	roiManager("Save", rois_folder+File.separator+file.substring(0,file.length-4)+"_red.zip");
	roiManager("Delete");
	selectWindow("red");
	close();
	
	selectWindow("green");
	run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+"green"+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.1', 'nmsThresh':'0.5', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	selectWindow("Label Image");
	saveAs("Tiff", labels_folder_green+File.separator+file.substring(0,file.length-4)+".tif");
	close();
	roiManager("Select", 0);
	run("Select All");
	roiManager("Save", rois_folder+File.separator+file.substring(0,file.length-4)+"_green.zip");
	
	//roiManager("Select", 0);
	//run("Select All");
	//roiManager("Combine");
	//run("Create Mask");
	//run("Invert");
	//run("Divide...", "value=255");
	//saveAs("Tiff", mask_green_folder+File.separator+file.substring(0,file.length-4)+".tif");
	
	roiManager("Delete");
	selectWindow("green");
	close();
	
	//selectWindow("Mask");
	//close();
	
	run("Collect Garbage");
}

run("Collect Garbage");

sdir = getDirectory("Select the folder that contains the multichannel stack (Workspace/)...");
blue_frames_dir = sdir+File.separator+"aligned"+File.separator+"aligned_blue";
frames_blue = getFileList(blue_frames_dir);
red_frames_dir = sdir+File.separator+"aligned"+File.separator+"aligned_red";
frames_red = getFileList(red_frames_dir);
green_frames_dir = sdir+File.separator+"aligned"+File.separator+"aligned_green";
frames_green = getFileList(green_frames_dir);

rois_folder = sdir+File.separator+"rois"
File.makeDirectory(rois_folder);

labels_folder_blue = sdir+File.separator+"aligned"+File.separator+"aligned_blue"+File.separator+"labels"
labels_folder_red = sdir+File.separator+"aligned"+File.separator+"aligned_red"+File.separator+"labels"
labels_folder_green = sdir+File.separator+"aligned"+File.separator+"aligned_green"+File.separator+"labels"
//mask_green_folder = sdir+File.separator+"aligned"+File.separator+"aligned_green"+File.separator+"masks"
File.makeDirectory(labels_folder_blue);
File.makeDirectory(labels_folder_red);
File.makeDirectory(labels_folder_green);
//File.makeDirectory(mask_green_folder);

//frames_blue.length
for (i=10;i<frames_blue.length;i++){
	if(endsWith(frames_blue[i], ".tif")){
		print(frames_blue[i]);
		segment_frame(frames_blue[i],frames_red[i],frames_green[i]);
		}
}
