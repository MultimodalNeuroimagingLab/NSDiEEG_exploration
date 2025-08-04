function [meanavgBB,standardDeviation, variance] = dPrimeAverageBB( ...
    folderName, channelcurrent, meanttmin, meanttmax, ...
    tt, shared_idx, New_Mbb_Norm, nsd_repeats)  
%dPrimeAverageBB returns the mean and standard devation of the broadband
%values of a certain channel, subject, and image folder
   
    %Gets list of the indexes of the images within the folder   
    sharedimageidxs = folder_idxs(folderName);


    % finds the first repeat of the images
    Special1000idx = find(nsd_repeats <= 1);    
    shared_idx1000 = shared_idx(Special1000idx, 1);
    shared_idx1000 = shared_idx1000';


    %Finds the shared_idx in the order of images shown
    image_idxOrderShown = find(ismember(shared_idx1000, sharedimageidxs));

    %Finds the Normalized BB values of images in the folder:
    NormalizedBBValues = squeeze(New_Mbb_Norm(channelcurrent, :, image_idxOrderShown));
    ttNormalizedBBValues = NormalizedBBValues((tt>=meanttmin & tt<=meanttmax), :);

    %Creates average BB between ttmin and ttmax for each image 
    avgBB = mean(ttNormalizedBBValues,1, 'omitnan');

    %Takes the standard deviation of the means of each image
    standardDeviation = std(avgBB);
    variance = var(avgBB, 1, 'omitnan');

    %Returns the mean of all the images from ttmin to ttmaz
    meanavgBB=mean(avgBB);

end 
    




