function [folderBB, folderStandardError] = BBAverageImageFolder( ...
    folderName, NotFolder, AllBBValues, ...
    shared_idx, nsd_repeats, localImageFolderPath)

    % AverageImageFolderBB calculates the average broadband and standard error 
    % of the images in the folder (excluding any repeats). 

    folderStandardError = [];

    %Gets list of the indexes of the images within the folder   
    sharedimageidxs = folder_idxs(folderName, localImageFolderPath);
   
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
    
    
    %Averages all of the BBValues of the images in the folder
    folderBB = mean(BBvalues,2);
    
    folderStandardError(1, :)=(std(BBvalues, 0, 2))/sqrt(length(BBvalues(1,:)));
end   
    