% This script will run on Morgan's shared1000_gaborFilt01_sz336_cpd3_DN_r1_s0_imgs
% to create 1x1000 array that contains one number per image rating its
% amount of contrast 

localDataPath = setLocalDataPath(1);

%path to the folder containing information about the contrast of images
contrastpath = localDataPath.contrast;

%Loads the file with the contrast data
load(fullfile(contrastpath, 'shared1000_gaborFilt01_sz336_cpd3_DN_r1_s0.mat'));

% Preallocates the size of the array containing the results
contrastnum = zeros(1000,  1, 'single');

%Loops through all 1000 images
for image=1:1000
    % Takes all the contrast values for the current image
    row = stimuliFinal(image, :);
    
    % Remove zero-padding
    validPixels = row(row > 0);
    
    % Calculate mean contrast energy for the current image
    meancontrast = mean(validPixels);

    %Assigns the contrast number to the proper place in a results variable
    contrastnum(image) = meancontrast;
end