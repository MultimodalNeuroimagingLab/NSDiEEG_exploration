%% Creates normalized data that is then stored in New_Mbb_Norm 
% The data is normalized by each individual image shown (1530 times)
% This is a version of newBBNormalization.m that uses a parfor loop.

clear;

%path to the folder containing folders of different types of broadband data
localDataPath = setLocalDataPath(1);
input = localDataPath.BBData;

%Choose the desired subject data to normalize
subject='06'; 

 % Choose an analysis type:
desc_label = 'preprocCARBB';
   
% Load NSD-iEEG-broadband data
% dataFitName = fullfile(['sub-' subj],['sub-' subj '_desc-' desc_label '_ieeg.mat']);
dataFitName = fullfile(input,'preproc-car', ['sub-' subject],...
['sub-' subject '_desc-' desc_label '_ieeg.mat']);
load(dataFitName)

    
% extract relevant information from events file:
sel_events = eventsST;
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);


%% Normalizes Mbb

%takes the log 10 of the broadband data
Mbb_norm = log10(Mbb);

% Indicate the interval for baseline, used in normalization
norm_time_interval = find(tt>-.1 & tt<0);

% This is where the normal values will be stored 
New_Mbb_Norm = zeros(size(Mbb_norm), 'single');

%Sets the number of loops for the function
chlength = length([all_channels.name]);
imlength = length(shared_idx);

parfor ch=1:chlength

    for im=1:imlength

        % To check it is running properly
        if rem(im, 100) == 0
            fprintf('Channel: %d, Image: %d\n', ch, im);
        end

        %finds BB values of the current channel and image
        Mbb_norm_image = squeeze(Mbb_norm(ch, :, im));
        
        %finds BB values over the baseline period for the image
        Mbb_norm_tt = Mbb_norm_image(norm_time_interval);
        
        %Creates mean of the baseline period
        mean_Mbb_norm = mean(Mbb_norm_tt);
        
        %subtracts the value of normalization from every value
        Mbb_norm_current = minus(Mbb_norm_image, mean_Mbb_norm);

        %Saves the normalized data
        New_Mbb_Norm(ch, :, im) = Mbb_norm_current;

    end


end

%Lets the user know that the program is complete.
fprintf(append("Normalization of subject-", subject, " complete."));

%Easy way to check the graph of the new normalized data:
%plot(tt(tt<=0.8 & tt>=-0.1), New_Mbb_Norm(1,find(tt<=0.8 & tt>=-0.1), 5))