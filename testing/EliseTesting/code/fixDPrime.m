%Using this code to calculate fixed d'

%% Creates Path

clear;

localDataPath = setLocalDataPath(1);

%% Set variables 


% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0;  

% 1 to plot BB values, 0 to skip
plotBBvalues = 0;
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0;
meanttmax = 0.8;

%folder to be averaged
folderName = {'Food', 'Random'};

%Subject to be used
subject = {'13'};                      

%Channels to be tested
channel = ["RT1", "RT2", "RT3", "RT4", "RT5", "RT6", ...
    "ROI5", "ROI6", "ROI7"];

%Establishes plot options
colors = {'-b', '-r', '-c', '-m'};
dashed = {'-+b', '-+r', '-+c', '-+m'};
    
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
    desc_label = 'New_Mbb_norm'; %new normalized data
     
    ss = 1;
    subj = subject{ss};
    currentsubject = subject{ss};
    
%% Loads the data for the subject
    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    
    %Loads old data to access all subject information
    oldData = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
    load(oldData)
    
    %Loads new normalized data
    dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
    
%% 
for i = 1:length(channel) %Loop for electrodes


    for j = 1:length(folderName) %Loop for folders

        %Sets line color and marking to distiguish lines - this only
        %distigushes between folders
        currentcolor = colors{j};
        
        %Sets current folder to be input folderAverageBB
        currentFolder = folderName{j};

        % States which channel it is currently processing
        channel{i};
        channelIdx = find(ismember([all_channels.name],channel{i}));

        %finds the mean and peak value between 0 and 0.2
        [meanbb, peakbb, dMean, stdev] = newFolderAverageBBfunction(localDataPath, currentFolder,...
            currentsubject, channelIdx, graphttmin, graphttmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
            tt, all_channels, eventsST, New_Mbb_Norm, currentcolor, channel(i));
        
        
        %stdev = std(ttavgBB)
        %stdevresults(i, j, n) = stdev;
        stdevresults(i, j) = stdev;
        stdev
        
        dMeanresults(i, j) = dMean;
        
    end 
    
    %Calculates and prints d'
    [Dprime] = CalcDPrime(i, j, n, dMeanresults, stdevresults);
     Prime(i) = Dprime';
     rePrime = Prime';
end

        