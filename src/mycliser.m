%
report_this_filefun(mfilename('fullpath'));

switch ac2

    case new
        sl = figure_w_normalized_uicontrolunits( ...
            'Name','3D Data Slicer',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'NextPlot','add', ...
            'Visible','on', ...
            'Position',[ fipo(3)-600 fipo(4)-500 winx winy]);


    case newax

        % Plot the first axes - the map to select xsec orientation
        axes('position',[0.07,  0.13, 0.3, 0.3])

        dep1 = 0.3*max(a(:,7)); dep2 = 0.6*max(a(:,7)); dep3 = max(a(:,7));

        deplo1 =plot(a(a(:,7)<=dep1,1),a(a(:,7)<=dep1,2),'.b'); hold
        set(deplo1,'MarkerSize',ms6,'Marker',ty1,'era','normal')
        deplo2 =plot(a(a(:,7)<=dep2&a(:,7)>dep1,1),a(a(:,7)<=dep2&a(:,7)>dep1,2),'.g');
        set(deplo2,'MarkerSize',ms6,'Marker',ty2,'era','normal');
        deplo3 =plot(a(a(:,7)<=dep3&a(:,7)>dep2,1),a(a(:,7)<=dep3&a(:,7)>dep2,2),'.r');
        set(deplo3,'MarkerSize',ms6,'Marker',ty3,'era','normal')


        sl1 = gca;

end
