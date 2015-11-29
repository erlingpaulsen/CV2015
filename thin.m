function J = thin(I)

C = 0; % Counts pixels removed each iteration
[row, col] = size(I); % Size of picture
K = (row-2)*(col-2); % Columns in im2col
subit = 1; % Desiced which subiteration to use
stop = false; % False while thinning is possible
w = [3, 3]; % Mask size

%                        ______________
%                       |_P9_|_P2_|_P3_|
% Numbering of mask ==> |_P8_|_P1_|_P4_|
%                       |_P7_|_P6_|_P5_|

while (~stop)
    Icol = im2col(I, w);
    M = zeros(1, K); % To store pixels that should be removed
    
    if subit == 1
        % First subiteration condition
        c = Icol(4, :).*Icol(8, :).*Icol(6, :);
        d = Icol(8, :).*Icol(6, :).*Icol(2, :);
    else
        % Second subiteration condition
        c = Icol(4, :).*Icol(8, :).*Icol(2, :);
        d = Icol(4, :).*Icol(6, :).*Icol(2, :);
    end
    
    P1 = Icol(5, :); % The pixel we are looking at 
    B = sum(Icol([1:4, 6:9], :)); % The sum of neighbouring pixels of P1
    A = zeros(1, K); % Number of 01 patterns clockwise around each pixel
    
    for i = 1 : K
        % Checking if we are on countour and if a), c) and d) holds
        if P1(i)==1 && c(i)==0 && d(i)==0 && B(i)>1 && B(i)<7
            
            % Ordering neighbourhood pixels from P2 => P2 clockwise around P1
            turn = [Icol(4, i) Icol(7, i) Icol(8, i) Icol(9, i)...
                    Icol(6, i) Icol(3, i) Icol(2, i) Icol(1, i) Icol(4, i)];
             
            j = 1;
            while j<9 && A(i)<2 % Finding number of 01 patterns in the turn
                A(i) = A(i) + (~turn(j) && turn(j+1));
                j = j + 1;
            end
            
            if A(i)==1 % Iff one 01 pattern, pixel is removed
                M(i) = 1;
                C = C + 1;
            end
        end
    end
    
    I2 = col2im(P1-M, w, [row, col]); % Removing pixel
    I(2:row-1, 2:col-1) = I2;
    
    stop = C == 0; % If no pixels are removed, the loop ends
    C = 0;
    subit = mod(subit, 2) + 1; % Alternating between subiteration 1 and 2
end

J = I;

end

