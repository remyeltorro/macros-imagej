Dialog.create("Parameters");
Dialog.addMessage("Image calibration:", 15);
Dialog.addString("Pixel width = ",0.3112);
Dialog.addString("Frame gap = ",295);
Dialog.addMessage("Analysis options:", 15);

Dialog.addCheckbox("Mask the first red channel", "True")
Dialog.addNumber("Minimum threshold = ",230);
Dialog.addNumber("Maximum threshold = ",65535);
Dialog.addString("Circularity = ","0.-1.0");
Dialog.addString("Size = ","0-100000");
Dialog.addCheckbox("Mask the green channel ", "True")
Dialog.addMessage("If masking of the green channel:", 10);
Dialog.addNumber("Minimum threshold = ",4324);
Dialog.addNumber("Maximum threshold = ",65535);
Dialog.addString("Circularity = ","0.-1.0");
Dialog.addString("Size = ","0-100000");
Dialog.addCheckbox("Mask the blue channel ", "True")
Dialog.addMessage("If masking of the blue channel:", 10);
Dialog.addNumber("Minimum threshold = ",543);
Dialog.addNumber("Maximum threshold = ",65535);
Dialog.addString("Circularity = ","0.7-1.0");
Dialog.addString("Size = ","0-70");
Dialog.addCheckbox("Export mask ", "True")
Dialog.addCheckbox("Export masked blue ", "True")
Dialog.addMessage("Tracking parameters:", 15);
Dialog.addString("Radius = ",7.5);
Dialog.addString("Threshold = ",0.5);
Dialog.addString("Maximum Linking Distance = ",8.0);
Dialog.addString("Maximum Frame Gap = ",5);
Dialog.addString("Gap Closing Distance = ",8.0);
Dialog.show();

// Image parameters
pixelwidth = Dialog.getString();
timescale = Dialog.getString();

// Analysis parameters
maskred = Dialog.getCheckbox();
thresh_low_red = Dialog.getNumber();
thresh_high_red = Dialog.getNumber();
size_red =  Dialog.getString();
circularity_red =  Dialog.getString();
maskgreen = Dialog.getCheckbox()
thresh_low_green = Dialog.getNumber();
thresh_high_green = Dialog.getNumber();
size_green = Dialog.getString();
circularity_green = Dialog.getString();
maskblue = Dialog.getCheckbox()
thresh_low_blue = Dialog.getNumber();
thresh_high_blue = Dialog.getNumber();
circularity_nk = Dialog.getString();
size_nk = Dialog.getString();
exportmask = Dialog.getCheckbox()
exportbluemasked = Dialog.getCheckbox()

//print(maskgreen,maskblue);

// Tracking parameters
radius = Dialog.getString();
threshold = Dialog.getString();
maxlinkingdist = Dialog.getString();
maxframegap = Dialog.getString();
gapclosingdistance = Dialog.getString();


function processFile(file,path) {
	open(path+file);
	selectWindow(file);
	run("Properties...", "pixel_width="+pixelwidth+" pixel_height="+pixelwidth+" voxel_depth=1.0000000 frame=["+timescale+" s] global");
	run("Split Channels");
	selectWindow("C1-"+file);
	close();
	selectWindow("C2-"+file);
	rename("red");
	run("Make Substack...", "  slices=1");
	selectWindow("red");
	close();
	selectWindow("Substack (1)");
	rename("red_frame_1");
	selectWindow("C4-"+file);
	rename("blue");
	selectWindow("C3-"+file);
	rename("green");
	
	if(maskgreen){
	print("Masking the green signal...");
	selectWindow("green");
	run("Threshold...");
	setThreshold(thresh_low_green, thresh_high_green);
	run("Analyze Particles...", " size="+size_green+" circularity="+circularity_green+"  show=Masks exclude include stack");
	selectWindow("Mask of green");
	run("Invert", "stack");
	run("Divide...", "value=255 stack");
	run("Enhance Contrast", "saturated=0.35"); }
	
	if(maskblue){
	print("Masking the NKs on the blue channel...");
	selectWindow("blue");
	run("Threshold...");
	setThreshold(thresh_low_blue, thresh_high_blue);
	run("Analyze Particles...", "  size="+size_nk+" circularity="+circularity_nk+" show=Masks exclude include stack");
	selectWindow("Mask of blue");
	run("Invert", "stack");
	run("Divide...", "value=255 stack");
	run("Enhance Contrast", "saturated=0.35"); }
	
	if(maskred){
	print("Masking the red signal...");
	selectWindow("red_frame_1");
	run("Threshold...");
	setThreshold(thresh_low_red, thresh_high_red);
	run("Analyze Particles...", " size="+size_red+" circularity="+circularity_red+" show=Masks exclude include stack");
	selectWindow("Mask of red_frame_1");
	run("Invert", "stack");
	run("Divide...", "value=255 stack");
	run("Enhance Contrast", "saturated=0.35"); }		

	if((maskgreen&&maskblue&&maskred)==1){
	print("Applying the masks to the blue channel...");
	imageCalculator("Multiply create 32-bit stack", "Mask of green","Mask of blue");
	rename("Mask0");
	run("Make Substack...", "delete slices=1");
	selectWindow("Substack (1)");
	rename("Mask frame_11");
	imageCalculator("Multiply create 32-bit stack", "Mask frame_11","Mask of red_frame_1");
	rename("Mask frame_1");
	run("Concatenate...", "keep image1=[Mask frame_1] image2=[Mask0]");
	selectWindow("Untitled");
	rename("Mask");}
	
	else {
	if((maskblue&&maskred)==1){
	print("Applying the masks to the blue channel...");
	selectWindow("Mask of blue");
	run("Duplicate...", "duplicate");
	rename('Mask0');
	run("Make Substack...", "delete slices=1");
	selectWindow("Substack (1)");
	rename("Mask frame_11");
	imageCalculator("Multiply create 32-bit stack", "Mask frame_11","Mask of red_frame_1");
	rename("Mask frame_1");
	run("Concatenate...", "keep image1=[Mask frame_1] image2=[Mask0]");
	selectWindow("Untitled");
	rename("Mask");}
	
	if((maskgreen&&maskred)==1){
	print("Applying the masks to the green channel...");
	selectWindow("Mask of green");
	run("Duplicate...", "duplicate");
	rename('Mask0');
	run("Make Substack...", "delete slices=1");
	selectWindow("Substack (1)");
	rename("Mask frame_11");
	imageCalculator("Multiply create 32-bit stack", "Mask frame_11","Mask of red_frame_1");
	rename("Mask frame_1");
	run("Concatenate...", "keep image1=[Mask frame_1] image2=[Mask0]");
	selectWindow("Untitled");
	rename("Mask");}
	
	
	if((maskgreen&&maskblue)==1){
	print("Applying the masks to the blue channel...");
	selectWindow("Mask of blue");
	imageCalculator("Multiply create 32-bit stack", "Mask of green","Mask of blue");
	rename("Mask");}
	}

	//else {
	//	if(maskblue){
	//		selectWindow("Mask of blue");
	//		rename("Mask");}
	//	if(maskgreen){
	//		selectWindow("Mask of green");
	//		rename("Mask"); } 
	//	}

	if(maskblue){
		selectWindow("Mask of blue");
		close();
	}

	if(maskgreen){
		selectWindow("Mask of green");
		close();
	}

	if(maskred){
		selectWindow("red_frame_1");
		close();
		selectWindow("Mask of red_frame_1");
		close();
	}

	if((maskgreen&&maskblue&&maskred)==1){
	selectWindow("Mask0");
	close();
	selectWindow("Mask frame_1");
	close();
	selectWindow("Mask frame_11");
	close();
	}

	
	if(((maskgreen&&maskblue)==1)&(maskred==0)){
		selectWindow("red_frame_1");
		close();
	}

	if(((maskgreen&&maskred)==1)&(maskblue==0)){
	selectWindow("Mask0");
	close();
	selectWindow("Mask frame_1");
	close();
	selectWindow("Mask frame_11");
	close();
	}

	if(((maskblue&&maskred)==1)&(maskgreen==0)){
	selectWindow("Mask0");
	close();
	selectWindow("Mask frame_1");
	close();
	selectWindow("Mask frame_11");
	close();
	}

	selectWindow("Mask");
	if(exportmask){
		saveAs("tiff",outputmasks+file+"_mask.tif");
		rename("Mask");
	}
	selectWindow("green");
	close();
	//run("Collect Garbage");
	selectWindow("blue");
	run("Hide Overlay");
	run("Brightness/Contrast...");
	imageCalculator("Multiply create 16-bit stack", "Mask","blue");
	rename("no NK");
	selectWindow("no NK");
	run("Brightness/Contrast...");
	run("Brightness/Contrast...");
	if(exportbluemasked){
		print("Exporting the NK-masked blue channel...");
		run("Duplicate...", "duplicate");
		selectWindow("no NK-1");
		saveAs("tiff",outputmasked_blue+file+"_masked_blue.tif");
		rename("saved");
		selectWindow("saved");
		close();
	}
	//run("Collect Garbage");
	selectWindow("blue");
	close();
	selectWindow("Mask");
	close();
	//setMetadata("Path", path);
	//saveAs("tiff",path+file+"_masked.tif");
	//runMacro(path+"trackmate_script.py", "RADIUS=7.5");
	jythonText = File.openAsString(path+"trackmate_script.py");
	selectWindow("no NK");
	//print(jythonText);
	print("Launching TrackMate... ");
	call("ij.plugin.Macro_Runner.runPython",jythonText, radius+' '+threshold+' '+maxlinkingdist+' '+maxframegap+' '+gapclosingdistance+' '+tabledir+' '+file);
	//runMacroFile(path+"trackmate_script.py", "RADIUS=7.5");
	close();
	run("Collect Garbage");
	print("Done. Proceeding to the next movie...");
	
}

run("Collect Garbage");
sdir = getDirectory("Select the source/ folder..");
mainDir = sdir;
mainList = getFileList(mainDir);

// Create output folder
outputdir = mainDir+File.separator+"output"+File.separator;
File.makeDirectory(outputdir);

tabledir = mainDir+File.separator+"tables"+File.separator;
File.makeDirectory(tabledir);

// Reset subfolder mask/ 
outputmasks = outputdir+"masks"+File.separator;
check_exists2 = File.exists(outputmasks);
if (check_exists2){
	files = getFileList(outputmasks);
	for (k=0;k<files.length;k++){
		File.delete(outputmasks+files[k]);}
	File.delete(outputmasks);
}
if(exportmask){
File.makeDirectory(outputmasks);}

// Reset subfolder masked_blue/

outputmasked_blue = outputdir+File.separator+"masked_blue"+File.separator;
check_exists3 = File.exists(outputmasked_blue);
if (check_exists3) {
	files = getFileList(outputmasked_blue);
	for (k=0;k<files.length;k++){
		File.delete(outputmasked_blue+files[k]);}
	File.delete(outputmasked_blue);
}
if(exportbluemasked){
File.makeDirectory(outputmasked_blue);}

// MAIN /////////////////////////////

for (i=0;i<mainList.length;i++){
	if(endsWith(mainList[i], ".tif")){
		print(mainList[i]);
		processFile(mainList[i],mainDir);
		}
}

print("The job is done...");
