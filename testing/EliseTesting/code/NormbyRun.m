%% Set Path

clear;

localDataPath = setLocalDataPath(1);

%% Set variables

%Subject to be used
subject = {'02'};    

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

%% Normalize data

% Initialize normalized log power of BB
Mbb_norm = log10(Mbb); 

% Indicate the interval for baseline, used in normalization
norm_int = find(tt>-.1 & tt<0);

Mbb_Norm_Run = zeros(size(Mbb_norm), 'single');

% Normalize per run
for run_idx = 1:max(eventsST.tasknumber)
    
    %To keep track of where it is
    run_idx
    
    this_run = find(eventsST.tasknumber==run_idx); % out of 1500
    
    % find pre-stim events with 'good' status
    trials_norm = find(ismember(eventsST.pre_status,'good') & eventsST.tasknumber==run_idx);

    Mbb_Norm_Run(:,:,this_run) = minus(Mbb_norm(:,:,this_run),mean(Mbb_norm(:,norm_int,trials_norm),[2 3],'omitnan'));
end

subj 