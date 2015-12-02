 I_d = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_depthcrop.png');
 I_mask = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_maskcrop.png');
 I_rgb = imread('rgbd-dataset/apple/apple_1/apple_1_1_1_crop.png');
%I_d = imread('rgbd-dataset/banana/banana_1_1_1_depthcrop.png');
%I_rgb = imread('rgbd-dataset/banana/banana_1_1_1_crop.png');
[row, col] = size(I_d);


%I_rgb = I_rgb.*I_mask;

% Normalizing the depth image, i.e replacing zero-values with valid values
% nearby
Inorm = DepthNormalization(I_d);


I_mask = uint16(I_mask);
Inorm = Inorm.*I_mask;
% Extracting corners and edges
[C, E] = featureDetection(Inorm);
[C2, E2] = featureDetection(rgb2gray(I_rgb));
     
% Finding all the components
CC = bwconncomp(E);
n = length(CC.PixelIdxList);

% Deleting components with less than 8 pixels
for i = 1 : n
    [K, L] = ind2sub([row, col], CC.PixelIdxList{i});
    m = length(K);

    if m < 5 
        E(K,L) = 0;
    end
end

CC = bwconncomp(E);

[r,c] = find(C);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('corners detected');
        
[r,c] = find(E);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('edge detected');
        
[r,c] = find(C2);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('corners detected');
        
[r,c] = find(E2);
figure, imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(c,r,'ys'), title('edge detected');



