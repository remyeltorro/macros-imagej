/*
Registration of 2-part stacks in a folder using SIFT multichannel
*/

run("Collect Garbage");
folder = getDirectory("Folder containing movies to align...");
files1 = getFileList(folder+"part1/");
files2 = getFileList(folder+"part2/");

octave_steps = "7";
target_channel = "3";
target_channel_int = 3;

for (i=0;i<files1.length;i++){
	
	file1 = files1[i];
	
	print(file1);
	file2 = "AfterNK_2"+substring(file1, 9, file1.length);
	print(file2);
	

	if(endsWith(file1, ".tif")){
		
		open(folder+"part1"+File.separator+file1);
		rename("1");
		
		open(folder+"part2"+File.separator+file2);
		rename("2");
		
		// Concatenate
		run("Concatenate...", "open image1=1 image2=2");
		
		Stack.setChannel(target_channel_int);
		run("Enhance Contrast", "saturated=0.35");
		run("Linear Stack Alignment with SIFT MultiChannel", "registration_channel="+target_channel+" initial_gaussian_blur=1.60 steps_per_scale_octave="+octave_steps+" minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
		
		saveAs("Tiff", folder+"aligned/Aligned_"+file1);
		close();
		close();
		run("Collect Garbage");
		
		}
	
}
