/*
Classify visually crops cell images as NK, red blood cell or other and save in separate folders
*/


// Load folder containing .tif images
sdir = getDirectory("Which folder contains the images?");
mainDir = sdir;
mainList = getFileList(mainDir); 

for (i=0;i<mainList.length;i++){

	if(endsWith(mainList[i], ".tif")){
	
		open(mainList[i]);
		
		print(mainList[i]);
		run("Clear Results");
		run("Stack to Images");
		
		selectWindow(mainList[i].substring(0,mainList[i].length()-4)+"-0001");
		setLocation(300,0);
		
		selectWindow(mainList[i].substring(0,mainList[i].length()-4)+"-0002");
		run("Enhance Contrast", "saturated=0.35");
		setLocation(300,300);
		
		Dialog.create("Classification");
		Dialog.addChoice("Class:", newArray("NK", "RBC","Other"));
		Dialog.show();
		
		type = Dialog.getChoice();

		
		if (type=="NK"){
			run("Images to Stack");
			saveAs("Tiff", sdir+"nk/"+mainList[i]);
			File.delete(sdir+mainList[i]);
			close();
		} else {
		    if(type=="RBC"){
			run("Images to Stack");
			saveAs("Tiff", sdir+"rbc/"+mainList[i]);
			File.delete(sdir+mainList[i]);
			close();
		    } else {
			if (type=="Other"){
			run("Images to Stack");
			saveAs("Tiff", sdir+"other/"+mainList[i]);
			File.delete(sdir+mainList[i]);
			close();
			    }
			}
		    }	
		}
}
