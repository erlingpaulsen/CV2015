function T = sector(THETA)
% SECTOR assigns a value to the angle in THETA based on the sector the angle
% lies within. The sectors correspons to the lines that goes through a
% 3-by-3 neighborhood.

    [row col] = size(THETA);
    T = zeros(row, col);
    a = pi/8;
    
    for i = 1 : row
        for j = 1 : col
            B = THETA(i,j);
            if (a<=B && 3*a>B) || (9*a<=B && 11*a>B)
                T(i,j) = 1;
            elseif (3*a<=B && 5*a>B) || (11*a<=B && 13*a>B)
                T(i,j) = 2;
            elseif (5*a<=B && 7*a>B) || (13*a<=B && 15*a>B)
                T(i,j) = 3;
            end
        end
    end

end

