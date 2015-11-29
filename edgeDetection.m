function J = edgeDetection(I)
% EDGEDETECTION uses a the Canny edge detection algorithm to detect edges.
%   J = edgeDetection(I) returns an image J containing the edges in I. The
%   edges are comouted using the following scheme:
%   1. Smoothing with a Gaussian filter
%   2. Computing the gradient and its magnitude and orientation
%   3. Nonmaxima suppression
%   4. Thersholding
    
    [row, col] = size(I);
    J = zeros(row, col);
    P = J;
    Q = J;
    M = J;
    THETA = J;
    t = 7;
    
    % Smoothing image with a Gaussian filter
    w = gaussianFilter(2, 2, 7, 7, 0);
    S = conv2(double(I), w, 'same');
    
    % Computing the partial derivatives, and the magnitude and orientation
    % of the gradient, using an improved 3-by-3 neighborhood to calculate
    % the gradient.
    for i = 1:row
        for j = 1:col
            if i == row
                P(i,j) = P(i-1, j);
                Q(i,j) = Q(i-1, j);
            elseif j == col
                P(i,j) = P(i, j-1);
                Q(i,j) = Q(i, j-1);
            else
                P(i,j) = (S(i,j+1) - S(i,j) + S(i+1,j+1) - S(i+1,j))/2;
                Q(i,j) = (S(i,j) - S(i+1,j) + S(i,j+1) - S(i+1,j+1))/2;
            end
%             P(i,j) = (S(i,j+1) - S(i,j-1) + S(i-1,j+1) - S(i-1,j-1) + S(i+1,j+1) - S(i+1,j-1))/2;
%             Q(i,j) = (S(i+1,j) - S(i-1,j) + S(i+1,j-1) - S(i-1,j-1) + S(i+1,j+1) - S(i-1,j+1))/2;
            M(i,j) = sqrt(P(i,j)^2 + Q(i,j)^2);
            THETA(i,j) = atan2(Q(i,j), P(i,j));
        end
    end
    
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
    J = imclearborder(N);

end

