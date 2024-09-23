/*
Overlay a segmentation result
*/


run("Collect Garbage");
sdir = getDirectory("Select overlay/ folder..");
mainDir = sdir;
mainList = getFileList(mainDir);

for (i=0;i<mainList.length;i++){
	if(endsWith(mainList[i], ".tif")){
		
		open(mainDir+mainList[i]);
		rename("overlay");
		run("Enhance Contrast", "saturated=0.35");
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
		selectWindow("overlay");
		Stack.getDimensions(shape_x,shape_y,n_channels,slices,n_frames);
		
		for (j=0;j<slices;j++){
			run("Duplicate...", "  channels=1 slices="+j);
			rename("Slice");
			selectWindow("labels_nk");
			run("Add Image...", "image=Slice x=0 y=0 opacity=40");
			Overlay.setPosition(i+1);
			}
		
		selectWindow("Slice");
		close();
		selectWindow("overlay");
		}
}
