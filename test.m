 I_d = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_depthcrop.png');
 I_rgb = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_crop.png');
 I_mask = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_maskcrop.png');
 
%I_d = imread('rgbd-dataset/banana/banana_1_1_1_depthcrop.png');
%I_rgb = imread('rgbd-dataset/banana/banana_1_1_1_crop.png');

[row, col] = size(I_d);
I_gray = rgb2gray(I_rgb);

% Normalizing the depth image, i.e replacing zero-values with valid values
% nearby
I_norm = DepthNormalization(I_d);

% Separating the object and the background with the segmentation mask
% I_norm = I_norm.*uint16(I_mask);
% I_gray = I_gray.*uint8(I_mask);

% Extracting corners and edges
w = gaussianFilter(2, 2, 15, 15, 0);
w2 = gaussianFilter(2, 2, 11, 11, 0);
[C, E] = featureDetection(I_norm, w);
[C2, E2] = featureDetection(I_gray, w2);

% Removoes edges with fewer than 3 pixels
E = improveEdges(E, 5);
E2 = improveEdges(E2, 5);

figure;imshow(E);

[r,c] = find(C);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('Corners detected');
        
[r,c] = find(E);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('Edges detected');
        
[r,c] = find(C2);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('Corners detected');
        
[r,c] = find(E2);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('Edges detected');



