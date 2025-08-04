%Original code written by Annika
%Some changes made by Elise Springman for my specific project

%Calculates and plots the average BB signal for a selected folder(s) of
%images and outputs mean, peak, standard deviation, and d'
%This variation loops through multiple subjects for comparison

%% Creates Path

clear;

localDataPath = setLocalDataPath(1);

%%

% 0 for all images in folder, 1 for all images in the 1000 besides what is in this folder
NotFolder = 0;  

% 1 to plot BB values, 0 to skip
plotBBvalues = 1;
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find the mean of BB values over 0 to 0.2, 0 to skip
findmean = 1; 
meanttmin = 0;
meanttmax = 0.8;

%folder to be averaged
folderName = {'Food', 'Random'};

%Subject to be used
subject = {'20'};                      

%Channels to be tested
channel = ["LC2"];

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



    subjects = {subject};%0654
    % Choose an analysis type:
    desc_label = 'New_Mbb_norm';
     
    ss = 1;
    subj = subjects{ss};

  
%% Loads the original data
    % Load NSD-iEEG-broadband data
    % dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
    %dataFitName = fullfile(dataFitPath,'preproc-car', ['sub-' subj],...
    %['sub-' subj '_desc-preprocCARBB_ieeg.mat']);
    %load(dataFitName)
 
%% Calls the folderAverageBBfunction for each given electrode
%This code uses the new normalized data

for n = 1:length(subject) %Loop for subjects
    
    %Sets current subject
    currentsubject = subject{n};
    
    %Loads subject new normalized data - has to do this for each subject
    dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-' desc_label '_ieeg.mat']);
    load(dataFitName)
    %Loads additional data for each subject
    oldData = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
    load(oldData)
    
    for j = 1:length(folderName) %Loop for folders

        %Sets current folder to be input folderAverageBB
        currentFolder = folderName{j};
        
  
        for i = 1:length(channel) %Loop for electrodes
            
            %Sets line color and marking to distiguish folders
            if n == 1
                currentcolor = colors{j};
            elseif n == 2
                currentcolor = dashed{j};
            end
            

            % States which channel it is currently processing
            channel{i};
            channelIdx = find(ismember([all_channels.name],channel{i}));

            %finds the mean and peak value between 0 and 0.2
            [meanbb, peakbb, ttavgBB, stdev] = newFolderAverageBBfunction(localDataPath, currentFolder,...
                currentsubject, channelIdx, graphttmin, graphttmax, meanttmin, meanttmax, NotFolder, plotBBvalues, findmean, ...
                tt, all_channels, eventsST, New_Mbb_Norm, currentcolor, channel(i));



            % Stores then prints the mean calculated above
            meanresults(i,j,n)   = meanbb;

            fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
            meanbb

            % Stores then prints the peak calculated above
            peakresults(i,j,n)   = peakbb;

            fprintf(append('The peak from ', num2str(meanttmin), ' to ', num2str(meanttmax), 'is:'));
            peakbb

            %stdev = std(ttavgBB)
            %stdevresults(i, j, n) = stdev;
            stdev
            stdevresults(i, j, n) = stdev;

        end
    end
end 

%Calculates d'
[Dprime] = CalcDPrime(i, j, n, meanresults, stdevresults);
Dprime

%Adds a legend
if plotBBvalues == 1
    legend(folderName)
end
