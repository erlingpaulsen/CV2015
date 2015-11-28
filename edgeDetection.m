function J = edgeDetection(I)
% EDGEDETECTION uses a two-dimensional Gaussian filter to detect edges in
% an image.
%   J = edgeDetection(I) returns an gradient image J based on an input
%   image I. Large values in J correspond to edges in I.

    w1 = fspecial('gaussian', 3, 0.5);
    w2 = gaussianFilter(0.4, 0.4, 3, 3, 0);
    
    J = conv2(I, w2, 'same');


end

