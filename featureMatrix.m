function Features = featureMatrix(folderpath, t2, n)


N = n; % Number of pictures to process

%
% To store the connected components structure CC, which is returned from
% the function bwconncomp(). One cell aray will hold all the CC for each of
% the depth images, and one cell array will hold all the CC for each of the
% RGB-images. IF THE NUMBER OF CC IS 1 FOR A GIVEN IMAGE, THEN THE
% ALGORITHM HAR SUCESSFULLY EXTRACTED THE REGION.
%
props = cell(1,N);
Components_d = cell(1,N);
Components_rgb = cell(1,N);

% Kjører hele løkka 1 gang per bilde
for i = 1 : N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating filenames and path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num = num2str(i);
sd = strcat(folderpath, sprintf('%03d.png', i));
%srgb = strcat(folderpath, num, '.png');
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_d = imread(sd);
%I_rgb = imread(srgb);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting the RGB image to a grayscale intensity image, and replacing
% zeros with nonzero neighbors in the depth map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%I_gray = rgb2gray(I_rgb);
I_norm = Kinect_DepthNormalization(I_d);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting depth map before and after normalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% s1 = subplot(1,2,1); imagesc(I_d), axis image, colormap(jet), 
%                 title('Depth map before normalization');
% 
% s2 = subplot(1,2,2); imagesc(I_norm), axis image, colormap(jet), caxis([0, max(I_d(:))]),
%                 title('Depth map after normalization'), colorbar;
% 
% s1Pos = get(s1,'position');
% s2Pos = get(s2,'position');
% s2Pos(3:4) = [s1Pos(3:4)];
% set(s2,'position',s2Pos);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the edged E in the depth map, and the edged E2 in the grayscale
% image using MATLAB Canny detecor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                 T1    T2   SIGMA
[E, ~] = edge(I_norm, 'canny', [0.0001 t2], 2.5);
%[E2, ~] = edge(I_gray, 'canny', [], 3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using various morphological operations with MATLAB's bwmorph to obtain
% the filled regions of the object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = bwmorph(E, 'thicken', 4); % To thicken the edges
%E2 = bwmorph(E2, 'thicken', 3);
E = bwmorph(E, 'close', Inf); % To close and connect the edges
%E2 = bwmorph(E2, 'close', Inf);
E = imfill(E, 'holes'); % To fill in the region
%E2 = imfill(E2, 'holes');
R = bwmorph(E, 'erode', 3); % To erode away some extra area because of the thickening
%R2 = bwmorph(E2, 'erode', 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using bwconncomp to get the connected components CC from the regions and
% store it in the Components_d and Components_rgb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Components_d{i} = bwconncomp(R);
%Components_rgb{i} = bwconncomp(R2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the countour of the region with MATLAB's bwmorph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = bwmorph(R, 'remove');
%E2 = bwmorph(R2, 'remove');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Finding the skeleton of the region with MATLAB's bwmorph
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% S = bwmorph(R, 'skel', Inf);
% S2 = bwmorph(R2, 'skel', Inf);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracting regionprops from Components that has a region with Area larger than 500
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

props{i} = regionprops(Components_d{i},'all');

n_a = 0;
for j=1:size(props{i})
    if(props{i}(j).Area > 750)
        n_a = n_a + 1;
        newprops{i}(n_a) = props{i}(j);
    end
end
n_a = 0;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% [y, x] = find(E);
% subplot(1,2,1), imagesc(I_norm), axis image, colormap(gray), hold on
% 	    plot(x,y,'ys'), title('Edges detected from depth map');

% [y, x] = find(E2);
% subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'ys'), title('Edges detected from RGB image');
% 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected regions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure;
% [y, x] = find(R);
% subplot(1,2,1), imagesc(I_norm), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Region detected from depth map');
% % 
% [y, x] = find(R2);
% subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Region detected from RGB image');
%         
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected skeletons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure;
% [y, x] = find(S);
% subplot(1,2,1), imagesc(I_norm), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Skeleton detected from depth map');

% [y, x] = find(S2);
% subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Skeleton detected from RGB image');

end % End of for-loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating how many picture the algorithm were able to extract the
% proper region from
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sucess rates
[~,n_d] = size(newprops(~cellfun('isempty', newprops)));
fprintf('size of newprops: %d\n',n_d);

percent_d = double(n_d/N)*100;
%percent_rgb = double(n_rgb/N)*100;

fprintf('Number of images processed: %d\n',N);
fprintf('Percentage of images where we sucessfully extracted \n the object region from the depth map: %3.2d %% \n',percent_d);
% fprintf('Percentage of images where we sucessfully extracted \n the object region from the RGB image: %3.2d %% \n',percent_rgb);

% Defining the data set with features
[~, d] = size(newprops);
Features = [];
for i=1:d
    if (~isempty(newprops{:,i}))
        for j =1: size(newprops{:,i})
            Features = [Features;newprops{:,i}(j).Extent, newprops{:,i}(j).Eccentricity,...
                (newprops{:,i}(j).Perimeter.^2)/(4*pi*newprops{:,i}(j).Area), newprops{:,i}(j).MinorAxisLength/newprops{:,i}(j).MajorAxisLength,...
                newprops{:,i}(j).Solidity, newprops{:,i}(j).EquivDiameter];
        end
    end
end
