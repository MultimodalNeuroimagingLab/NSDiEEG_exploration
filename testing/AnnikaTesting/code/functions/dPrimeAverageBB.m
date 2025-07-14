function [meanavgBB,standardDeviation] = dPrimeAverageBB( ...
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
    image_idxOrderShown = (ismember(shared_idx1000, sharedimageidxs));

    %Finds the Normalized BB values of images in the folder:
    NormalizedBBValues = squeeze(New_Mbb_Norm(channelcurrent, :, image_idxOrderShown));
    ttNormalizedBBValues = NormalizedBBValues(find(tt>=meanttmin & tt<=meanttmax), :);

    %{
    BBvaluesList = [];
    SidewaysAllBBValues = AllBBValues';
    %Finds the BB values of all the images in the folder:
    for i = 1:length(imageidxs)
        BBvalues(:, i) = AllBBValues(:,imageidxs(i));
        BBvaluesList = [BBvaluesList SidewaysAllBBValues(imageidxs(i),:)];
    end
    %}

    %Creates average BB between ttmin and ttmax for each image 
    avgBB = mean(ttNormalizedBBValues,1);
    
    %{
    %Finds the standard deviation of all broadband values between 
    % t=meanttmin to t=meanttmax of each individual image (before creating mean of
    % images)
    standardDeviationRows=std(ttNormalizedBBValues, 0, 1);
    standardDeviationColumns=std(ttNormalizedBBValues, 0, 2);
    standardDeviation = sqrt((standardDeviationRows.^2) + (standardDeviationColumns.^2));
    %}

    %Takes the standard deviation of the means of each image
    standardDeviation = std(avgBB);

    %Returns the mean from t=meanttmin to t=meanttmax
    meanavgBB=mean(avgBB);

end 
    




