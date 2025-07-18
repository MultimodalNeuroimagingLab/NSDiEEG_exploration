function [d] = DprimeFunction(folderName,OtherFolders, channelIdx, tt, ...
    shared_idx, Mbb_Norm_perRun, nsd_repeats, meanttmin, meanttmax)
%% This will find the D Prime values between one folder of images and one other folder

%folder to be compared is folderName

% folders to which the main folder is being compared is OtherFolders


    %Gets the mean of the images in the selected folder over the selected time period
    [folderMeanBB,~, foldervar] = dPrimeAverageBB(folderName, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats);  
    
    [notFolderMeanBB,~, notfoldervar] = dPrimeAverageBB(OtherFolders, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, Mbb_Norm_perRun, nsd_repeats);
     
    numerator = folderMeanBB - notFolderMeanBB;

    denominator = sqrt(0.5*((foldervar)+(notfoldervar)));

    d = numerator/denominator;


end



