function clas
    % clas.m                          A.Allmann
    % function to calculate an as-function of a given cumulative number curve
    % The AS-value is plotted in the cumulative number plot
    %
    %Last modification 6/95

    global winx winy sys minmag clu te1 fontsz mess
    global xt cumu ccum action_button cumu2 pyy
    % start and end time
    %
    think

    %
    %  iwl is the cutoff at the beginning and end of the analyses
    %  to afoid spikes at the end
    iwl = 10;

    %
    % calculate mean and z value
    %
    ncu = length(xt);
    as = zeros(1,ncu);


    for i = iwl:ncu-iwl
        mean1 = mean(cumu(1:i));
        mean2 = mean(cumu(i+1:ncu));
        var1 = cov(cumu(1:i));
        var2 = cov(cumu(i+1:ncu));
        as(i) = (mean1 - mean2)/(sqrt(var1/i+var2/(ncu-i)));
    end     % for i


    %
    %  Plot the as(t)
    %
    figure_w_normalized_uicontrolunits(ccum);
    cla
    hold off
    set(gca,'visible','off','FontSize',fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')

    orient tall
    rect = [0.2,  0.20, 0.65, 0.75];
    axes('position',rect)
    pyy = plotyy(xt,cumu2,'ob',xt,as,'r',[0 0 0 NaN NaN NaN NaN min(as)*3-1  max(as*3)+1  ]);

    xlabel('Time in years ','FontWeight','bold','FontSize',fontsz.m)
    ylabel('Cumulative Number ','FontWeight','bold','FontSize',fontsz.m)
    y2label('z-value')
    grid

    hold on;



    %
    %  show option from here
    %

    set(gca,'visible','on','FontSize',fontsz.m,'FontWeight','bold',...
        'FontWeight','bold','LineWidth',1.5,...
        'Box','on')
    set(ccum,'Visible','on');
    figure_w_normalized_uicontrolunits(ccum);
    watchoff
    done
