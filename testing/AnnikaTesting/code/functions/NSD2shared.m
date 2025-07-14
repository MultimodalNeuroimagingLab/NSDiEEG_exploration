function sharedNumber = NSD2shared(nsd_to_convert)
    
% Given a singular NSD number, NSD2shared will return the Shared number
% of the first repeat of the image

% Input can be numeric or a string of numbers
% Returns a numerical value (does not have the zeros in front)

    load nsd_idx.mat
    load shared_idx.mat
    
    if ~(isnumeric(nsd_to_convert))
         nsd_to_convert = str2double(nsd_to_convert);
    end

    input_idx = find(ismember(nsd_idx, nsd_to_convert));

    sharedNumber = calculated_shared_idx(input_idx(1));

end