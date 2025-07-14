%% Averages BB of a folder of images, graphs average BB, and finds the mean/peak  
% This program averages the normalized broadband of images in a user-specified 
% file. Then, it can either graph this broadband or take the mean. The graph  
% and mean are between user-specified time points. This program can loop 
% through multiple electrodes or folders.

%There are three versions of this script
    % AutoFolderAverageBB: loads normalized AND preproc data
    % (uses pre-proc data to load EventsST, tt, and all_channels which is 
    % not included in New_Mbb_Norm)

    % NormAutoFolderAverageBB: Only loads normalized (EventsST, tt, and all_channels 
    % are within the normalized data upload)

    % (current) ImageFolderAnalysis: Same as NormAutoFolderAverageBB, but organized
    % better and easier to understand


clear;

localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;

%path to the folders of different types of images
imageFolderPath = localDataPath.imFolders;

% 1 to plot BB values, 0 to skip (plot from graphttmin to graphttmax)
plotBBvalues = 1;    
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find mean of BB values over meanttmin to meanttmax, 0 to skip
findmean = 1;         
meanttmin = 0;
meanttmax = 0.4;


%folders of images to be averaged
folderName =  {'Experiment6Food', 'Experiment6Random'};


%Subject to be used
subject='20';                      

%Channels to be tested
channel =  {"LOC7"};


%Colors for each graph (in the same order as the list)
colors = {'-k', '-g', '-k', '-c', '-m', '-y', '-k', '-b', '-g', '-r'};


% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0;  


%% Loads Variables and NORMALIZED broadband data
    
    % Choose an analysis type:
    desc_label = 'EachImage';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_vars', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    
    load(Path_Mbb_Norm)
  
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%% Actual Process
%Stores the average BB results of each time point in the folders
BBvaluesOverTime = zeros(length(folderName),length(tt), length(channel));

%Stores mean results, columns are folders and rows are electrodes
meanresults = zeros(length(channel), length(folderName));

%Stores peak results, columns are folders and rows are electrodes
peakresults = zeros(length(channel), length(folderName));

% Calls the folderAverageBBfunction for each given electrode and folder
for i = 1:length(channel)
    % States which channel it is currently processing
    currentchannel = channel{i}
    
    %finds the current channel
    channelidx = find(ismember([all_channels.name],currentchannel));
       
    for j = 1:length(folderName)
    
        %States current folder
        currentFolder = folderName{j}
        
        %finds BBValues of all the images 
        folderBBvalues = squeeze(New_Mbb_Norm(channelidx, :, :));

        % Finds the average broadband values of the folder
        [folderBB, folderStE] = BBAverageImageFolder(currentFolder,...
            NotFolder, folderBBvalues, shared_idx,nsd_repeats, imageFolderPath);
        
        % Stores the average normalized BB values and standard error of the current folder
        % Every row is a different folder and every column is a time
        BBvaluesOverTime(j,:,i) = folderBB;
        GraphStandardErrors(j, :, i) = folderStE;


        if findmean == 1 
            % Finds the mean from meanttmin to meanttmax
            [BBmean,BBpeak] = BBmeanAndPeak(folderBB, meanttmin, meanttmax, tt);
            
            % Stores then prints the mean calculated above
            meanresults(i,j) = BBmean;
            fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), ' is:'));
            BBmean

            % Stores then prints the peak calculated above
            peakresults(i,j)   = BBpeak;
            fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), ' is: '));
            BBpeak

        end

        if plotBBvalues == 1    
            % Picks the current color for the graph (i to switch every channel, j to switch
            % every folder)
            currentcolor = colors{j};

            % plots BBvalues as y and tt as x (with error bars using
            % standard error)
            plotBB(folderBB, folderStE, graphttmin, graphttmax, currentcolor, tt)

        end
       
    
    end
    
    if plotBBvalues == 1
        legend(folderName)
        title(append("Folder Comparison, Subject-", subject, ": ", currentchannel))
    end

    
    


end

