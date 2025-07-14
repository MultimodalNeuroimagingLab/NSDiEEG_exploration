%% This will find the D Prime values between one folder of images and one or more folders

clear;

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
channel = {"RLS1"};
channelcurrent = channel{1};

%The range of time that will be meaned
meanttmin = 0;
meanttmax = 0.8;




%% Loads Variables and normalized broadband data
    
    subjects = {subject};%0654
    % Choose an analysis type:
    desc_label = 'EachImage';
     
    ss = 1;
    subj = subjects{ss};

    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_vars', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    load(Path_Mbb_Norm)


 %% Load Variables
    sel_events = eventsST;
 
    % extract relevant information from events file:
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);




%% Actual Program
    
    channelIdx = find(ismember([all_channels.name],channelcurrent));

    %Gets the mean of the images in the selected folder over the selected time period
    [folderMeanBB,folderSTD_BB] = dPrimeAverageBB(folderName, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, New_Mbb_Norm, nsd_repeats);  
    

   MeanOtherFolderValues = [];
   StdOtherFolderValues = [];
    %Gets the mean of the images in the selected folder over the selected time period
    for i=1:length(OtherFolders)
        [notFolderMeanBB,notfolderSTD_BB] = dPrimeAverageBB(OtherFolders{i}, channelIdx, ...
        meanttmin, meanttmax, tt, shared_idx, New_Mbb_Norm, nsd_repeats); 

        MeanOtherFolderValues(i) = notFolderMeanBB;
        StdOtherFolderValues(i) = notfolderSTD_BB;
    end
     
    
    numeratorSum = sum(MeanOtherFolderValues, "all");

    denominatorSum = sum((StdOtherFolderValues.^2), "all");

    numerator = folderMeanBB - (1/N)*(numeratorSum);

    denominator = sqrt((1/2)*((folderSTD_BB.^2)+((1/N)*(denominatorSum))));

    d = numerator/denominator;

    fprintf("The d' value is: ");
    d

    
