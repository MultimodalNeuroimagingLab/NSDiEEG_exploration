function [meanavgBB,peakavgBB, dMean, stdev] = newFolderAverageBBfunction(localDataPath, ...
    nameFolder, subjectcurrent, channelcurrent, graphtttmin, graphtttmax,...
    meanttmin, meanttmax, notf, plotBB, meanBB, ...
    tt, all_channels, eventsST, New_Mbb_Norm, colors, titles, folders)

%Created by Annika and used by Elise
%FOLDERAVERAGEBB displays a graph of the average broadbands of all the
%images in a folder and returns those values

    lclDataPath = localDataPath;
    folderName = nameFolder; %folder to be averaged
    subject=subjectcurrent; %Subject to be used
    channel = channelcurrent; %Channel to be used
    NotFolder = notf; % 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder,
    
    %plots values from graphttmin to graphttmax
    plotBBvalues = plotBB; % 1 to plot BB values, 0 to skip
    
    %takes mean from meanttmin to meanttmax
    findmean = meanBB; % 1 to find the mean of BB values over 0 to 0.2, 0 to skip
    sel_events = eventsST;

    % extract relevant information from events file:
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);
  
    AllBBValues = squeeze(New_Mbb_Norm(channelcurrent, :, :));
%% Loads Variables  (Not needed if loading variables outside of this function)  
 %{
    subjects = {subject};%0654
    % Choose an analysis type:
    desc_label = 'preprocCARBB';
     
    ss = 1;
    subj = subjects{ss};

   

    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    dataFitName = fullfile(lclDataPath,'derivatives','preproc-car', ['sub-' subject],...
    ['sub-' subject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
    %}


%% The actual folderAverageBB process
    %Gets list of the indexes of the images within the folder   
    sharedimageidxs = folder_idxs(folderName);
    
   
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
        graphSEM = [];
       
        
        %finds the BBValues of all the images 
        %AllBBValues = ReducedCalculateBBValues(channel, graphtttmin, graphtttmax, ...
        %tt, all_channels, eventsST, Mbb);
       
        
        ttt = tt(tt>=graphtttmin & tt<=graphtttmax);
        
        %Finds all the BBValues of the images in the folder
        BBvalues = [];
        for i = 1:length(imageNumberShown)
            BBvalues(:, i) = AllBBValues(:,imageNumberShown(i));
        end
        
        ttBBvalues = BBvalues((tt>=graphtttmin & tt<=graphtttmax), :);
        
        %Calulcates the standard error of the mean
        graphSEM = zeros(1, length(ttt));
        for i = 1:length(ttt)
            graphSEM(1,i)=(std(ttBBvalues(i,:)))/sqrt(length(ttBBvalues(i,:)));
        end
        
        
        %Averages all of the BBValues of the images in the folder
        avgBB = mean(BBvalues,2);
        
        ttavgBB = avgBB(tt>=graphtttmin & tt<=graphtttmax);
        
        %Calculating 95% confidence intervals - currently not working
        %ttavgflip = ttavgBB'; %have to flip ttavgBB for errors
        %tttflip = ttt';
        %[h,conf] = ieeg_plotCurvConf(ttt, ttavgflip);

        plot(ttt, ttavgBB)
        set(gca, 'FontSize', 14)
        shadedErrorBar(ttt, ttavgBB, graphSEM, 'lineprops', colors, 'patchSaturation', 0.15)
        ylim([-0.2,1]); hold on;
        
        title(titles, 'FontSize', 18)
        xlabel('Time(s)', 'FontSize', 16)
        ylabel('Broadband Power (Signal Change)', 'Fontsize', 16); hold on;
    end

    if findmean == 1
        %Does the same thing again but over time 0 to time 0.2:
        %AllBBValues = ReducedCalculateBBValues(channel, meanttmin, meanttmax, ...
        %tt, all_channels, eventsST, Mbb);

    
        BBvalues = [];
        for i = 1:length(imageNumberShown)
            BBvalues(:, i) = AllBBValues(:,imageNumberShown(i));
        end
        
        ttBBvalues = BBvalues((tt>=meanttmin & tt<=meanttmax), :);
        
        %Creates average BB over whole folder
        avgBB = mean(BBvalues,2);
        
        %ttavgBB = mean(ttBBvalues);
        ttavgBB = avgBB(tt>=graphtttmin & tt<=graphtttmax);
    
        %Returns the mean
        meanavgBB=mean(ttavgBB);
        
        %Returns peak BB
        peakavgBB = max(ttavgBB');
    

        


    end
    

   currentImages = squeeze(New_Mbb_Norm(channel, :, imageNumberShown));
   ttcurrentImages = currentImages(find(tt>=meanttmin & tt<=meanttmax), :, :);
   meanImages = mean(ttcurrentImages, 1);
   stdev = var(meanImages, 1, 'omitnan');
   dMean = mean(meanImages);
end

