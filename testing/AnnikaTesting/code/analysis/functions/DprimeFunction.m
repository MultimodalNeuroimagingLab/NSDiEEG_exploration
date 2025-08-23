function [d] = DprimeFunction(folderName,OtherFolders, channelIdx, tt, ...
    shared_idx, Mbb_Norm_perRun, nsd_repeats, meanttmin, meanttmax, annotatedImage)
%% DPRIMEFUNCTION will find the D Prime values between the broadband values of a folder of images and one other folder

%folder to be compared is folderName
%folder to which the main folder is being compared is OtherFolders

    %Gets list of the indexes of the images within the folder   
    if annotatedImage == 0
        sharedimageidxs = folder_idxs(folderName);
        sharedimageidxs_other = folder_idxs(OtherFolders);
    else
        sharedimageidxs = annotatedImages_idx(folderName);
        sharedimageidxs_other = annotatedImages_idx(OtherFolders);
    end

    %Gets mean of the images in the selected folder over selected time period
    [folderMeanBB,~, foldervar] = dPrimeAverageBB(folderName, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats, sharedimageidxs);  
        
    %Gets mean of the images in the selected NOT folder over selected time period
    [notFolderMeanBB,~, notfoldervar] = dPrimeAverageBB(OtherFolders, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats, sharedimageidxs_other);
     

    % Uses the d' equation to calculate the d' from the mean and variance
    numerator = folderMeanBB - notFolderMeanBB;

    denominator = sqrt(0.5*((foldervar)+(notfoldervar)));

    d = numerator/denominator;


end



