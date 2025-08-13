%% Display the top normalized broadband responsive images in different channels 
%This is Annika's edited version of BB_withFigures written by someone else (Maybe Zeeshan, Morgan, or Lupita?).
%Annika changed it to run on the per-Run normalized data and added a way to
%graph the 6 trials instead of the first instance of the 1000 images

% Currently, this code will plot the top 20 images to view, along with
% plotting the top ten broadband traces individually


clear all; close all;

localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;

%path to the folders of different types of images
imageFolderPath = localDataPath.stim;
shared1000folder = fullfile(imageFolderPath, 'shared1000');


% Assign the subjects and channels

subjects = {'02'};

ss = 1;
subj = subjects{ss};

channels = {"LOC6", "LOC7","LOC8"};

 % 0 for 100 repeats, 1 for all 1000 images
for1000 = 0;

%If average across all six trials (100 repeats): avgBB = 1 
%If plot each individual trial (100 repeats): avgBB=0 
avgBB=1;

%% Loads Variables and NORMALIZED broadband data
    % Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_perRun', ['sub-' subj],...
    ['sub-' subj '_normalizedMbb' desc_label '_ieeg.mat']);
    
    fprintf("Loading Normalized Broadband Data...")
    load(Path_Mbb_Norm)
  
    fprintf("Loading variables...")
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

    fprintf("Everything has loaded.")
%%

for cc = 1:length(channels)
    channel = string(channels(cc));
    channelIdx = find(ismember([all_channels.name],channel));
    
    % 1000 index
    events1000idx = find(nsd_repeats <= 1); %Event indices 
    
    % 1000 share_id
    shared_idxs = shared_idx(events1000idx); %Picture shared indices
    
    % 1000 BB signal
    special1000 = squeeze(Mbb_Norm_perRun(channelIdx,:,events1000idx));
    special1000 = special1000(find(tt>=.0 & tt<=.5),:);
    special1000mean = mean(special1000, 1)';
    
    % 1. Display most responsive images of shared 1000

    if for1000 == 1 % for 1000
        % Plot images
        im_idx1000  = plotRespIm(special1000mean, shared_idxs, shared1000folder, 'max', 20); 
        % Plotting BB signal
        ttt = tt(tt>=-.2 & tt<=.8);
        maxBBPictures = [];
        maxim_idx1000 = [];
        for i=1:10 % the largest BB responses (pictures) 
            im_idx1000_eventsOrder = find(ismember(shared_idx,im_idx1000(i)) & nsd_repeats<=1);
            maxBBPictures = [maxBBPictures im_idx1000_eventsOrder];
            maxim_idx1000 = [maxim_idx1000 im_idx1000(i)]; % only for test
        end

         
       % Graphs the BB response to the top ten images
        for i=1:10
            figure
            plot(ttt,Mbb_Norm_perRun(channelIdx,find(tt>=-.2 & tt<=.8),maxBBPictures(i))); ylim([0,1]);hold on;
            title(append("Image Number ", num2str(i), ", Electrode: ", channels{cc}))
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
            special100rep = squeeze(Mbb_Norm_perRun(channelIdx,:,special100EventsIdx));
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
        im_idx100  = plotRespIm(special100mean6, special100nsdIdx, shared1000folder, 'max', 20); 

        
        % Plotting BB
        ttt = tt(tt>=-.2 & tt<=.8);

        im_idx100 = im_idx100';
        
        %If average across all six trials: avgBB = 1, if plot each individual trial: avgBB=0 
        if avgBB == 1

            %Have to average across all six trials            
            for imageNum = 1:10

                %finds all the indexes of the current image
                currentImage = find(ismember(shared_idx, im_idx100(imageNum)));

                meanCurrentImage = [];
                for trialnum = 1:6

                    %finds all the indexes of the current trial (1 to 6)
                    currentTrial = find(ismember(nsd_repeats, trialnum));

                    %finds index of the current image at the current trial
                    currentTrial_currentImage = 0;
                    for i=1:length(currentTrial)
                        for j=1:length(currentImage)
                            if shared_idx(currentTrial(i)) == shared_idx(currentImage(j))
                                currentTrial_currentImage = currentTrial(i);
                            end
                        end
                    end

                    %puts the current trial into new row
                   BB_TrialsOfCurrentImage(trialnum,:) = Mbb_Norm_perRun(channelIdx,find(tt>=-.2 & tt<=.8),currentTrial_currentImage);

                end

                 % Takes average of each column
                broadBandVal = mean(BB_TrialsOfCurrentImage, 1);

                % plot the BB avg
                figure(Name="Image Number " +imageNum + ", Average of Six Trials")
                plot(ttt,broadBandVal); ylim([0,1]);hold on;
                %title([i])

            end
  
                
        % plot the 6 different trials separately (not averaged)

        else
            for imageNum = 1:10
                %finds all the indexes of the current image
                currentImage = find(ismember(shared_idx, im_idx100(imageNum)));
                
                for trialnum = 1:6
                    
                    %finds all the indexes of the current trial (1 to 6)
                    currentTrial = find(ismember(nsd_repeats, trialnum));
                    
                    %finds index of the current image at the current trial
                    currentTrial_currentImage = 0;
                    for i=1:length(currentTrial)
                        for j=1:length(currentImage)
                            if shared_idx(currentTrial(i)) == shared_idx(currentImage(j))
                                currentTrial_currentImage = currentTrial(i);
                            end
                        end
                    end

                     % plot the BB avg
                    figure(Name="Image Number " + imageNum + ", Trial Number " + trialnum)
                    plot(ttt,Mbb_Norm_perRun(channelIdx,find(tt>=-.2 & tt<=.8),currentTrial_currentImage)); ylim([0,1]);hold on;
                    %title([i])
                
                
                
                end
            end
        end      
    end
    
end

