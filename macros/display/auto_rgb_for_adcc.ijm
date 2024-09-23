/*
Auto RGB an ADCC stack (BF + PI(red) + CFSE(green) + Hoechst(blue))
*/

nbr_channels = 4;
nbr_frames = nSlices();
frames = nbr_frames/nbr_channels;
//run("Stack to Hyperstack...", "order=xyczt(default) channels="+nbr_channels+" slices=1 frames="+frames+" display=Color");

Stack.setChannel(1);
Stack.setFrame(1);
run("Grays");

Stack.setChannel(2);
Stack.setFrame(frames);
run("Red");

Stack.setChannel(3);
Stack.setFrame(frames);
run("Green");

Stack.setChannel(4);
Stack.setFrame(1);
run("Blue");

Stack.setDisplayMode("composite");
