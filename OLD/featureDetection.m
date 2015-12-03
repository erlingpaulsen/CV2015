function [C, E] = featureDetection(I, w, t)
% EDGEDETECTION uses a the Canny edge detection algorithm to detect edges.
%   J = edgeDetection(I) returns an image J containing the edges in I. The
%   edges are comouted using the following scheme:
%   1. Smoothing with a Gaussian filter
%   2. Computing the gradient and its magnitude and orientation
%   3. Nonmaxima suppression
%   4. Thersholding
    
    [row, col] = size(I);
    C = zeros(row, col);
    E = C;
    
    dx = [-1 0 1; -1 0 1; -1 0 1];
    dy = dx';
    
    % Smoothing image with a Gaussian filter
    S = conv2(double(I), w, 'same');
    
    % Computing intensity gradients, and its magnitude and direction
    P = conv2(S, dx, 'same');
    Q = conv2(S, dy, 'same');
    M = sqrt(P.^2 + Q.^2);
    THETA = atan2(Q, P);
    
    % Computing the smoothed square of the gradients
    P2 = conv2(P.^2, w, 'same');
    Q2 = conv2(Q.^2, w, 'same');
    PQ = conv2(P.*Q, w, 'same');
    
    % Computing the Harris corner measure and does nonmaxima supression
    C = (P2.*Q2 - PQ.^2) - 0.04*(P2 + Q2).^2;
    radius = 2;
    sze = 2*radius+1;                   % Size of mask.
	mx = ordfilt2(C,sze^2,ones(sze)); % Grey-scale dilate.
	C = (C==mx)&(C>1000);       % Find maxima.
	
    
    % Nonmaxima suppression, i.e removing magnitudes in M that are not
    % maximum compared to its neighbors in the direction of the gradient
    T = sector(THETA);
    
    M_col = im2col(padarray(M, [1 1]), [3 3]);
    T_col = im2col(T, [1 1]);
    P = M_col(5, :);
    
    for i = 1 : row*col
        switch T_col(i)
            case 0
                if (P(i)<M_col(2,i) || P(i)<M_col(8,i)); P(i) = 0; end
            case 1
                if (P(i)<M_col(3,i) || P(i)<M_col(7,i)); P(i) = 0; end
            case 2
                if (P(i)<M_col(4,i) || P(i)<M_col(6,i)); P(i) = 0; end
            case 3
                if (P(i)<M_col(1,i) || P(i)<M_col(9,i)); P(i) = 0; end
        end
    end
    
    N = col2im(P, [3 3], [row+2, col+2]);
    
    % Thresholding and clearing border
    N(N<t) = 0;
    N(N>0) = 1;
    E = imclearborder(N);

end

