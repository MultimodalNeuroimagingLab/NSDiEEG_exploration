%This script plots the broadband data of a single image across a specified
%time frame (ttmin to ttmax). 

subject = '18';
sharedimageidx = 38;
repeatnum =  1;
channelname = "LSL8";
ttmin = -0.1; %minimum x-value
ttmax = 0.8; %maximum y-value

%full path to the folder containing the types of normalized broadband data
localDataPath = setLocalDataPath(1);
input = localDataPath.BBData;

%% Loads the normalize broadband data (unnecessary if using the same subject)
% Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_PerRun', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    load(Path_Mbb_Norm);
    
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

%%
plotBB_SinglePhoto(subject, sharedimageidx, repeatnum, ...
    channelname,ttmin, ttmax, shared_idx, tt, Mbb_Norm_perRun, all_channels)