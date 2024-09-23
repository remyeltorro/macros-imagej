/*
Load ROIs, measure and export table
*/


sdir = getDirectory("Which folder contains the images?");
mainDir = sdir;
mainList = getFileList(mainDir+'data_selection/'); 
ROI_zips = getFileList(mainDir+'roi/filtered/'); 

for (i=0;i<mainList.length;i++){
	if(endsWith(mainList[i], ".tif")){
		open(mainList[i]);
		run("ROI Manager...");
		roiManager("Open",mainDir+'roi/filtered/'+mainList[i]+".zip");
		roiManager("Measure");
		saveAs("Results", mainDir+'csv/'+mainList[i]+'.csv');
		close();
		roiManager("Delete");
		run("Clear Results");
		}
}
