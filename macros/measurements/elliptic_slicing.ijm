/*
Author: Rémy Torro (Laboratoire Adhésion & Inflammation)
1) Take each ROI, compute bounding ellipse
2) Draw a slice at several angles and measure intensity profile
3) Store results in table and export
*/


rename("img");
numROIs = roiManager("count");
angles = newArray(0.        , 0.6981317 , 1.3962634 , 2.0943951 , 2.7925268 , 3.4906585 , 4.1887902 , 4.88692191, 5.58505361, 6.28318531);
idx=0
for(i=0; i<numROIs;i++) {// loop through ROIs
	roiManager("Select", i);	
	Roi.getBounds(x, y, width, height);
	name =  Roi.getName;
	xc = x+width/2;
	yc = y+height/2;
	for (a=0;a<angles.length;a++){
		
		makeLine(xc, yc, xc+1.05*width/2*cos(a), yc+1.05*width/2*sin(a));
		//run("Plot Profile");
		intensity_line = getProfile();
		len_line = intensity_line.length;
		
		maxI = Array.findMaxima(intensity_line, 1);
	    for (j=0; j<intensity_line.length; j++) {
	      setResult("roi", idx+j, name);
	      setResult("distance_to_center", idx+j, j);
	      setResult("intensity", idx+j, intensity_line[j]);
	      setResult("angle", idx+j, angles[a]);
		  setResult("max_intensity", idx+j, intensity_line[maxI[0]]);
		  
	      }
	    updateResults;
	    //Array.print(maxI);
	    //print(intensity_line[maxI[0]]);

	    if (a==0){
	    Plot.create("Profile", "X", "Value", intensity_line);}
	    else {
	    	Plot.add("line",intensity_line);
	    }
	    //waitForUser;
		// Reselect og image
		selectWindow("img");
		roiManager("Select", i);
		idx = idx+len_line;
	}
}

// Save as spreadsheet compatible text file
//path = getDirectory("home")+"profile.csv";
//saveAs("Results", path);
