function J = DepthNormalization(I_orig)
%% Depth image normalization
% 
% Author: Lars Loeken Bjoernskau and Erling Singstad Paulsen
%
% Depth image function that produces a new image depth normalized by
% original depth image I
% J = DepthNormalization(I)

% depth = depthnormalization(I)
I = I_orig;
C = 0; % Counts pixels removed each iteration
[row, col] = size(I); % Size of picture
K = (row-2)*(col-2); % Columns in im2col
stop = false; % False while thinning is possible
w = [3, 3]; % Mask size

%                        ______________
%                       |_P9_|_P2_|_P3_|
% Numbering of mask ==> |_P8_|_P1_|_P4_|
%                       |_P7_|_P6_|_P5_|

while (~stop)
    Icol = im2col(I, w);
    M = zeros(1, K); % To store pixels that should be removed
   
    
    P1 = Icol(5, :); % The pixel we are looking at 
    B = max(Icol([1:4, 6:9], :)); % The maximun neighbouring pixels of P1
    
    for i = 1 : K
        % Checking if we are on countour and if a), c) and d) holds
        if P1(i)==0 
            M(i) = B(i);
            C = C + 1;
        end
    end
    
    
    
    I2 = col2im(double(P1)+M, w, [row, col]); % Removing pixel
    I(2:row-1, 2:col-1) = I2;
    
    %clearing borders
    for i=1:row:row
        for j=1:col-1
            if I(i,j) == 0
               I(i,j) = I(i,j-1);
            end
        end
    end
    for i=1:col:col
        for j=1:row-1
            if I(j,i) == 0
               I(j,i) = I(j-1,i);
            end
        end
    end
    
    stop = C == 0; % If no pixels are removed, the loop ends
    C = 0;
end

J = I;


