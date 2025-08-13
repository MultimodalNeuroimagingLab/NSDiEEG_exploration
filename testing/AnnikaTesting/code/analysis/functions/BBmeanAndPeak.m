function [BBmean,BBpeak, BBmedian] = BBmeanAndPeak(BBvalues, meanttmin, meanttmax, tt)
%BBMEANANDPEAK calculates the mean, peak, and median values of supplied
%BBvalues over a specified time interval.

    % Time frame over which the function will take the mean, max, and median
    ttt = find(tt>=meanttmin & tt<=meanttmax);
    
    %Saves only the tt asked for
    ttavgBB = BBvalues(ttt);

    %Returns the mean from t=meanttmin to t=meanttmax
    BBmean=mean(ttavgBB, 'omitnan');
    
    %Returns peak BB from t=meanttmin to t=meanttmax
    BBpeak = max(ttavgBB, [], 'omitnan');

    %Returns median BB from t=meanttmin to t=meanttmax
    BBmedian=median(ttavgBB, 'omitnan');
    
end    