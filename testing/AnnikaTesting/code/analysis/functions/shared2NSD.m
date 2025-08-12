function nsdNumber = shared2NSD(shared_to_convert)
    
% Given a singular Shared number, shared2NSD will return the NSD number
% of the first repeat of the image

% Input can be numeric or a string of numbers
% Returns a numerical value (does not have the zeros in front)


    load nsd_idx.mat
    load shared_idx.mat
    
    if ~(isnumeric(shared_to_convert))
         shared_to_convert = str2double(shared_to_convert);
    end

    input_idx = find(ismember(calculated_shared_idx, shared_to_convert));

    nsdNumber = nsd_idx(input_idx(1));

end