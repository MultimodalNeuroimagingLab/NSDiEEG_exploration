%Written by Annika

function idxs_in_folder = folder_idxs(folderName)
% FOLDER_IDXS Returns a cell array of the Shared indexes in a specified folder
% (folderName)
    
    currentFolder = fullfile('/Users/elisespringman/Documents/ProjectFolder/derivatives/stimuli/', folderName);
    folderContents = dir(fullfile(currentFolder, '*.png'));
    folderContents = folderContents(~[folderContents.isdir]);
    
    imageNames = {folderContents.name};
    
    imageNames = split(imageNames, 'd');
    imageNames = imageNames(:, :, 2);

    imageNames = split(imageNames, '_');
    
    imageNames = imageNames(:, :, 1);

    idxs_in_folder = str2double(imageNames);


end

