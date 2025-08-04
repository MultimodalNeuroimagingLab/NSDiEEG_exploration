function displayImageSharedidx(sharedIdx)
% displayImageSharedidx creates a figure of the given image 
% Automatically searches for the Shared index
% Can input a numerical value or a string of the number

    localDataPath = setLocalDataPath(1);

    %full path of the 1000 images folders
    imageFolderPath = localDataPath.stim;
    
    if (isnumeric(sharedIdx))
         sharedIdx = num2str(sharedIdx);

    end
    
    %finds NSD index and adds the proper number of zeros
    NSD_idx = shared2NSD(sharedIdx);
    
    if (NSD_idx < 10)
        NSDNumber = append('0000', num2str(NSD_idx));
    
    elseif (NSD_idx < 100)
        NSDNumber = append('000', num2str(NSD_idx));
        
    elseif (NSD_idx < 1000)
        NSDNumber = append('00', num2str(NSD_idx));
            
    elseif (NSD_idx < 10000)
        NSDNumber = append('0', num2str(NSD_idx));
    
    else
        NSDNumber = num2str(NSD_idx);
            
        
    end


    %adds the proper number of zeros to the Shared idx

    if (str2double(sharedIdx) < 10)
        sharedNumber = append('000', num2str(sharedIdx));
    
    elseif (str2double(sharedIdx) < 100)
        sharedNumber = append('00', num2str(sharedIdx));
        
    elseif (str2double(sharedIdx) < 1000)
        sharedNumber = append('0', num2str(sharedIdx));
            
    else
        sharedNumber = num2str(sharedIdx);
            
    end


    % Creates the name of the image
    im_fname = append('shared', sharedNumber, '_nsd', NSDNumber, '.png');
            
    %Finds and shows the image
    imshow(imread(fullfile(imageFolderPath, im_fname)))
end

