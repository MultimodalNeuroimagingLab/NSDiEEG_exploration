function displayImageNSDidx(NSD_idx)
% displayNSD1000Image creates a figure of the given image 
% Automatically searches for the NSD index
% Can input a numerical value or a string of the number

    localDataPath = setLocalDataPath(1);

    %full path of the 1000 images folders
    imageFolderPath = localDataPath.stim;
    
    if (isnumeric(NSD_idx))
         NSD_idx = num2str(NSD_idx);

    end
  
    
    %finds shared index and adds the proper number of zeros
    shared_idx = NSD2shared(NSD_idx);
    
    if (shared_idx < 10)
        sharedNumber = append('000', num2str(shared_idx));
    
    elseif (shared_idx < 100)
        sharedNumber = append('00', num2str(shared_idx));
        
    elseif (shared_idx < 1000)
        sharedNumber = append('0', num2str(shared_idx));
            
    else
        sharedNumber = num2str(shared_idx);
            
        
    % adds the proper number of zeros to the NSD idx

    if (str2double(NSD_idx) < 10)
        sharedNumber = append('000', num2str(NSD_idx));
    
    elseif (str2double(NSD_idx) < 100)
        sharedNumber = append('00', num2str(NSD_idx));
        
    elseif (str2double(NSD_idx) < 1000)
        sharedNumber = append('0', num2str(NSD_idx));
            
    else
        sharedNumber = num2str(NSD_idx);
            
    end

    end

    % Creates the name of the image
    im_fname = append('shared', sharedNumber, '_nsd', NSD_idx, '.png');
            
    %Finds and shows the image
    imshow(imread(fullfile(imageFolderPath, im_fname)))
end

