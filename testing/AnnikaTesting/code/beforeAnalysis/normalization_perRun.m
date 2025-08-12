%% Creates normalized data that is then stored in Mbb_Norm_perRun 
% The data is normalized by run (10 runs total)
% The code for the actual normalization process is Morgan's code.

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

%Initialize normalized log power of BB
Mbb_norm = log10(Mbb);
 
% Indicate the interval for baseline, used in normalization
norm_int = find(tt>-.4 & tt<0);

% This is where the normal values will be stored 
Mbb_Norm_perRun = zeros(size(Mbb_norm), 'single');

% Normalize per run
for run_idx = 1:max(eventsST.tasknumber)
  
    run_idx
   
    this_run = find(eventsST.tasknumber==run_idx); % out of 1500
   
    % find pre-stim events with 'good' status
    trials_norm = find(ismember(eventsST.pre_status,'good') & eventsST.tasknumber==run_idx);
 
    %Saves the normalized data
    Mbb_Norm_perRun(:,:,this_run) = minus(Mbb_norm(:,:,this_run),mean(Mbb_norm(:,norm_int,trials_norm),[2 3],'omitnan'));
end

%Lets the user know that the program is complete.
fprintf(append("Normalization of subject-", subject, " complete."));

%Easy way to check the graph of the new normalized data:
%plot(tt(tt<=0.8 & tt>=-0.1), Mbb_Norm_perRun(1,find(tt<=0.8 & tt>=-0.1), 5))



 
