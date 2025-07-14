function [BBmean,BBpeak] = BBmeanAndPeak(BBvalues, meanttmin, meanttmax, tt)
%BBMEAN Summary of this function goes here
%   Detailed explanation goes here

    ttt = find(tt>=meanttmin & tt<=meanttmax);
    
    %Saves only the tt asked for
    ttavgBB = BBvalues(ttt);

    %Returns the mean from t=meanttmin to t=meanttmax
    BBmean=mean(ttavgBB);
    
    %Returns peak BB from t=meanttmin to t=meanttmax
    BBpeak = max(ttavgBB);


    
end    