function J = edgeLinking(I_rgb, I_d)
% EDGELINKING uses the edges detected in the RGB image and the edges
% detected in the depth image and link them together to determine the total
% countour.
%   Detailed explanation goes here
    
    [row, col] = size(I_rgb);
    J = I_d;
    J2 = zeros(row, col);
    
    while ~isequal(J,J2)
        J2 = J;
        CC = bwconncomp(J);

        n = length(CC.PixelIdxList);

        for i = 1 : n
            [K, L] = ind2sub([row, col], CC.PixelIdxList{i});
            m = length(K);

            if m < 4 
                J(K,L) = 0; 
            else
                J(K(1)-1:K(1)+1, L(1)-1:L(1)+1) = bitor(J(K(1)-1:K(1)+1, L(1)-1:L(1)+1), I_rgb(K(1)-1:K(1)+1, L(1)-1:L(1)+1));
                J(K(m)-1:K(m)+1, L(m)-1:L(m)+1) = bitor(J(K(m)-1:K(m)+1, L(m)-1:L(m)+1), I_rgb(K(m)-1:K(m)+1, L(m)-1:L(m)+1));
            end
        end
    end

end

