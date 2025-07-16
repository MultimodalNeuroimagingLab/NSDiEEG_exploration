%% This will find the D Prime values between one folder of images and one or more folders

clear;
%%
localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;


%folder to be compared
folderName = "Experiment8PeopleInteracting";

% folders to which the main folder is being compared
OtherFolders = {'Experiment8NotPeople'};
N=length(OtherFolders);

%Subject to be used
subject='13';

%Channel to be tested
channel = {"RLS1", "RLS2", "RLI1", "RLI2","RLI3","RLI4","RLI5","RLI6","RLM4", "RLM5", "RLM8","RLM9","RLM10"};

%The range of time that will be meaned
meanttmin = 0.0;
meanttmax = 0.4;




%% Loads Variables and NORMALIZED broadband data
    
    % Choose an analysis type:
    desc_label = 'EachImage';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_vars', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    
    fprintf("Loading Normalized Broadband Data...")
    load(Path_Mbb_Norm)
  
    fprintf("Loading variables...")
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

    fprintf("Everything has loaded.")

%% Actual Program
clearvars d
for j = 1:length(channel)
    % States which channel it is currently processing
    currentchannel = channel{j};
    channelIdx = find(ismember([all_channels.name],currentchannel));

    %Gets the mean of the images in the selected folder over the selected time period
    [folderMeanBB,folderSTD_BB, foldervar] = dPrimeAverageBB(folderName, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, New_Mbb_Norm, nsd_repeats);  
    

   MeanOtherFolderValues = [];
   StdOtherFolderValues = [];
    %Gets the mean of the images in the selected folder over the selected time period
    for i=1:length(OtherFolders)
        [notFolderMeanBB,notfolderSTD_BB, notfoldervar] = dPrimeAverageBB(OtherFolders{i}, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, New_Mbb_Norm, nsd_repeats); 

        MeanOtherFolderValues(i) = notFolderMeanBB;
        varOtherFolderValues(i) = notfoldervar;
    end
     
    
    numeratorSum = sum(MeanOtherFolderValues, "all");

    denominatorSum = sum((varOtherFolderValues), "all");

    numerator = folderMeanBB - (1/N)*(numeratorSum);

    denominator = sqrt(0.5*((foldervar)+((1/N)*(denominatorSum))));

    d(j, :) = numerator/denominator;
    
    fprintf(append("The d' value for ", currentchannel, " is: "));
    d(j, 1)

end
