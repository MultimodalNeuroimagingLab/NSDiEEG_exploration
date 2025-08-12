%% Averages BB of a folder of images, graphs average BB, and finds the mean/peak  
% This program averages the normalized broadband of images in a user-specified 
% file. Then, it can either graph this broadband or take the mean. The graph  
% and mean are between user-specified time points. This program can loop 
% through multiple electrodes or folders.

%There are four versions of this script
    % AutoFolderAverageBB: loads normalized AND preproc data
    % (uses pre-proc data to load EventsST, tt, and all_channels which is 
    % not included in New_Mbb_Norm)

    % NormAutoFolderAverageBB: Only loads normalized (EventsST, tt, and all_channels 
    % are within the normalized data upload)

    % (current) ImageFolderAnalysis: Same as NormAutoFolderAverageBB, but organized
    % better and easier to understand

    % RECOMMENDED:
    % ImageFolderAnalysis_SubjectLoop: Same as ImageFolderAnalysis, but 
    % is able to loop through multiple subjects. It can also calculates d'


clear;
%%
localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;

%path to the folders of different types of images
imageFolderPath = localDataPath.imFolders;

%%
% 1 to plot BB values, 0 to skip (plot from graphttmin to graphttmax)
plotBBvalues = 1;    
graphttmin = -2;
graphttmax = 2;

% 1 to find mean of BB values over meanttmin to meanttmax, 0 to skip
findmean = 1;         
meanttmin = 0.1;
meanttmax = 0.5;


%folders of images to be averaged
folderName = {'faceTowards',	'Human',	'Animal', 'notAlive'};%	'Objects'};%,	

%Subject to be used
subject='06';                      

%Channels to be tested
channel = {"ROC10"};

%Colors for each graph (in the same order as the list)
colors = {'-b', '-r', '-y', 'g'};
legendcolor = [0.00, 0.00, 1.00;1.00, 0.00, 0.00; 1.00, 1.00, 0.00; 0.00, 1.00, 0.00];
%{
colors = {'-b', '-r'};
legendcolor = [0.00, 0.00, 1.00;1.00, 0.00, 0.00];

colors = {'-b', 'g', '-c', '-m', '-r', '-y'};
legendcolor = [0.00, 0.00, 1.00; 0.00, 1.00, 0.00; 0.00, 1.00, 1.00; ...
    1.00, 0.00, 1.00; 1.00, 0.00, 0.00; 1.00, 1.00, 0.00];

colors = {'-b', '-k', '-r' };
legendcolor = [0.00, 0.00, 1.00; 0.00, 0.00, 0.00;1.00, 0.00, 0.00];
%}


%0 to create a separate graph for each electrode, 1 to graph all on one.
allElectrode = 0;

% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0;  

% 0 to find a folder of images to analyze, 1 to create indexes based off an
% excel sheet
annotatedImages = 1;

%If folders chosen are different sizes, input the number wanted from each
%folder, and the code will select that many random images from the folder.
%Max size is one less than the size of the smallest folder.
%(Put 0 if the current folder size is fine)
folderSize = 0;

%% Loads Variables and NORMALIZED broadband data
    
    % Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_perRun', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    
    fprintf("Loading Normalized Broadband Data...")
    load(Path_Mbb_Norm)
  
    fprintf("Loading variables...")
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

    fprintf("Everything has loaded.")

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
       
    %finds BBValues of all the images in the channel
    channelBBvalues = permute(Mbb_Norm_perRun(channelidx, :, :), [2 3 1]);

    if (allElectrode == 0) && (plotBBvalues == 1)
        figure;
    end

    for j = 1:length(folderName)
    
        %States current folder
        currentFolder = folderName{j}
        
        % Finds the average broadband values of the folder
        [folderBB, folderStE, imageBB] = BBAverageImageFolder(currentFolder,...
            NotFolder, channelBBvalues, shared_idx,nsd_repeats, imageFolderPath,...
            annotatedImages, folderSize);
        
        % Stores the average normalized BB values and standard error of the current folder
        % Every row is a different folder and every column is a time
        BBvaluesOverTime(j,:,i) = folderBB;
        GraphStandardErrors(j, :, i) = folderStE;


        if findmean == 1 
            % Finds the mean from meanttmin to meanttmax
            [BBmean,BBpeak, BBmedian] = BBmeanAndPeak(folderBB, meanttmin, meanttmax, tt);
            
            % Stores then prints the mean calculated above
            meanresults(i,j) = BBmean;
            fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), ' is:'));
            BBmean

            % Stores then prints the peak calculated above
            peakresults(i,j)   = BBpeak;
            fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), ' is: '));
            BBpeak

            % Stores the BBmedian calculated above
            medianresults(i,j) = BBmedian;

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
    
    if (plotBBvalues == 2) && ((allElectrode == 0) || (length(channel)==1))
        hold on

        % Preallocate handles for the legend
        handles = gobjects(length(folderName), 1);
        
        for i = 1:length(folderName)
            % Create dummy plots for the legend only
            handles(i) = plot(NaN, NaN, 'LineWidth', 2, 'Color', legendcolor(i,:));
        end

        % Create legend using the folder names
        legend(handles, folderName, 'Location', 'best');y

        %Creates title
        title(append("Folder Comparison, Subject-", subject, ": ", currentchannel))

    elseif (plotBBvalues == 2)
        hold on

        % Preallocate handles for the legend
        handles = gobjects(length(folderName), 1);
        
        for i = 1:length(folderName)
            % Create dummy plots for the legend only
            handles(i) = plot(NaN, NaN, 'LineWidth', 2, 'Color', legendcolor(i,:));
        end

        % Create legend using the folder names
        legend(handles, folderName, 'Location', 'best');

        %Creates title
        title(append("Folder Comparison, Subject-", subject, ": multiple channels"))
    end
    ylim([-0.05,0.4]);
    title(append("Folder Comparison, Subject-", subject, ": ", currentchannel))
    legend(folderName);
end

