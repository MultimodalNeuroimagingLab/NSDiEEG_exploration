%Created by Morgan and Lupita
%%
clear all; close all;

localDataPath = setLocalDataPath(1);


%% Load preprocessed images and divisive normalization:


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
im_path = localDataPath.im;
channels = {"LA1", "LC7"};
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
    
    % 1. Display most responsive images of shared 1000

    if for1000 == 1 % for 1000
        % Plot images
        im_idx1000  = plotRespIm(special1000mean, shared_idxs, im_path, 'max', 20); 
        % Plotting BB signal
        ttt = tt(tt>=-.2 & tt<=.5);
        maxBBPictures = [];
        maxim_idx1000 = [];
        for i=1:1000 % the largest BB responses (pictures) 
            im_idx1000_eventsOrder = find(ismember(shared_idx,im_idx1000(i)) & nsd_repeats<=1);
            maxBBPictures = [maxBBPictures im_idx1000_eventsOrder];
            maxim_idx1000 = [maxim_idx1000 im_idx1000(i)]; % only for test
        end
        for i=1:100:1000
            figure
            plot(ttt,Mbb_norm(channelIdx,find(tt>=-.2 & tt<=.5),maxBBPictures(i))); ylim([0,1]);hold on;
            title([i])
        end

    % for 100    
    else 
        % 100 index
        events_100idx = find(nsd_repeats == 1); %Event indices 
        
        % 100 share_id
        special100nsdIdx = shared_idx(events_100idx); %Picture shared indices
        
        % 100 BB 
        for i=1:6 
            special100EventsIdx = find(nsd_repeats == i);
            special100rep = squeeze(Mbb_norm(channelIdx,:,special100EventsIdx));
            special100rep = special100rep(find(tt>=.0 & tt<=.5),:);
            special100mean(i,:) = mean(special100rep, 1);
            special100IdxTest(i,:) = shared_idx(special100EventsIdx);
        end
        
        special100meanReorder = special100mean(1,:);
        special100nsdInxTest = special100IdxTest(1,:);
        for i = 1:100
            for j = 2:6
                % Idx in the j row that have the same value as the 1st row for one
                % image
                idxx = find(ismember(special100IdxTest(j,:), special100IdxTest(1,i)));
                validxx = special100mean(j,idxx);
                special100meanReorder(j, i) = validxx;
                special100nsdInxTest(j, i) = special100IdxTest(j,idxx); % for help us
            end
        end
    
        special100mean6 = special100meanReorder(1,:)';
        
        % 2. Display most responsive images of shared 100 
        im_idx100  = plotRespIm(special100mean6, special100nsdIdx, im_path, 'max', 20); 

        % TODO
        % Plotting BB
    end
    
end

