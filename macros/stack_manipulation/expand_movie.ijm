/*
Extend a stack with black frames to reach the desired stack length
Needs: a stack opened
*/


Stack.getDimensions(width, height, channels, slices, frames);
last_frame = maxOf(slices, frames);

// Dialog box to set tracking parameters
Dialog.create("Parameters");
Dialog.addString("Desired stack length = ",last_frame+1);
Dialog.show();

// Image parameters
final_nbr_frames = Dialog.getString();
final_nbr_frames = parseFloat(final_nbr_frames);

for (i=0;i<final_nbr_frames-last_frame;i++){
	setSlice(last_frame*channels);
	run("Add Slice", "add=slice");
}
