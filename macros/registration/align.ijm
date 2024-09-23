/*
Registration of all stacks in a folder using SIFT multichannel
*/


run("Collect Garbage");
folder = getDirectory("Folder containing movies to align...");
files = getFileList(folder);

octave_steps = "7";
target_channel = "3";
target_channel_int = 3;

for (i=0;i<files.length;i++){
	
	file = files[i];
	print(file);
	print(folder+"aligned/"+file);
	
	if(endsWith(file, ".tif")){
		
		open(file);
		
		// Open sequence alternative
		// File.openSequence(folder+file);
		// run("Stack to Hyperstack...", "order=xyczt(default) channels=4 slices=1 frames=62 display=Grayscale");
		// run("Arrange Channels...", "new=4213");	
		
		// Important: Contrast channel of interest before SIFT
		Stack.setChannel(target_channel_int);
		run("Enhance Contrast", "saturated=0.35");
		
		
		run("Linear Stack Alignment with SIFT MultiChannel", "registration_channel="+target_channel+" initial_gaussian_blur=1.60 steps_per_scale_octave="+octave_steps+" minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
		
		saveAs("Tiff", folder+"aligned/Aligned_"+file);
		close();
		close();
		run("Collect Garbage");
		
		}
	
}
