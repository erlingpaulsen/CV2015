function w = gaussianFilter(x_dev, y_dev, m, n, theta)
    
    % Creates an empty mask
    w = zeros(m, n);
    
    % Rotation matrix around Z-axis
    r = [cos(theta) -sin(theta)
         sin(theta)  cos(theta)];
    
    % Calculating the mean in X and Y 
    % as being the center of the mask
    mu_x = ceil(m/2);
    mu_y = ceil(n/2);
    
    % Shifts the mask such that both means are zero 
    X = (1 : m) - mu_x;
    Y = (1 : n) - mu_y;
    
    % Rotates and multiply the two Gaussian distributions
    % together for each element in the mask
    for i = 1 : m
        for j = 1 : n
            u = r*[X(i), Y(j)]';
            w(i, j) = gauss(u(1), x_dev)*gauss(u(2), y_dev); 
        end
    end
    
    % Help function calculating the Gaussian distribution
    function z = gauss(x, dev)
        z = (1/(dev*sqrt(2*pi)))*exp(-x^2/(2*dev^2));
    end
end

