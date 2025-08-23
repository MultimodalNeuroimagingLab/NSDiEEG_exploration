function idxs_in_folder = folder_idxs(folderName, localImageFolderPath)
% FOLDER_IDXS Returns a cell array of the Shared indexes in a specified folder     
    
    %Checks that there are the proper number of arguments
    narginchk(1, 2)

    %path to the folders of different types of images
    if nargin == 1
        
        % If only folder is given, it will find the path in personal paths
        localDataPath = setLocalDataPath(1);
        localImageFolderPath = localDataPath.imFolders;

    end

    % If the folder and the path is given, it will use the given path
    currentFolder = fullfile(localImageFolderPath, folderName);
    
    %extracts the names of the images from the current folder
    folderContents = dir(fullfile(currentFolder, '*.png'));
    folderContents = folderContents(~[folderContents.isdir]);
    imageNames = {folderContents.name};
    
    %Finds the part of the name containing only the shared index
    imageNames = split(imageNames, 'd');
    imageNames = imageNames(:, :, 2);
    imageNames = split(imageNames, '_');
    imageNames = imageNames(:, :, 1);

    %Returns the Shared index
    idxs_in_folder = str2double(imageNames);


end

