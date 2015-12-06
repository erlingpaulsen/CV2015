%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Halla Lars, her er gangen i koden. Jeg har lagd en for-løkke som åpner
%  og kjører over bildene.
%
%  1. Loade filer
%
%  2. Konverterer RGB til grayscale: I_gray, og normaliserer dybdebildet:
%  I_norm
%
%  3. Plotter de to dybdebildene for å se effekten av normaliseringen.
%
%  4. Bruker MATLAB sin Canny detector til å finne kantene E og E2. Den tar
%  inn threshold og sigma til gaussianfilteret, hvis man ønsker å spesifisere
%  dette. Jeg har tweaka det sånn at det funker ganske bra.
%
%  5. Bruker masse morphological operators med bwmorph-funksjonen. Først
%  gjør jeg alle kantene tjukkere. Så lukker jeg bildet for å får alle
%  kantene jevne. Så fyller jeg inn hele eplet, sånn at du får hele
%  regionene, R og R2. Og til slutt eroder jeg vekk litt, siden regionen er
%  litt for stor pga at kantene ble gjort tjukkere.
%
%  6. Henter ut Connected Components fra regionene med
%  bwconncomp-funksjonen til MATLAB og lagrer de i hver sine cell arrays,
%  en for dybebildene og en for rgb-bildene. På de connected components
%  kan man bruke regionprops senere.
%
%  7. Fra den fylte regionen bruker jeg bwmorph med 'remove' for å finne
%  konturen til regionene, E og E2.
%
%  8. Fra den fylte regionen bruker jeg bwmorph med 'skel' for å finne
%  skjelletet til regionene, S og S2.
%
%  9. Plotter Regionene, Kantene og Skjelletene fra både dybdebildet og
%  RGB-bildet.
%
%  WHAT TO TO NEXT?
%
%  Jeg vet ikke helt ass. Men nå jeg testa den koden her på de 20 første
%  bildene, så klarte den algoritmen her og fullføre konturen og å lage
%  skjellett til eplet osv i 13 av 20 tilfeller. Og her kombinerer jeg
%  aldri RGB og dybdebildet, jobber på de helt hver for seg.
%
%  Det vil si at vi nå kan hente ut kontur, region og skjelett fra
%  dybdebildet alene for hvert bilde.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sd1 = 'rgbd-dataset/bowl/bowl_1/bowl_1_1_';
sd2 = '_depthcrop.png';
srgb1 = 'rgbd-dataset/bowl/bowl_1/bowl_1_1_';
srgb2 = '_crop.png';

N = 10; % Number of pictures to process

%
% To store the connected components structure CC, which is returned from
% the function bwconncomp(). One cell aray will hold all the CC for each of
% the depth images, and one cell array will hold all the CC for each of the
% RGB-images. IF THE NUMBER OF CC IS 1 FOR A GIVEN IMAGE, THEN THE
% ALGORITHM HAR SUCESSFULLY EXTRACTED THE REGION.
%
Components_d = cell(1,N);
Components_rgb = cell(1,N);

% Kjører hele løkka 1 gang per bilde
for i = 1 : N

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating filenames and path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = num2str(i);
sd = strcat(sd1, n, sd2);
srgb = strcat(srgb1, n, srgb2);
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_d = imread(sd);
I_rgb = imread(srgb);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting the RGB image to a grayscale intensity image, and replacing
% zeros with nonzero neighbors in the depth map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I_gray = rgb2gray(I_rgb);
I_norm = Kinect_DepthNormalization(I_d);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting depth map before and after normalization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% subplot(1,2,1), imagesc(I_d), axis image, colormap(jet), 
%                 title('Depth map before normalization');
% 
% subplot(1,2,2), imagesc(I_norm), axis image, colormap(jet), caxis([0, max(I_d(:))]),
%                 title('Depth map after normalization');                

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the edged E in the depth map, and the edged E2 in the grayscale
% image using MATLAB Canny detecor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                 T1    T2   SIGMA
[E, t] = edge(I_norm, 'canny', [0.0001 0.1], 2.5);
[E2, t2] = edge(I_gray, 'canny', [], 3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using various morphological operations with MATLAB's bwmorph to obtain
% the filled regions of the object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = bwmorph(E, 'thicken', 3); % To thicken the edges
E2 = bwmorph(E2, 'thicken', 3);
E = bwmorph(E, 'close', Inf); % To close and connect the edges
E2 = bwmorph(E2, 'close', Inf);
E = imfill(E, 'holes'); % To fill in the region
E2 = imfill(E2, 'holes');
R = bwmorph(E, 'erode', 2); % To erode away some extra area because of the thickening
R2 = bwmorph(E2, 'erode', 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using bwconncomp to get the connected components CC from the regions and
% store it in the Components_d and Components_rgb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Components_d{i} = bwconncomp(R);
Components_rgb{i} = bwconncomp(R2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the countour of the region with MATLAB's bwmorph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = bwmorph(R, 'remove');
E2 = bwmorph(R2, 'remove');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding the skeleton of the region with MATLAB's bwmorph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = bwmorph(R, 'skel', Inf);
S2 = bwmorph(R2, 'skel', Inf);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected edges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% [y, x] = find(E);
% subplot(1,2,1), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'ys'), title('Edges detected from depth map');
% 
% [y, x] = find(E2);
% subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'ys'), title('Edges detected from RGB image');
% 
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected regions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
[y, x] = find(R);
subplot(1,2,1), imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(x,y,'y.'), title('Region detected from depth map');

[y, x] = find(R2);
subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
	    plot(x,y,'y.'), title('Region detected from RGB image');
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting the detected skeletons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure;
% [y, x] = find(S);
% subplot(1,2,1), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Skeleton detected from depth map');
% 
% [y, x] = find(S2);
% subplot(1,2,2), imagesc(I_rgb), axis image, colormap(gray), hold on
% 	    plot(x,y,'y.'), title('Skeleton detected from RGB image');

end % End of for-loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating how many picture the algorithm were able to extract the
% proper region from
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_d = 0; % # of Sucessful extractions from depth images
n_rgb = 0; % # of Sucessful extractions from RGB images
for i = 1 : N
   CC_d = Components_d{i};
   CC_rgb = Components_rgb{i};
   
   if CC_d.NumObjects == 1 % If the CC structure only has one component => success
       n_d = n_d + 1;
       props{n_d} = regionprops(Components_d{i},'all');

   end
   
   if CC_rgb.NumObjects == 1 % If the CC structure only has one component => success
       n_rgb = n_rgb + 1;
       %rgbprops{n_rgb} = regionprops(Components_rgb{i});
   end
end

% Sucess rates
percent_d = double(n_d/N)*100;
percent_rgb = double(n_rgb/N)*100;

fprintf('Number of images processed: %d\n',N);
fprintf('Percentage of images where we sucessfully extracted \n the object region from the depth map: %3.2d %% \n',percent_d);
fprintf('Percentage of images where we sucessfully extracted \n the object region from the RGB image: %3.2d %% \n',percent_rgb);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Bruke regionprops() på hvert element i Components_d som har 1
% objekt (der vi klarte å detektere konturen). Ut i fra tallene som
% regionprops gir oss, og andre tall vi kan få fra skjellettene osv, så er
% det kanskje mulig å si om det vi ser på er et eple eller ikke?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%