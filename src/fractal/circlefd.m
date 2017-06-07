%   This subroutine "circle"  selects the Ni closest earthquakes
%   around a interactively selected point.  Resets E, newcat and newt2
%   Operates on "Da". The code is called from view_Dv.m.
%
%  Input Ni:
%
report_this_filefun(mfilename('fullpath'));


axes(h1)

titStr ='Selecting EQ in Circles                         ';
messtext= ...
    ['                                                '
    '  Please use the LEFT mouse button              '
    ' to select the center point.                    '
    ' The "ni" events nearest to this point          '
    ' will be selected and displayed in the map.     '];

welcome(titStr,messtext);

% Input center of circle with mouse
%
[xa0,ya0] = ginput(1);

stri1 = [ 'Circle: lon = ' num2str(xa0) '; lat= ' num2str(ya0)];
stri = stri1;
pause(0.1)
%
%
%  Calculates the distance for each earthquake from center point
%  and sorts by distance.
%
%
l = sqrt(((Da(:,1) - xa0)).^2 + ((Da(:,7) + ya0)).^2 + (Da(:,2).^2)) ;
[s,is] = sort(l);
newt2 = Da(is(:,1),:) ;

if ic == 1 % select N closest events

    l = s;
    messtext = ['Number of events in the sphere :' num2str(length(newt2(ll,1))) ];
    disp(messtext);
    welcome('Message',messtext)
    %
    % take first ni and sort by time
    %
    newt2 = newt2(1:ni,:);
    [st,ist] = sort(newt2);
    newt2 = newt2(ist(:,3),:);
    %
    % plot Ni closest events on map as 'x':

    hold on
    %[na,ma] = size(newt2);
    plos1 = plot(newt2(:,1),-newt2(:,7),'k.','MarkerSize', 0.5, 'EraseMode','back');
    set(gcf,'Pointer','arrow')
    %
    % plot circle containing events as circle
    x = -pi-0.1:0.1:pi;
    plot(xa0+sin(x)*l(ni), ya0+cos(x)*l(ni),'w','era','back')
    l(ni)

    %
    newcat = newt2;                   % resets E, newcat and newt2
    E = newt2;
    %clear l s is
    %
    %
    % Calls the program to plot the correlation integral versus the radius R.
    % Then calculates the fractal dimension D.
    %
    %
    dtokm = [];
    pdc3circle;

end % if ic = 1



if ic == 2 % select events within ra

    l = s;
    ll = l <= ra;
    messtext = ['Radius of selected sphere:' num2str(l(ni))  ' km' ];
    disp(messtext)
    welcome('Message',messtext)
    %
    % take first ni and sort by time
    %
    newt2 = newt2(ll,:);
    [st,ist] = sort(newt2);
    newt2 = newt2(ist(:,3),:);
    %
    % plot Ni closest events on map as 'x':

    hold on
    %[na,ma] = size(newt2);
    plos1 = plot(newt2(:,1),-newt2(:,7),'k.','MarkerSize', 1, 'EraseMode','back');
    set(gcf,'Pointer','arrow')
    %
    % plot circle containing events as circle
    x = -pi-0.1:0.1:pi;
    plot(xa0+sin(x)*ra, ya0+cos(x)*ra,'w','era','back')
    l(ni)

    %
    newcat = newt2;                   % resets E, newcat and newt2
    E = newt2;
    clear l s is
    %
    %
    % Calls the program to plot the correlation integral versus the radius R.
    % Then calculates the fractal dimension D.
    %
    %
    dtokm = [];
    pdc3circle;


end % if ic == 2



if ic == 3 % select N closest events

    l = s;
    messtext = ['Radius of selected sphere:' num2str(l(ni))  ' km' ];
    disp(messtext);
    welcome('Message',messtext)
    %
    % take first ni and sort by time
    %
    newt2 = newt2(1:ni,:);
    %[st,ist] = sort(newt2);
    %newt2 = newt2(ist(:,3),:);
    %
    % plot Ni clostest events on map as 'x':

    hold on
    %[na,ma] = size(newt2);
    plos1 = plot(newt2(:,1),-newt2(:,7),'k.','MarkerSize', 0.5, 'EraseMode','back');
    set(gcf,'Pointer','arrow')
    %
    % plot circle containing events as circle
    x = -pi-0.1:0.1:pi;
    plot(xa0+sin(x)*l(ni), ya0+cos(x)*l(ni),'w','era','back')
    l(ni)

    %
    newcat = newt2;                   % resets E, newcat and newt2
    E = newt2;
    clear l s is
    %
    %
    % Calls the program to plot the correlation integral versus the radius R.
    % Then calculates the fractal dimension D.
    %
    %
    dtokm = 0;
    pdc3circle;

end % if ic == 3
%
%
% Plotting of the correlation integral in function of the interevent
% distance r.
%
%
switch(ho);

    case 'nohold'

        Hf_Fig = figure_w_normalized_uicontrolunits('Numbertitle','off','Name','Fractal Dimension');
        Hl_gr1 = loglog(r, corint,'ko');
        set(Hl_gr1,'MarkerSize',10);
        title(sprintf('Subset of %.0f Earthquakes in spheres of %.2f [km] in radius', N, l(ni)) , 'fontsize', 12, 'fontweight', 'bold');
        xlabel('Distance R [km]', 'fontsize', 12);
        ylabel('Correlation Integral C(R)', 'fontsize', 12);
        dofdim;

    case 'hold'

        rad1 = rad;
        ras1 = ras;
        fd1 = coef(1,1);
        deltar1 = deltar;

        figure_w_normalized_uicontrolunits(Hf_Fig);
        axes(Ha_Cax);
        hold on;

        Hl_gr1 = loglog(r, corint,'k+');
        set(Hl_gr1,'MarkerSize',10);
        dofdim;
        set(Hl_gr2b,'color','c');

        str3 = ['Range = ' sprintf('%.2f',rad1) ' - ' sprintf('%.2f',ras1) ' [km]'];
        str4 = ['D =  ' sprintf('%.2f',fd1) ' +/- ' sprintf('%.2f', deltar1)];
        set(te1,'String', str1, 'color', 'c');
        set(te2,'String', str2, 'color', 'c');
        %te3 = text(0.25, 0.7, str3, 'Fontweight','bold', 'Color', 'r');
        %te4 = text(0.25, 0.65, str4, 'Fontweight', 'bold', 'Color', 'r');


        %str1 = ['Range = ' sprintf('%.2f',rad) ' - ' sprintf('%.2f',ras) ' [km]'];
        %str2 = ['D =  ' sprintf('%.2f',coef(1,1)) '  +/- ' sprintf('%.2f', deltar)];
        axes('pos',[0 0 1 1]); axis off; hold on;
        te5 = text(0.18, 0.70, str3, 'fontsize', 12, 'Color', 'b');
        te6 = text(0.18, 0.65, str4, 'fontsize', 12, 'Color', 'b');

end
