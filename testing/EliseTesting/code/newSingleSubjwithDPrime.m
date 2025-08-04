%Original code written by Annika
%Elise Springman made a few chagnes for my specific project

%Calculates and plots the average BB signal for a selected folder(s) of
%images and outputs mean, peak, standard deviation, and d'

%This variation loops through multiple subjects for comparison
%% Creates Path

clear;

localDataPath = setLocalDataPath(1);


%% Set variables 


% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0; 

% 0 for graphing electrodes on their own graph
allElectrode = 0;

% 1 to plot BB values, 0 to skip
plotBBvalues = 1;
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0.4;
meanttmax = 0.8;

%folder to be averaged
folderName = {'Food', 'Random'};

%Subject to be used
subject = {'02'};                      

%Channels to be tested
channel = ["LO5", "LO6"];

%Establishes plot options
colors = {'-r', '-b', '-c', '-m'};
dashed = {'-+r', '-+b', '-+c', '-+m'};
legendColors = {[1 0 0], [0 0 1], [0 1 1], [1 0 1]};  % Blue, red, cyan, magenta

    
% "LOC3", "LOC4", "LOC5"};

%{
{"LG6", "LG7", "LG8", "LB6", "LB7", "LB8", "LC2" ...
    "LC6", "LC7", "LT6", "LT7", "LT8", "LT9", ...
    "LOC6", "LOC7", "LOC8" }; 
%}

%Stores results, column 1 is avg and column 2 is peak
%results = zeros(length(channel), 2);
meanresults = zeros(length(channel), length(folderName));
peakresults = zeros(length(channel), length(folderName));


% Maximum time to be plotted (mean is between 0 and 0.2)
%ttmax = 0.8;
%ttmin = -0.1;

%n variable needed for DPrime function because this code uses one
%suject
n = 1;

%Set subject
    subjects = {subject};
    % Choose an analysis type:
    desc_label = 'normalizedMbbPerRun'; %new normalized data
     
    ss = 1;
    subj = subject{ss};
    currentsubject = subject{ss};

  
%% Loads the data for the subject
    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    
    %Loads old data to access all subject information
    %oldData = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    %['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
    %load(oldData)
    
    %Loads new normalized data
    dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
 
%% Calls the folderAverageBBfunction for each given electrode
%This code uses the new normalized data

for i = 1:length(channel) %Loop for electrodes

    %Creates new graph for each electrode
    if (allElectrode == 0) && (plotBBvalues == 1)
        figure;
    end

    for j = 1:length(folderName) %Loop for folders

        %Sets line color and marking to distiguish lines - this only
        %distigushes between folders
        currentcolor = colors{j};
        
        %Sets current folder to be input folderAverageBB
        currentFolder = folderName{j};

        % States which channel it is currently processing
        channel{i};
        channelIdx = find(ismember([all_channels.name],channel{i}));

        %finds the mean and peak values
        [meanbb, peakbb, dMean, stdev] = newFolderAverageBBfunction(localDataPath, currentFolder,...
            currentsubject, channelIdx, graphttmin, graphttmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
            tt, all_channels, eventsST, Mbb_Norm_Run, currentcolor, channel(i));



        % Stores then prints the mean calculated above
        meanresults(i,j)   = meanbb;

        fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
        meanbb

        % Stores then prints the peak calculated above
        peakresults(i,j)   = peakbb;

        fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
        peakbb

        %stdev = std(ttavgBB)
        %stdevresults(i, j, n) = stdev;
        stdev
        stdevresults(i, j) = stdev;
        
        dMeanresults(i, j) = dMean;

    end
    
    %Calculates and prints d'
    [Dprime] = CalcDPrime(i, j, n, dMeanresults, stdevresults);
    Prime(i) = Dprime;
    rePrime = Prime';

    %Add a legend to the plot - this doesn't always work right
    if (allElectrode == 0) && (plotBBvalues == 1)
        % Create invisible dummy lines for the legend
    hold on;
    legendHandles = gobjects(length(folderName), 1);  % Preallocate graphics handles

    for j = 1:length(folderName)
        legendHandles(j) = plot(nan, nan, '-', 'Color', legendColors{j}, 'LineWidth', 2);
    end

    legend(legendHandles, folderName, 'Interpreter', 'none', 'FontSize', 14);
    

    end
    
end

%Calculates and prints d'
%[Dprime] = CalcDPrime(i, j, n, dMeanresults, stdevresults);
%Dprime

%Add a legend to the plot - this doesn't always work right
%if plotBBvalues == 1
 %   legend(folderName)
%end


