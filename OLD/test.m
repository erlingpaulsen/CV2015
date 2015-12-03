 I_d = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_depthcrop.png');
 I_rgb = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_crop.png');
%  I_mask = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_maskcrop.png');
 
%I_d = imread('rgbd-dataset/banana/banana_1_1_1_depthcrop.png');
%I_rgb = imread('rgbd-dataset/banana/banana_1_1_1_crop.png');

% I_rgb = imread('rgbd-dataset/desk/desk_1/desk_1_1.png');
% I_d = imread('rgbd-dataset/desk/desk_1/desk_1_1_depth.png');

[row, col] = size(I_d);
I_gray = rgb2gray(I_rgb);

% Normalizing the depth image, i.e replacing zero-values with valid values
% nearby
I_norm = Kinect_DepthNormalization(I_d);
figure; imagesc(I_d), colormap(hot);
figure; imagesc(I_norm), colormap(hot);

% Extracting corners and edges
w = fspecial('gaussian', 9, 2);
w2 = fspecial('gaussian', 9, 2);
[C, E] = featureDetection(I_norm, w, 20);
[C2, E2] = featureDetection(I_gray, w2, 25);

% E = removeEdges(E, 2);
% E2 = removeEdges(E2, 2);
% E = imdilate(E, strel('disk', 2));
% E2 = imdilate(E2, strel('disk', 2));
% E = thin(E);
% E2 = thin(E2);
% E = removeEdges(E, 5);
% E2 = removeEdges(E2, 5);
% 
% E3 = bitor(E, E2);
% E3 = imdilate(E3, strel('disk', 2));
% E3 = thin(E3);
% 
% figure;imshow(E);
% figure;imshow(E2);
% figure;imshow(E3);

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



