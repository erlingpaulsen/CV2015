function [set, picNum]  = dataset(folderpath, t2,n)
%% Datasetfunction
% this function takes in a folderpath folder, treshold and a number
% n, with n being number of images in folder, and returns a dataset
% containing the features of the different images in folder.It returns a
% set of features extracted with a function called featurevec,
% and the corresponding image in picNum. 
% 
% Image norm ->find regions -> exctract features -> assemble features

for i=1:n
   %assembles the full path name to extract image
   sd = strcat(folderpath, sprintf('%03d.png', i)); 
   
   %read image
   I_d = imread(sd);
   
   %normalizes the depth image
   I_norm = Kinect_DepthNormalization(I_d);

   %Extracting the usefull region in normalized depth image
   R = regionSeg(I_norm, t2);
   
   %Extracting the features for the specified regions R
   F = featurevec(R);
   
   %Checking if the image is unprocessable, meaning that no region higher 
   %than a spesific area defined in featurevec is detectable, and
   %assembling these features with its image number
   if(~isEmpty(F))
       set = [set; F];
       picNum = [picNum; i];
   end
       
end