function [shared_idxs] = annotatedImages_idx(folderName,annotationsPath)
%ANNOTATEDIMAGES_IDX reads an excel file, then extracts the shared image
%indexes of all the images with 1 in a given column.

    %Checks that there are the proper number of arguments
    narginchk(1, 2);

    %path to the excel file with the annotations of whether or not the image 
    % is within a certain group
    if nargin == 1
        % If only folder is given, it will find the path in personal paths
        localDataPath = setLocalDataPath(1);
        annotationsPath = localDataPath.imageAnnotations;

    end
    
    % If the folder and the path is given, it will use the given path
    annotationTable = readtable(annotationsPath);

    % Extracts the list of 1s and 0s of the folder requested
    currentFolder = annotationTable.(folderName);
    
    % Finds the shared idxs for the folder
    shared_idxs = find(currentFolder);
    
end

