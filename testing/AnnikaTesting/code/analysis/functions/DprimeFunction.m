function [d] = DprimeFunction(folderName,OtherFolders, channelIdx, tt, ...
    shared_idx, Mbb_Norm_perRun, nsd_repeats, meanttmin, meanttmax, annotatedImage)
%% This will find the D Prime values between one folder of images and one other folder

%folder to be compared is folderName

% folders to which the main folder is being compared is OtherFolders

    %Gets list of the indexes of the images within the folder   
    if annotatedImage == 0
        sharedimageidxs = folder_idxs(folderName);
        sharedimageidxs_other = folder_idxs(OtherFolders);
    else
        sharedimageidxs = annotatedImages_idx(folderName);
        sharedimageidxs_other = annotatedImages_idx(OtherFolders);
    end

    %Gets the mean of the images in the selected folder over the selected time period
    [folderMeanBB,~, foldervar] = dPrimeAverageBB(folderName, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats, sharedimageidxs);  
    
    [notFolderMeanBB,~, notfoldervar] = dPrimeAverageBB(OtherFolders, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats, sharedimageidxs_other);
     
    numerator = folderMeanBB - notFolderMeanBB;

    denominator = sqrt(0.5*((foldervar)+(notfoldervar)));

    d = numerator/denominator;


end



