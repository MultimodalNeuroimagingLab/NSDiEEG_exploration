function plotBB(BBvalues,StandardError,graphttmin, graphttmax, currentcolor, tt)
%PLOTBB graphs BB values over a specified time period. 
        
        % x values for the plot
        ttt = tt(tt>=graphttmin & tt<=graphttmax);
        
        % y values for the plot
        ttBBvalues = BBvalues((tt>=graphttmin & tt<=graphttmax), :);
        
        % standard error of the plot
        ttste = StandardError(tt>=graphttmin & tt<=graphttmax);

        %plots the mean of all the images
        plot(ttt,ttBBvalues);
       
        % Labels the y and x axis
        xlabel('Time (seconds)')
        ylabel('Broadband Power (% signal change)')

        %Adds error bars that are one standard error away
        shadedErrorBar(ttt,ttBBvalues,ttste, 'lineprops', currentcolor,'patchSaturation',0.075);
        
        % Sets the limits of the y-axis (x-axis limits are graphttmin to
        % graphttmax)
        ylim([-0.1,1]);

        hold on;
end

