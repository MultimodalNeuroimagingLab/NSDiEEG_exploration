function varargout=plotBB_SinglePhoto(subject, sharedimageidx, repeatnum, ...
    channelnum,ttmin, ttmax, loadBB)

%% SinglePhotoBBGraph graphs the broadband values of a specific image

% Plots the Broadband of the image with a specific shared image number
% If you only have the NSD idx, use shared2NSD() first

% repeatnum is out of the six repeats shown

% This will plot between ttmin and ttmax

    localDataPath = setLocalDataPath(1);

    %full path to the folder of different types of broadband data
    input = localDataPath.BBData;

%% Loads Variables and NORMALIZED broadband data
if loadBB == 1    
    % Choose an analysis type:
    desc_label = 'EachImage';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_vars', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    load(Path_Mbb_Norm);
    
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);
end
 %%
 if ~isnumeric(sharedimageidx)
       sharedimageidx = str2double(sharedimageidx);
 end

 %Finds the index of the image
 image_idx = find(ismember(shared_idx, sharedimageidx));
 image_idx = image_idx(repeatnum);

 %{
 if events_status(image_idx) == 1
     fprintf("This run is bad!")
 end
 %}

 %Plots the BB values
 plot(tt(tt<=ttmax & tt>=ttmin), New_Mbb_Norm(channelnum,find(tt<=ttmax & tt>=ttmin), image_idx));

end