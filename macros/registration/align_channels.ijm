/*
Align one channel to the other with SIFT
*/


run("Collect Garbage");

open("/home/torro/Documents/Side_projects/TFM_heidleberg/Clean_Joel_2021/Inverse_simultaneous/blue_channel.tif");
open("/home/torro/Documents/Side_projects/TFM_heidleberg/Clean_Joel_2021/Inverse_simultaneous/green_channel.tif");
selectWindow("blue_channel.tif");
nbrframes = nSlices;
print(nbrframes);

for (i=1;i<=nbrframes;i++) {
	print(i);
	selectWindow("green_channel.tif");
	run("Make Substack...", "  slices=" + i);
	rename("frameG.tif");
	selectWindow("blue_channel.tif");
	run("Make Substack...", "  slices=" + i);
	rename("frameB.tif");
	run("Concatenate...", "open image1=[frameB.tif] image2=[frameG.tif] image3=[-- None --]");
	rename("2by2.tif");
	selectWindow("2by2.tif");
	run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=0.70 steps_per_scale_octave=8 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=15 inlier_ratio=0.05 expected_transformation=Affine interpolate");
	saveAs("tiff","/home/torro/Documents/Side_projects/TFM_heidleberg/Clean_Joel_2021/Inverse_simultaneous/aligned/"+i+".tif");
	selectWindow("2by2.tif");
	close();
	selectWindow(i+".tif");
	close();
}

//close(*);
