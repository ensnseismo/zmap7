
report_this_filefun(mfilename('fullpath'));
global pli plin ps1 ps2


switch(ac2)


    case 'load'


        [file1,path1] = uigetfile([ '*.mat'],' 3D b-value gridfile ');
        %
        if length(path1) < 2
            welcome(' ',' ');done
            return
        else
            lopa = [path1 file1];
            messtext=...
                ['Thank you! Now loading data'
                'Hang on...                 '];
            welcome('  ',messtext);

            try
                set(action_button,'String','Loading Data...');
            catch ME
                welcome;
            end

            try
                load(lopa)
            catch ME
                error_handler(ME,'Error loading data! Are they in the right *.mat format?');
            end
        end
        if ~exist('zv2','var'); zv2 = zvg; end
        if ~exist('R','var') ; R = 5; end
        ac2 = 'new'; myslicer;

    case 'new'

        mac = max(max(max(zv2)))-0.05;
        mic = min(min(min(zv2)));


        slfig = figure_w_normalized_uicontrolunits( ...
            'Name','3D Data Slicer',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'NextPlot','add', ...
            'Visible','on', ...
            'Position',[ fipo(3)-600 fipo(4)-500 800 800]);
        movegui(gcf,'center');

        uicontrol('Units','normal',...
            'Position',[.45 .88 .2 .06],'String','Define X-section ',...
             'Callback','figure_w_normalized_uicontrolunits(slfig); animatorms2 start')

        uicontrol('BackGroundColor',[0.8 0.8 0.6],'Units','normal',...
            'Position',[.0 .93 .2 .06],'String','Refresh ',...
             'Callback','ac2 = ''newax''; myslicer;')

        uicontrol('Units','normal',...
            'Position',[.3 .8 .2 .06],'String','New vert. Slice ',...
             'Callback','ac2 = ''newslice''; myslicer;')


        uicontrol('Units','normal',...
            'Position',[.6 .8 .2 .06],'String','Add vert Slice ',...
             'Callback','ac2 = ''addslice''; myslicer;')


        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.3 .72 .2 .06],'String','New horz. Slice ',...
             'Callback','ac2 = ''newhorslice''; myslicer;')


        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.6 .72 .2 .06],'String','Add horz. Slice ',...
             'Callback','ac2 = ''addhorslice''; myslicer;')

        uicontrol('BackGroundColor',[0.8 0.8 0.6],'Units','normal',...
            'Position',[.0 .0 .2 .06],'String','Help',...
             'Callback','ac2 = ''help''; myslicer;')

        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .83 .2 .06],'String','Show b-value (wls)',...
             'Callback','zv2 = zvg;')


        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .73 .2 .06],'String','Show goodness of fit ',...
             'Callback','zv2 = go;')

        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .63 .2 .06],'String','Show Mc ',...
             'Callback','zv2 = mcma;')

        uicontrol('BackGroundColor',[0.8 0.8 0.8],'Units','normal',...
            'Position',[.0 .53 .2 .06],'String','Show Resolution ',...
             'Callback','zv2 = ra;')

        uicontrol('Units','normal',...
            'Position',[.85 .95 .15 .04],'String','Slicer-map',...
             'Callback','close;slm = ''new''; slicemap;')


        matdraw; axis off
        ac2 = 'newax', myslicer;

    case 'newax'
        try
            delete(sl1)
        catch ME
            error_handler(ME, @do_nothing);
        end
        % Plot the first axes - the map to select xsec orientation
        axes('position',[0.35,  0.10, 0.55, 0.45]);

        dep1 = 0.3*max(a(:,7)); dep2 = 0.6*max(a(:,7)); dep3 = max(a(:,7));

        deplo1 =plot(a(a(:,7)<=dep1,1),a(a(:,7)<=dep1,2),'.b'); hold
        set(deplo1,'MarkerSize',ms6,'Marker',ty1,'era','normal')
        deplo2 =plot(a(a(:,7)<=dep2&a(:,7)>dep1,1),a(a(:,7)<=dep2&a(:,7)>dep1,2),'.g');
        set(deplo2,'MarkerSize',ms6,'Marker',ty2,'era','normal');
        deplo3 =plot(a(a(:,7)<=dep3&a(:,7)>dep2,1),a(a(:,7)<=dep3&a(:,7)>dep2,2),'.r');
        set(deplo3,'MarkerSize',ms6,'Marker',ty3,'era','normal')
        hold on;

        overlay_
        whitebg(gcf,[0 0 0]);
        sl1 = gca; axis equal
        axis([ s2 s1 s4 s3])


    case 'newslice'

        zvg = zv2;
        l = ram > R;
        zvg(l)=nan;
        zv2 = zvg;

        prev = 'ver';
        try
            x = get(pli,'Xdata');
        catch ME
            errordlg(' Please Define a X-section first! ');
            return;
        end
        y = get(pli,'Ydata');
        gx2 = linspace(x(1),x(2),30);
        gy2 = linspace(y(1),y(2),30);
        gz2 = linspace(min(gz),max(gz),30);

        [Y2,Z2] = meshgrid(gy2,gz2);
        X2 = repmat(gx2,30,1);

        [X,Y,Z] = meshgrid(gy,gx,gz);

        [existFlag,figNumber]=figure_exists('Slice',1);

        if ~existFlag
            ac3 = 'new';
            chooseint;
        else
            figure_w_normalized_uicontrolunits(sl2)
            delete(gca); delete(gca);delete(gca)
        end

        hold on;
        ac2 = 'plotslice', myslicer;

    case 'addslice'

        zvg = zv2;
        l = ra > R;
        zvg(l)=nan;
        prev = 'ver';

        try
            x = get(pli,'Xdata');
        catch ME
            error_handler(ME,@do_nothing);
            errordlg(' Please Define a X-section first! ');
            return
        end
        y = get(pli,'Ydata');
        gx2 = linspace(x(1),x(2),30);
        gy2 = linspace(y(1),y(2),30);
        gz2 = linspace(min(gz),max(gz),30);

        [Y2,Z2] = meshgrid(gy2,gz2);
        X2 = repmat(gx2,30,1);


        ac2 = 'plotslice', myslicer;



    case 'addhorslice'

        def = {'33'};
        ni2 = inputdlg('Depth of horizontal slice in [km]','Input',1,def);
        l = ni2{:};
        ds = str2double(l);
        prev = 'hor';


        zvg = zv2;
        l = ra > R;
        zvg(l)=nan;


        gx2 = linspace(min(gx),max(gx),30);
        gy2 = linspace(min(gy),max(gy),30);
        gz2 = linspace(min(gz),max(gz),30);

        [X2,Y2] = meshgrid(gx2,gy2);
        Z2 = (X2*0 - ds);



        ac2 = 'plotslice', myslicer;



    case 'newhorslice'

        def = {'33'};
        ni2 = inputdlg('Depth of horizontal slice in [km]','Input',1,def);
        l = ni2{:};
        ds = str2double(l);
        prev = 'hor';


        zvg = zv2;
        l = ra > R;
        zvg(l)=nan;

        %y = get(pli,'Ydata');
        gx2 = linspace(min(gx),max(gx),30);
        gy2 = linspace(min(gy),max(gy),30);
        gz2 = linspace(min(gz),max(gz),30);

        [X,Y,Z] = meshgrid(gy,gx,gz);
        [X2,Y2] = meshgrid(gx2,gy2);
        Z2 = (X2*0 - ds);

        [existFlag,figNumber]=figure_exists('Slice',1);

        if existFlag == 0;  ac3 = 'new'; chooseint;   end
        if existFlag == 1
            figure_w_normalized_uicontrolunits(sl2)
            delete(gca); delete(gca);delete(gca)
        end

        hold on;
        ac2 = 'plotslice', myslicer;


    case 'plotslice'

        figure_w_normalized_uicontrolunits(sl2)
        hold on; axis manual ; axis ij

        sl = slice(X,Y,Z,zvg,Y2,X2,Z2)
        if prev == 'hor'; set(sl,'tag','slice'); end
        box on
        rotate3d on
        shading interp
        axis([min(gy) max(gy) min(gx) max(gx) min(gz) max(gz)+1 ]);
        view([-120 24]); box on;
        hold on
        whitebg(gcf,[0 0 0]);

        cl = coastline;
        l = cl(:,1) > min(gx) & cl(:,1) < max(gx) & cl(:,2) > min(gy) & cl(:,2) < max(gy);
        cl = cl*inf; cl(l,:) = coastline(l,:);
        if prev == 'hor'; % plot coastline
            plot3(cl(:,2),cl(:,1),cl(:,2)*0-ds,'color',[0.5 0.5 0.5])
        end


        ax = axis;
        f = findobj('tag','slice');
        if isempty(f) == 0
            % set(f(:),'EdgeColor',[0.8 0.8 0.8 ],'EdgeAlpha',0.5);
            set(f(:),'EdgeColor',[0.3 0.3 0.3 ]);

        end


        caxis([mic mac])


        set(gca,'FontSize',12,'FontWeight','bold')
        set(gcf,'Color','k','InvertHardcopy','off')
        slax = gca;

        [mic, mac] = caxis;
        vx =  (mic:0.1:mac);
        v = [vx ; vx]; v = v';
        rect = [0.82 0.03 0.015 0.25];
        axes('position',rect)
        pcolor((1:2),vx,v)
        shading interp
        set(gca,'XTickLabels',[])
        set(gca,'FontSize',12,'FontWeight','bold',...
            'LineWidth',1.0,'YAxisLocation','right',...
            'Box','on','SortMethod','childorder','TickDir','out')
        ax3 = gca;
        ij = jet; ij = ij(64:-1:1,:);
        colormap(jet)
        axes(slax)
        set(slax,'pos',[0.15 0.1 0.6 0.8])



    case 'topo'

        s1 = max(gx); s2 = min(gx);
        s3 = max(gy); s4 = min(gy);
        region = [s4 s3 s2 s1];
        if ~exist('mydem','var')
            try
                [mydem,my,mx] = mygrid_sand(region);
            catch ME
                error_handler(ME, @do_nothing);
                plt = 'err2';
                pltopo
            end
        end

        if max(mx) > 180; mx = mx-360;end

        l2 = min(find(mx >= s2));
        l1 = max(find(mx <= s1));
        l3 = max(find(my <= s3));
        l4 = min(find(my >= s4))
        tmap = mydem(l4:l3,l2:l1);
        %l = isnan(tmap); tmap(l) = -100;

        vlat = my(l4:l3);
        vlon = mx(l2:l1);

        if max(vlon) > 180; vlon = vlon - 360; end


        [m,n] = size(tmap);


        %l = tmap <= 00;
        %tmap(l) = -100;
        axes(slax); axis off;
        po = get(slax,'pos');
        axes('pos',[po]);
        [xx,yy]=meshgrid(vlon,vlat);
        pcolor(yy,xx,tmap/1000),shading interp;

        axis([ax]); axis ij
        ax2 = gca; box on ; grid off

        set(gca,'FontSize',14,'FontWeight','bold',...
            'LineWidth',1.5,...
            'Box','on','SortMethod','childorder','TickDir','out')
        set(ax2,'view',get(slax,'view'))
        set(ax2,'Color','none')

        [tco, clim] = demcmap(tmap/1000,64);
        caxis([clim(1) clim(2)]);
        hc = jet(64);
        %hc = hc(64:-1:1,:);


        co = [tco; hc];
        colormap(co)

        set(slax,'CLim',newclim(65,128,mic,mac,128))
        set(ax3,'CLim',newclim(65,128,mic,mac,128))
        set(ax2,'CLim',newclim(2,64,clim(1),clim(2),128))
        hold on


    case 'topos'

        s1 = max(gx); s2 = min(gx);
        s3 = max(gy); s4 = min(gy);
        region = [s4 s3 s2 s1];

        if exist('mydem') == 0

            try
                [mydem,my,mx] = mygrid_sand(region);
            catch ME
                error_handler(ME, @do_nothing);
                plt = 'err2';
                pltopo
            end
        end
        if max(mx) > 180; mx = mx-360; end
        l2 = min(find(mx >= s2));
        l1 = max(find(mx <= s1));
        l3 = max(find(my <= s3));
        l4 = min(find(my >= s4))
        tmap = mydem(l4:l3,l2:l1);
        l = isnan(tmap); tmap(l) = -100;
        vlat = my(l4:l3);
        vlon = mx(l2:l1);

        if max(vlon) > 180; vlon = vlon - 360; end
        [m,n] = size(tmap);
        axes(slax); axis off;
        po = get(slax,'pos');
        axes('pos',[po]);
        [xx,yy]=meshgrid(vlon,vlat);
        surfl(yy,xx,tmap/400),shading interp;

        li = light('Position',[ 5 0  100],'Style','infinite');
        li = light('Position',[ 0 5  100],'Style','infinite');
        material([.2 .2 0.6]);
        lighting gouraud

        axis([ax]); axis ij
        ax2 = gca; box on ; grid off

        set(gca,'FontSize',14,'FontWeight','bold',...
            'LineWidth',1.5,...
            'Box','on','SortMethod','childorder','TickDir','out')
        set(ax2,'view',get(slax,'view'))
        set(ax2,'Color','none')

        hc2 = gray(64); hc2 = hc2(64:-1:1,:);
        [tco, clim] = demcmap(tmap/1000,64);
        caxis([clim(1) clim(2)]);
        co = [hc2; jet(64)];
        colormap(co)

        set(slax,'CLim',newclim(65,128,mic,mac,128))
        set(ax3,'CLim',newclim(65,128,mic,mac,128))
        set(ax2,'CLim',newclim(3,63,clim(1),clim(2),128))
        hold on

    case 'topos2'

        s1 = max(gx); s2 = min(gx);
        s3 = max(gy); s4 = min(gy);
        region = [s4 s3 s2 s1];

        if exist('mydem') == 0

            try
                [mydem,my,mx] = mygrid_sand(region);
            catch ME
                error_handler(ME, @do_nothing);
                plt = 'err2';
                pltopo
            end
        end
        if max(mx) > 180; mx = mx-360; end
        l2 = min(find(mx >= s2));
        l1 = max(find(mx <= s1));
        l3 = max(find(my <= s3));
        l4 = min(find(my >= s4))
        tmap = mydem(l4:l3,l2:l1);
        l = isnan(tmap); tmap(l) = -100;
        vlat = my(l4:l3);
        vlon = mx(l2:l1);

        if max(vlon) > 180; vlon = vlon - 360; end
        [m,n] = size(tmap);
        axes(slax); axis off;
        po = get(slax,'pos');
        axes('pos',[po]);
        [xx,yy]=meshgrid(vlon,vlat);
        surf(yy,xx,tmap/800),shading interp;

        li = light('Position',[ 5 0  100],'Style','infinite');
        li = light('Position',[ 0 5  100],'Style','infinite');
        material dull;
        lighting phong

        axis([ax]); axis ij
        ax2 = gca; box on ; grid off

        set(gca,'FontSize',14,'FontWeight','bold',...
            'LineWidth',1.5,...
            'Box','on','SortMethod','childorder','TickDir','out')
        set(ax2,'view',get(slax,'view'))
        set(ax2,'Color','none')

        [tco, clim] = demcmap(tmap/800,64);
        caxis([clim(1) clim(2)]);
        hc = jet(64);
        %hc = hc(64:-1:1,:);
        co = [tco; hc];
        colormap(co)

        set(slax,'CLim',newclim(65,128,mic,mac,128))
        set(ax3,'CLim',newclim(65,128,mic,mac,128))
        set(ax2,'CLim',newclim(3,63,clim(1),clim(2),128))
        hold on

    case 'help'

        do = [ 'web ' hodi '/help/3dgrid.htm ;' ];
        err=['errordlg('' Error while opening, please open the browser first and try again or open the file ./help/slicer.hmt manually'');'];
        eval(do,err)


    case 'equal'

        set(slax,'view',get(ax2,'view'))


    case 'setr'


        def = {num2str(mean(mean(mean(ra))))};
        ni2 = inputdlg('Maximum radius of sphere to be plotted [km]','Input',1,def);
        l = ni2{:};
        R = str2double(l);

    case 'setc'


        mac = max(max(max(zv2)));
        mic = min(min(min(zv2)));

        def = {num2str(mac), num2str(mic)};
        prompt = {'Maximum Color scale','Minimu Color scale'};
        ni2 = inputdlg(prompt,'Input',1,def);
        l = ni2{1};
        mac = str2double(l);
        l = ni2{2};
        mic = str2double(l);
        caxis([mic mac]);

        l = zv2 < mic;
        zv2(l) = mic;
        l = zv2 > mac;
        zv2(l) = mac;



end
