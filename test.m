loc = load('rgbd-dataset\apple\apple_1\apple_1_1_1_loc.txt'); 
depth = imread('rgbd-dataset\apple\apple_1\apple_1_1_1_depthcrop.png'); 
[pcloud distance] = depthToCloud(depth,loc);

I = imread('rgbd-dataset\apple\apple_1\apple_1_1_1_depthcrop.png');
%I2 = imread('rgbd-dataset\apple\apple_1\apple_1_1_1_crop.png');

J = edgeDetection(I);
imshow(J);
%J2 = edgeDetection(I2);