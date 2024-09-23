/*
Segment giant unilamellar vesicles from normalized RICM images
*/


selectWindow("normalized.tif");
dir = getDir("image");
setMinAndMax(0.80, 1.00);
setAutoThreshold("Default dark");
setThreshold(0.0, 0.90);
waitForUser;

run("Analyze Particles...", "size=300-Infinity pixel circularity=0.10-1.00 show=Masks exclude include add slice");
selectWindow("Mask of normalized.tif")
run("Divide...", "value=255");
saveAs("TIF", dir+"mask.tif");
close("*");
