%% Input an image number and the program will output which of the listed electrodes had the image in its top 20 images
%Uses sections of code from BB_withFigures written by Morgan and Lupita
%Allows me to locate common images amongst a greater list of electrodes
%% Creating Path

localDataPath = setLocalDataPath(1);

%%

subjects = {'02'};%0654
% Choose an analysis type:
desc_label = 'preprocCARBB';

ss = 1;
subj = subjects{ss};
currentsubject = subjects{ss};

% Load NSD-iEEG-broadband data 
dataFitName = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
load(dataFitName)

% Initialize normalized log power of BB
Mbb_norm = log10(Mbb); 

% Indicate the interval for baseline, used in normalization
norm_int = find(tt>-.1 & tt<0);

% Normalize per run
for run_idx = 1:max(eventsST.tasknumber)
    this_run = find(eventsST.tasknumber==run_idx); % out of 1500
    
    % find pre-stim events with 'good' status
    trials_norm = find(ismember(eventsST.pre_status,'good') & eventsST.tasknumber==run_idx);

    Mbb_norm(:,:,this_run) = minus(Mbb_norm(:,:,this_run),mean(Mbb_norm(:,norm_int,trials_norm),[2 3],'omitnan'));
end

sel_events = eventsST;

% extract relevant information from events file:
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%%
%Input the desired image number
im_num = input("Image Number ");

%Taken from BB_withFigures code
im_path = localDataPath.im;
channels = {"LOC1", "LOC2", "LOC3", "LOC4", "LOC5", "LT7"}; %programmed in channels that can be changed as needed
for1000 = 1; % 0 for 100


for cc = 1:length(channels)
    channel = string(channels(cc));
    channelIdx = find(ismember([all_channels.name],channel));
    
    % 1000 index
    events1000idx = find(nsd_repeats <= 1); %Event indices 
    
    % 1000 share_id
    shared_idxs = shared_idx(events1000idx); %Picture shared indices
    
    % 1000 BB signal
    special1000 = squeeze(Mbb_norm(channelIdx,:,events1000idx));
    special1000 = special1000(find(tt>=.0 & tt<=.5),:);
    special1000mean = mean(special1000, 1)';
    
   if for1000 == 1
       im_idx1000  = plotRespIm(special1000mean, shared_idxs, im_path, 'max', 20);
       
       maxBBPictures = [];
       maxim_idx1000 = [];
       
       for i=1:20 % the largest BB responses (pictures) 
            im_idx1000_eventsOrder = find(ismember(shared_idx,im_idx1000(i)) & nsd_repeats<=1);
            maxBBPictures = [maxBBPictures im_idx1000_eventsOrder];
            maxim_idx1000 = [maxim_idx1000 im_idx1000(i)]; 
       end
       
        %if the image number appears in the list of the top 10 images of an
        %electrode, it will display the electrodes name
       if ismember(im_num, maxim_idx1000)
           disp(channel)
       else 
           %disp("no"); - was for testing code
       end
   end
   
   
   
end

       