function [folderBB, folderStandardError, imageBB] = BBAverageImageFolder( ...
    folderName, NotFolder, AllBBValues, ...
    shared_idx, nsd_repeats, localImageFolderPath, annotatedImage, folderSize)

    % BBAverageImageFolder calculates the average broadband and standard error 
    % of the images in the folder (excluding any repeats). It returns the
    % mean across images at each time point (folderBB) and the mean across
    % time points for each image (imageBB).

    folderStandardError = [];

    %Gets list of the indexes of the images within the folder   
    if annotatedImage == 0
        sharedimageidxs = folder_idxs(folderName, localImageFolderPath);
    else
        sharedimageidxs = annotatedImages_idx(folderName);
    end

    %Selects a given number (folderSize) of random images from the folder
    newsharedimageidxs = [];
    if folderSize > 0
        for i = 1:folderSize
          currentRandNum = randi([1,length(sharedimageidxs)]);
          newsharedimageidxs(i)=sharedimageidxs(currentRandNum);
          sharedimageidxs(currentRandNum)=[];
        end
        sharedimageidxs = sort(newsharedimageidxs);
    end


    %The following sets the image index to all the images not in the folder
    isNotInFolder = ones(1,1000);
    for k=1:length(sharedimageidxs)
        isNotInFolder(sharedimageidxs)=0;
    end
    notIndex = find(isNotInFolder);
    if NotFolder == 1
        sharedimageidxs = notIndex;
    end

    % finds the first repeat of the images
    Special1000idx = find(nsd_repeats <= 1);    
    shared_idx1000 = shared_idx(Special1000idx);

    %Finds the shared_idx in the order of images shown
    imageNumberShown = find((ismember(shared_idx1000', sharedimageidxs)));

    
       
    %Finds all the BBValues of the images in the folder
    BBvalues = [];
    for i = 1:length(imageNumberShown)
        BBvalues(:, i) = AllBBValues(:,imageNumberShown(i));
    end
    
    

    % One number (mean of all images) for each time point
    folderBB = mean(BBvalues,2, 'omitnan');

    % One number (mean of all time points) for each image 
    imageBB=mean(BBvalues,1, 'omitnan');
    
    % One number (standard deviation across images) for each time point
    folderStandardError(1, :)=(std(BBvalues, 0, 2))/sqrt(length(BBvalues(1,:)));
end   
    