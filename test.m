I_d = imread('rgbd-dataset\apple\apple_1\apple_1_1_1_depthcrop.png');
I_rgb = imread('rgbd-dataset\apple\apple_1\apple_1_1_1_crop.png');
[row, col] = size(I_d);

% Normalizing the depth image, i.e replacing zero-values with valid values
% nearby
Inorm = depthNormalization(I_d);

% Removing edges using the Canny edge detector
Iedge_d = edgeDetection(Inorm);
Iedge_rgb = edgeDetection(rgb2gray(I_rgb));

% Combining the edges from both pictures
I = bitor(Iedge_d, Iedge_rgb);

n = 2
while n > 1
    
    % Finding all the components
    CC = bwconncomp(I);
    n = length(CC.PixelIdxList);

    % Deleting components with less than 8 pixels
    for i = 1 : n
        [K, L] = ind2sub([row, col], CC.PixelIdxList{i});
        m = length(K);

        if m < 8 
            I(K,L) = 0;
        end
    end

    % Closing, filling and thinning contour
    I = imclose(I, strel('disk', 2));
    I = imfill(I, 'holes');
    I = thin(I);

end
imshow(I);



