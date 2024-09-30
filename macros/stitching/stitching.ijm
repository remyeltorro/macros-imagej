/*
Macro written for Dalia El Arawi, post-doc, to rearrange a stack of overlapping tiles and stitch them together
*/


run("Collect Garbage");
folder = getDirectory("Folder containing all the stacks to stitch");
files = getFileList(folder);

stitch_dir = folder + "stitched";
File.makeDirectory(stitch_dir);

for (i=0;i<files.length;i++){
	
	file = files[i];
	print(file);
	
	if (file.endsWith(".tif") | file.endsWith(".tiff")) {
			run("Bio-Formats Importer", "open=["+ folder +file+"] autoscale color_mode=Default rois_import=[ROI manager] view=[Hyperstack] stack_order=Default");
			//File.openSequence(folder+file);
			og_name = File.getName(folder+file);
			
			tiles_dir = folder + substring(og_name,0,og_name.length - 15);
			File.makeDirectory(tiles_dir);
			
			getDimensions(width, height, channels, slices, frames);
			n_slices = Math.max(slices,frames);
			print("N slices = ",n_slices);
			n_channels = channels;
			print("N channels = ",n_channels);
			waitForUser;
			
			if (n_channels>1) {
				run("Arrange Channels...", "new=1");
				run("Grays");
			}
			
			rename("og_stack");
			
			// Rotation and replace first frame in the middle of the stack
			run("Rotate 90 Degrees Right");
			
			// Find mid point in stack
			quotient = Math.ceil(n_slices/2);
			qp1 = quotient + 1;
			print("Mid point: ", quotient);
			
			selectWindow("og_stack");
			run("Make Substack...", "slices=1");
			rename("initial frame");
			

			selectWindow("og_stack");
			run("Duplicate...", "duplicate range=2-"+quotient+" use");
			rename("first part");
			
			
			selectWindow("og_stack");
			run("Duplicate...", "duplicate range="+qp1+"-"+n_slices+" use");
			rename("last part");
			
			
			selectWindow("og_stack");
			close();
			
			run("Concatenate...", "  title=stack open image1=[first part] image2=[initial frame] image3=[last part]");


			// Quality check (optional)
			// run("Make Montage...", "columns=7 rows=7 scale=0.25");
			// waitForUser;
			// selectWindow("Montage");
			// close();
			
			// Export image sequence to disk
			selectWindow("stack");
			run("Image Sequence... ", "select="+tiles_dir+" dir="+tiles_dir+" format=TIFF name=[]");
			selectWindow("stack");
			close();
			
			// Stitch
			// With compute overlap
			//run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=7 grid_size_y=7 tile_overlap=20 first_file_index_i=0 directory="+tiles_dir+" file_names={iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
			// Without compute overlap
			run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=7 grid_size_y=7 tile_overlap=20 first_file_index_i=0 directory="+tiles_dir+" file_names={iiii}.tif output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
			
			selectWindow("Fused");
			rename(og_name);
			
			// Export stitched image
			print(stitch_dir + File.separator + og_name);
			saveAs("Tiff", stitch_dir + File.separator + og_name);
			close();
			run("Collect Garbage");
		}
}
	
