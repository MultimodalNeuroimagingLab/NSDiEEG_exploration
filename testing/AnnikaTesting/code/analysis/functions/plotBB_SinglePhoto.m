function varargout=plotBB_SinglePhoto(subject, sharedimageidx, repeatnum, ...
    channelname,ttmin, ttmax, shared_idx,tt, Mbb_Norm_perRun, all_channels)
%% SinglePhotoBBGraph graphs the broadband values of a specific image

% Plots the Broadband of the image with a specific shared image number
% If you only have the NSD idx, use shared2NSD() first

% repeatnum is out of the six repeats shown

% This will plot between ttmin and ttmax

    localDataPath = setLocalDataPath(1);

    %full path to the folder of different types of broadband data
    input = localDataPath.BBData;

    %Checks that there are the proper number of arguments
    narginchk(6, 10)

%% Loads Variables and NORMALIZED broadband data
if nargin == 6   
    % Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_PerRun', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    load(Path_Mbb_Norm);
    
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);
end
 %%

 % Finds the channel inded
channelidx = find(ismember([all_channels.name],channelname));

% Allows the user to input a string and the function will still work
 if ~isnumeric(sharedimageidx)
       sharedimageidx = str2double(sharedimageidx);
 end

 %Finds the index of the image
 image_idx = find(ismember(shared_idx, sharedimageidx));
 image_idx = image_idx(repeatnum);

 %Plots the BB values
 plot(tt(tt<=ttmax & tt>=ttmin), Mbb_Norm_perRun(channelidx,find(tt<=ttmax & tt>=ttmin), image_idx));
 ylim([-1 1]);
 xlabel('Time (seconds)')
 ylabel('Broadband Power (% signal change)')
 title(append("Single Image: ", num2str(sharedimageidx), ", Sub-", subject, ", Electrode: ", channelname));

end