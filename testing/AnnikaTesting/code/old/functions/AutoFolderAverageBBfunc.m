function [meanavgBB,peakavgBB, BB, standError] = AutoFolderAverageBBfunc( ...
    folderName, subject, channel, channelidx, graphttmin, graphttmax, ...
    meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, New_Mbb_Norm,...
    tt, currentcolor, shared_idx, nsd_repeats, localImageFolderPath)
%FOLDERAVERAGEBB displays a graph of the average broadbands (with error bars) 
% of all the images in a folder between two specified timepoint. It also
% returns the mean of this graph between two specified timepoints.

%This is used in AutoFolderAverageBB and NormAutoFolderAverageBB
    
%folderName is the folder to be averaged
%subject is the subject to be used (current subject)
%channel is channel to be used (current channel)
  
    
%NotFolder is 0 for all images in folder, 1 for all images in the shared 1000 besides what is in this folder,
    
%plots values from graphttmin to graphttmax
%plotBBvalues is 1 to plot BB values, 0 to skip
    
%takes mean from meanttmin to meanttmax
%findmean is 1 to find the mean of BB values over 0 to 0.2, 0 to skip


%% The actual folderAverageBB process
  
    %finds BBValues of all the images in the current channel
    AllBBValues = squeeze(New_Mbb_Norm(channelidx, :, :));

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

    if plotBBvalues == 1
        %each row is a channel, each column is a time. Empty if no graph is plotted
        graphStandardError = [];
        
        ttt = tt(tt>=graphttmin & tt<=graphttmax);
        
        %Finds all the BBValues of the images in the folder
        BBvalues = [];
        for i = 1:length(imageNumberShown)
            BBvalues(:, i) = AllBBValues(:,imageNumberShown(i));
        end
    
        % BBvalues for requested time frame
        ttBBvalues = BBvalues((tt>=graphttmin & tt<=graphttmax), :);

        %Averages all of the BBValues of the images in the folder
        avgBB = mean(BBvalues,2);

        % Averages only within requested time frame
        ttavgBB = avgBB(tt>=graphttmin & tt<=graphttmax);
        BB = ttavgBB;


        %calculates the standardError
        for i = 1:length(ttt)
               graphStandardError(1,i)=(std(ttBBvalues(i,:)))/sqrt(length(ttBBvalues(i,:)));
        end
        standError = graphStandardError;

        %plots the mean of all the images
        plot(ttt,ttavgBB);
        
        title(append(folderName, ', Subject-', subject, ': ', channel{1}));
        xlabel('Time (seconds)')
        ylabel('Broadband Power (% signal change)')
        shadedErrorBar(ttt,ttavgBB,graphStandardError, 'lineprops', currentcolor,'patchSaturation',0.075);
        
        ylim([0,1]);
        hold on;
        
    
    else
        standError = NaN;
        BB = NaN;


    end

    if findmean == 1
        ttt = find(tt>=meanttmin & tt<=meanttmax);

        %Finds all the BBValues of the images in the folder
        BBvalues = [];
        for i = 1:length(imageNumberShown)
            BBvalues(:, i) = AllBBValues(:,imageNumberShown(i));
        end
        
        %Creates average BB over whole folder
        avgBB = mean(BBvalues,2);
        
        %Saves only the tt asked for
        ttavgBB = avgBB(ttt);

        %Returns the mean from t=meanttmin to t=meanttmax
        meanavgBB=mean(ttavgBB);
        
        %Returns peak BB from t=meanttmin to t=meanttmax
        peakavgBB = max(ttavgBB');

    else
        meanavgBB = NaN;
        peakavgBB = NaN;

    end
    



end

