
%% SinglePhotoBBGraphFolder individually graphs broadband values of images in a folder

% Plots the Broadband of the image with a specific shared image number
% Plots every image within a folder

% This will plot between ttmin and ttmax

ttmin = -0.1;
ttmax = 0.8;

channel = "LOC13";
channelnum = find(ismember([all_channels.name],currentchannel));


folderName = 'Buildings'; %Folder with the images
loadBB = 0; %0 if you have the Broadband data in New_Mbb_Norm, 1 if not

localDataPath = setLocalDataPath(1);

%full path to the folder of different types of broadband data
input = localDataPath.BBData;
%Full path to the folder containing the folder of images
localImageFolderPath = localDataPath.imFolders;

sharedimageidx = folder_idxs(folderName, localImageFolderPath);




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
 for i=1:length(sharedimageidx)
    figure

     % finds the first repeat of the images
    Special1000idx = find(nsd_repeats <= 1);    
    shared_idx1000 = shared_idx(Special1000idx);

    %Finds the shared_idx in the order of images shown
    imageNumberShown = find((ismember(shared_idx1000', sharedimageidx(i))));

    %Plots the BB values
    plot((tt(tt<=ttmax & tt>=ttmin)), (New_Mbb_Norm(channelnum, find(tt<=ttmax & tt>=ttmin), imageNumberShown)));
    ylim([0,1]);
    title("Image: ", sharedimageidx(i))
 end