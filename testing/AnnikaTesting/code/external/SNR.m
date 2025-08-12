% Calculates the Signal to Noise Ratio of each electrode using Zeeshan's code

%%
localDataPath = setLocalDataPath(1);

%path to the folder containing folders of different types of broadband data
input = localDataPath.BBData;

%path to the folders of different types of images
imageFolderPath = localDataPath.imFolders;


%% Loads Variables and NORMALIZED broadband data
    
    %Subject to be used
    subject='21'; 


    % Choose an analysis type:
    desc_label = 'PerRun';
     
    % Load normalized NSD-iEEG-broadband data
    Path_Mbb_Norm = fullfile(input,'Mbb_Norm_PerRun', ['sub-' subject],...
    ['sub-' subject '_normalizedMbb' desc_label '_ieeg.mat']);
    
    fprintf("Loading Normalized Broadband Data...")
    load(Path_Mbb_Norm)
  
    fprintf("Loading variables...")
    % extract relevant information from events file:
    sel_events = eventsST;
    [events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(sel_events);

    fprintf("Everything has loaded.")



%% Find repeated images, calculate SNR
%(This code is from Zeeshan)
eventsST.status_description = cellstr(string(eventsST.status_description));
[events_status,nsd_idx,shared_idx,nsd_repeats] = ieeg_nsdParseEvents(eventsST);
all_chan_snr = NaN(size(Mbb_Norm_perRun,1),1);
t_avg = tt>0.1 & tt<.5;
for el_nr = 1:size(Mbb_Norm_perRun,1)
    if ismember(all_channels.type(el_nr),'SEEG') && all_channels.status(el_nr)==1
        bb_strength = squeeze(mean(Mbb_Norm_perRun(el_nr,t_avg==1,:),2));
        all_repeats = find(nsd_repeats>0);
        shared_idx_repeats = unique(shared_idx(all_repeats)); % 100 images
        repeats_bb_strength = cell(length(shared_idx_repeats),1);
        for kk = 1:length(shared_idx_repeats)
            these_trials = find(shared_idx==shared_idx_repeats(kk));    % for this repeat, find the correct 6 trial numbers out of the 1500 and get the image and the data
            repeats_bb_strength{kk} = bb_strength(these_trials);
        end
        [NCSNR, p, NCSNRNull] = estimateNCSNR(repeats_bb_strength, 1000);
        all_chan_snr(el_nr) = NCSNR;
    end
end
figure,
hold on
temp_clr = zeros(length(all_chan_snr), 3);
temp_clr(all_chan_snr<0.2,  :) = repmat([0 0 0], sum(all_chan_snr<0.2) ,1);
temp_clr(all_chan_snr>=0.2, :) = repmat([1 0 0], sum(all_chan_snr>=0.2),1);
scatter(1:length(all_chan_snr), all_chan_snr,  [], temp_clr);
yline(0.2, '--c')





