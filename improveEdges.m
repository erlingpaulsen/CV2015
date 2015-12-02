function J = improveEdges(I, t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[row, col] = size(I);
J = I;

% Finding all the components
CC = bwconncomp(J);
n = length(CC.PixelIdxList);

it = 1;
while n > 1 && it < 10
    % Dilating and thinning edges to increase connectivity
    J = imclose(J, strel('disk', 5));
    J = thin(J);

    % Deleting components with less than t pixels
    for i = 1 : n
        [K, L] = ind2sub([row, col], CC.PixelIdxList{i});
        m = length(K);

        if m < t 
            J(K,L) = 0;
        end
    end
    it = it + 1;
    CC = bwconncomp(J);
    n = length(CC.PixelIdxList);
end


end

