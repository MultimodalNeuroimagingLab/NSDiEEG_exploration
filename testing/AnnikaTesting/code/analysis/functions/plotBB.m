function plotBB(BBvalues,StandardError,graphttmin, graphttmax, currentcolor, tt)
%PLOTBB graphs BB values over a specified time period. 
%   BBvalues 

        
        % x values for the plot
        ttt = tt(tt>=graphttmin & tt<=graphttmax);
        
        % y values for the plot
        ttBBvalues = BBvalues((tt>=graphttmin & tt<=graphttmax), :);
        
        % standard error of the plot
        ttste = StandardError(tt>=graphttmin & tt<=graphttmax);

        %plots the mean of all the images
        plot(ttt,ttBBvalues);
       
        xlabel('Time (seconds)')
        ylabel('Broadband Power (% signal change)')
        %shadedErrorBar(ttt,ttBBvalues,ttste, 'lineprops', currentcolor,'patchSaturation',0.075);
        
        ylim([0,1]);
        hold on;
end

