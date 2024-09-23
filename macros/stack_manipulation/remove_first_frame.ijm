/*
Works with a Celldetective experiment folder. Remove the first frame from each stack and save inplace.
*/


run("Collect Garbage");
folder = "/home/limozin/Documents/OctoberHerceptin_diluted/October26ExpFinal/";
wells = getFileList(folder);

for (i=0;i<wells.length;i++){
	
	well = wells[i];
	cdt = startsWith(well,"W");
	
	if (cdt) {
		print("Entering well ",well);
		positions = getFileList(folder+well);
		for (j=0;j<positions.length;j++){
			print(positions[j]);
			movie = getFileList(folder+well+positions[j]+"movie/");
			open(folder+well+positions[j]+"movie/"+movie[0]);
			run("Delete Slice", "delete=slice");
			saveAs("Tiff", folder+well+positions[j]+"movie/"+movie[0]);
			close();
			run("Collect Garbage");
		}
	
	}
}

//for (i=0;i<files.length;i++){
//	
//	file = files[i];
//	print(file);
//	print(folder+"aligned/"+file);
//	
//	if(endsWith(file, ".tif")){
//		open(file);
//		run("Linear Stack Alignment with SIFT MultiChannel", "registration_channel="+target_channel+" initial_gaussian_blur=1.60 steps_per_scale_octave="+octave_steps+" minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Rigid interpolate");
//		}
//	saveAs("Tiff", folder+"aligned/Aligned_"+file);
//	close();
//	close();
//	run("Collect Garbage");
//	
//}
