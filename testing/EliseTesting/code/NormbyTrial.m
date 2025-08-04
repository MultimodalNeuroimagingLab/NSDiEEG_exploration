%% Set Path

clear;

localDataPath = setLocalDataPath(1);

%% Set variables

%Subject to be used
subject = {'20'};    

%Set subject
    subjects = {subject};
    % Choose an analysis type:
    desc_label = 'normalized_MbbPerRun'; %new normalized data
     
    ss = 1;
    subj = subject{ss};
    currentsubject = subject{ss};
    
oldData = fullfile(localDataPath.input,'preproc-car', ['sub-' currentsubject],...
    ['sub-' currentsubject '_desc-preprocCARBB_ieeg.mat']);
load(oldData)
    
sel_events = eventsST;
 
% extract relevant information from events file:
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%% 

Mbb_norm = log10(Mbb);

% Indicate the interval for baseline, used in normalization
norm_time_interval = find(tt>-.1 & tt<0);

for ch=1:length([all_channels.name])

    currentChannel_idx = ch;

    for im=1:length(shared_idx)

        imageidxs = im;
        
        if rem(im, 10) == 0
            ch
            im
        end

        %finds BB values of the current channel and image
        Mbb_norm_image = squeeze(Mbb_norm(currentChannel_idx, :, im));
        
        %finds BB values over the baseline period for the image
        Mbb_norm_tt = Mbb_norm_image(norm_time_interval);
        
        %Creates mean of the baseline period
        mean_Mbb_norm = mean(Mbb_norm_tt);
        
        %subtracts the value of normalization from every value
        Mbb_norm_current = minus(Mbb_norm_image, mean_Mbb_norm);


        New_Mbb_Norm(ch, :, im) = Mbb_norm_current;

    end


end

subj 

%%
%{
% extract relevant information from events file:
allImageNames = eventsST.stim_file;
imageNames = allImageNames;
for i=1:length(allImageNames)
    imageNames(i) = allImageNames{i};
end

%finds the image indexes 

for i=1:length(imageNames)

    imageNames = split(imageNames, 'd');
    imageNames = imageNames(2, :);

    imageNames = split(imageNames, '_');
    
    imageNames = imageNames(1);

    idxs_in_folder = str2double(imageNames);

end 
%}




%%
%{
for cc = 1:length(channels)
    channel = string(channels{cc});
    channelIdx = find(ismember([all_channels.name],channel));
   
    % 1000 index
    special1000idx = find(nsd_repeats <= 1);
    
    % 1000 share_id
    shared_idxs = shared_idx(special1000idx);
   
    % 1000 BB
    special1000 = squeeze(Mbb_norm(channelIdx,:,special1000idx));
    BBValues =  special1000(find(tt>=graphttmin & tt<=graphttmax),:);
    
end

BBvalues = BBValues(:,imageidxs(currentChannel_idx));

% find pre-stim events with 'good' status
trials_norm = find(ismember(eventsST.pre_status,'good'));

%Stores log10 bb by "channel" (all time, images in the run)
originalData = Mbb_norm(channel_idx,:,imageNumber);

%Stores log10 bb of all broadband in the channel, is good, and is in the
%time interval (all images in the run)
dataForNorm = Mbb_norm(channel_idx,norm_time_interval,trials_norm);

%Creates mean of above so that there's a value for each image;
meanDataForNorm = mean(dataForNorm,[2 3],'omitnan');

%subtracts the value of normalization of each channel from every value
%at that channel on that run
Mbb_norm(channel_idx, :,:) = minus(originalData, meanDataForNorm);


sel_events = eventsST;
 
% extract relevant information from events file:
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%}



