%After running this code, "Mbb_Norm" will contain the normalized broadband
%values of a single image in a specified channel and subject.

%% Set the image, channel, subject and repeat# (out of 6) 
clear;

%finds the index of the channel
channels = "LOC7";

%Set the individual image (If only NSD idx number is known, use function NSD2Shared
sharedImageNumber = 64;

%picks which repeat of the image to use (1 through 6):
repeat=1;

% Select the subject
subject = '02';


%% Load the Mbb data and certain variables

localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;

% Choose an analysis type:
desc_label = 'preprocCARBB';
     
% Load NSD-iEEG-broadband data
% dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
dataFitName = fullfile(input,'preproc-car', ['sub-' subject],...
['sub-' subject '_desc-' desc_label '_ieeg.mat']);
load(dataFitName)
sel_events = eventsST;
 
% extract relevant information from events file:
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%finds the index of the image
imageidxs = find(ismember(shared_idx, sharedImageNumber));
idx_image=imageidxs(repeat);




%% Normalization Process
%finds the index of the channel
currentChannel_idx = find(ismember([all_channels.name],channels));

% takes log10 of the broadband data
Mbb_norm = log10(Mbb);
 
% Indicate the interval for baseline, used in normalization
norm_time_interval = find(tt>-.1 & tt<0);


%finds BB values of the current channel
Mbb_norm_channel = squeeze(Mbb_norm(currentChannel_idx, :, :));

%finds BB values of the current image in the current channel
Mbb_norm_image = Mbb_norm_channel(:, idx_image);

%finds BB values over the baseline period for the image
Mbb_norm_tt = Mbb_norm_image(norm_time_interval);

%Creates mean of the baseline period
mean_Mbb_norm = mean(Mbb_norm_tt);

%subtracts the value of normalization from every value
Mbb_norm = minus(Mbb_norm_image, mean_Mbb_norm);



