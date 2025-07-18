% Creates a list of mean contrasts of images in a folder, also lists the
% mean contrast of the entire folder.

%Folder of images to find the contrasts of
foldername = 'Experiment6Buildings';

localDataPath = setLocalDataPath(1);

%path to the folder containing information about the contrast of images
contrastpath = localDataPath.contrast;

%Loads the file with the contrast data
load(fullfile(contrastpath, 'contrastMeans1000')); 

%path to the folders of different types of images
imageFolderPath = localDataPath.imFolders;

%Finds the shared indexes of the images in the folder
imageidxs = folder_idxs(foldername, imageFolderPath);

%The contrast information is in Shared index order, so no need to convert
%to the order of images shown

%Will list the shared index in the first column and the the contrasts of the 
% images in the second column
imageContrasts = zeros(length(imageidxs), 2, 'single');


for image = 1:length(imageidxs)
    
    %Records the shared image index in the first column
    imageContrasts(image, 1)= imageidxs(1, image);

    %Records the contrast in the second column
    imageContrasts(image, 2)= contrastnum(imageidxs(image));

end

%Will store the average contrast of the folder
averageFolderContrast = mean(imageContrasts(:,2));