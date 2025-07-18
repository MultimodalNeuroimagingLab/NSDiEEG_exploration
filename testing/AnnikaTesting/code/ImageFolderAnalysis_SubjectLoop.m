%% Averages BB of a folder of images, graphs average BB, and finds the mean/peak  
% This program averages the normalized broadband of images in a user-specified 
% file. Then, it can either graph this broadband or take the mean. The graph  
% and mean are between user-specified time points. This program can loop 
% through multiple electrodes or folders.

%This is a version of ImageFolderAnalysis that can run through multiple
%subjects. Further, it automatically calculates dprime values when there
%are only two folders (The first folder will be the main folder and the 
% second will be the "other" folder).


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
graphttmin = -0.1;
graphttmax = 0.8;

% 1 to find mean of BB values over meanttmin to meanttmax, 0 to skip
findmean = 1;         
meanttmin = 0;
meanttmax = 0.4;


%folders of images to be averaged
folderName = {'Experiment8PeopleInteracting', 'Experiment8NotPeople'};

%Subject to be used
subject={'02', '13', '15', '20'};                      

%Channels to be tested
%Put the channels from each subject into different rows.
channel =  {["LG6", "LG7", "LG8", "LB6", "LB7", "LB8", "LC2" ...
    "LC6", "LC7", "LT6", "LT7", "LT8", "LT9", ...
    "LOC6", "LOC7", "LOC8"],... 
    ["RLS1", "RLS2", "RLI1", "RLI2","RLI3","RLI4","RLI5","RLI6","RLM4", "RLM5", "RLM8","RLM9","RLM10"],...
    ["RPO1","RPO2","RPO3","RPO4","RPO5","RPA1","RPA2","RPA3","RPA4","RPA5"],...
    ["LC5","LC6","LT2","LT3","LT4","LT5","LT7","LOC1", "LOC2", "LOC3",...
"LOC6","LOC7","LOC8","LOC9","LOC12", "LOC13","LD1", "LD2", "LD3", "LD4", "LD5", "LD6"]};

%Colors for each graph (in the same order as the list)

colors = {'-b', '-r', '-y', 'g'};
legendcolor = [0.00, 0.00, 1.00;1.00, 0.00, 0.00; 1.00, 1.00, 0.00; 0.00, 1.00, 0.00];
%{
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


%% Loads Variables and NORMALIZED broadband data

%Preallocates the size of the variables
MbbArray = cell(1, length(subject));
ttArray = cell(1, length(subject));
all_channels_array = cell(1, length(subject));
srate_array = cell(1, length(subject));
events_status_Array = cell(1, length(subject));
nsd_idx_Array = cell(1, length(subject));
shared_idx_Array = cell(1, length(subject));
nsd_repeats_Array = cell(1, length(subject));

for sub=1:length(subject)
    
    currentsubject = subject{sub};
    currentsubject

    % Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_PerRun', ['sub-' currentsubject],...
    ['sub-' currentsubject '_normalizedMbb' desc_label '_ieeg.mat']);
    
    fprintf("Loading Normalized Broadband Data...")
    load(Path_Mbb_Norm)
    MbbArray{sub} = Mbb_Norm_perRun;
    ttArray{sub} = tt;
    all_channels_array{sub} = all_channels;
    srate_array{sub} = srate;

    fprintf("Loading variables...")
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status_Array{sub},nsd_idx_Array{sub},shared_idx_Array{sub},nsd_repeats_Array{sub}] = ieeg_nsdParseEvents(sel_events);

    fprintf("Everything has loaded.")

end
%% Actual Process
clearvars tt Mbb all_channels srate nsd_idx shared_idx nsd_repeats dprime

%Stores mean results, columns are folders and rows are electrodes
meanresults = zeros(length(channel), length(folderName), length(subject));

%Stores peak results, columns are folders and rows are electrodes
peakresults = zeros(length(channel), length(folderName), length(subject));

% Preallocates the size of the dprime folder
if length(folderName) == 2
    dprime = zeros(length(channel), length(subject));
end

for k=1:length(subject)
    fprintf('The current subject is sub-%s\n', subject{k});

    %Assigns all variables to the current subject
    Mbb = MbbArray{k};
    tt=ttArray{k};
    all_channels = all_channels_array{k};
    events_status = events_status_Array{k};
    srate = srate_array{k};
    nsd_idx = nsd_idx_Array{k};
    shared_idx = shared_idx_Array{k};
    nsd_repeats = nsd_repeats_Array{k};     

    subChannel = channel{k};

    % Calls the folderAverageBBfunction for each given electrode and folder
    for i = 1:length(subChannel)
        % States which channel it is currently processing
        currentchannel = subChannel{i}
        
        %finds the current channel
        channelidx = find(ismember([all_channels.name],currentchannel));
           
        %finds BBValues of all the images in the channel
        channelBBvalues = permute(Mbb(channelidx, :, :), [2 3 1]);
    
        if (allElectrode == 0) && (plotBBvalues == 1)
            figure;
        end
    
        for j = 1:length(folderName)
        
            %States current folder
            currentFolder = folderName{j}
            
            % Finds the average broadband values of the folder
            [folderBB, folderStE] = BBAverageImageFolder(currentFolder,...
                NotFolder, channelBBvalues, shared_idx, nsd_repeats, imageFolderPath);
            
     
            if findmean == 1 
                % Finds the mean from meanttmin to meanttmax
                [BBmean,BBpeak] = BBmeanAndPeak(folderBB, meanttmin, meanttmax, tt);
                
                % Stores then prints the mean calculated above
                meanresults(i,j,k) = BBmean;
                fprintf(append('The mean from ', num2str(meanttmin), ' to ', num2str(meanttmax), ' is:'));
                BBmean
    
                % Stores then prints the peak calculated above
                peakresults(i,j,k)   = BBpeak;
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
           
            %Calculates the d prime values
            if length(folderName) == 2
                [dprime(i,k)] = DprimeFunction(folderName{1}, folderName{2}, channelidx, ...
                    tt, shared_idx, Mbb, nsd_repeats, meanttmin, meanttmax);
            end

        end
        
        if (plotBBvalues == 1) && ((allElectrode == 0) || (length(channel)==1))
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
            title(append("Folder Comparison, Subject-", subject{k}, ": ", currentchannel))
    
        elseif (plotBBvalues == 1)
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
            title(append("Folder Comparison, Subject-", subject{k}, ": multiple channels"))
        end
        ylim([-0.1,1]);
        
        
    
    
    end

end