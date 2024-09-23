/*
Make a small animation of a series of ADCC movie stacks
1) Load stack
2) Convert to RGB
3) Rescale
4) Animate and export
*/


dir = getDirectory("Which folder contains the images?");
files = getFileList(dir);
run("Collect Garbage");
for (i=0;i<files.length;i++){
	
	open(files[i]);
	rename("og");
	run("Duplicate...", "duplicate channels=2-4");
	rename("fluo");
	close("og");
	selectWindow("fluo");
	Stack.setChannel(1);
	run("Red");
	setMinAndMax(0, 2931);
	Stack.setChannel(2);
	run("Green");	
	setMinAndMax(275, 899);
	Stack.setChannel(3);
	run("Blue");	
	setMinAndMax(91, 4228);	
	run("Properties...", "channels=3 slices=1 frames=44 pixel_width=1.0000 pixel_height=1.0000 voxel_depth=1.0000");
	run("Scale...", "x=0.1 y=0.1 z=1.0 width=205 height=205 depth=44 interpolation=Bilinear average create");
	close("fluo");
	run("RGB Color", "frames keep");
	close("fluo-1");
	saveAs("Gif", "/home/limozin/Desktop/104.gif");
	}
