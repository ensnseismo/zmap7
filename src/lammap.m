function lammap() % autogenerated function wrapper
    % This is  the m file lammap.m. It will display a map view of the
    % seismicity in Lambert projection and ask for two input
    % points select with the cursor. These input points are
    % the endpoints of the crossection.
    %
    % Stefan Wiemer 2/95
    % turned into function by Celso G Reyes 2017
    
    global mapl
    global h2 xsec_fig newa
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    %
    % Find out if figure already exists
    %
    mapl=findobj('Type','Figure','-and','Name','Seismicity Map (Lambert)');
    
    
    % Set up the Seismicity Map window Enviroment
    %
    if isempty(mapl)
        mapl = figure_w_normalized_uicontrolunits( ...
            'Name','Seismicity Map (Lambert)',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'Visible','off', ...
            'Position',[ (fipo(3:4) - [600 400]) ZmapGlobal.Data.map_len]);
        
        
        drawnow
    end % if figure exist
    
    figure(mapl);
    delete(findobj(mapl,'Type','axes'));
    if isempty(coastline)
        coastline = [ZG.a.Longitude(1) ZG.a.Latitude(1)]
    end
    hold on
    if length(coastline) > 1
        lc_map(coastline(:,2),coastline(:,1),s3,s4,s1,s2)
        g = get(gca,'Children');
        set(g,'Color','k')
    end
    hold on
    if length(faults) > 10
        lc_map(faults(:,2),faults(:,1),s3,s4,s1,s2)
    end
    hold on
    if ~isempty(mainfault)
        lc_map(mainfault(:,2),mainfault(:,1),s3,s4,s1,s2)
    end
    lc_event(ZG.a.Latitude,ZG.a.Longitude,'.k')
    if ~isempty(ZG.maepi)
        lc_event(ZG.maepi.Latitude,ZG.maepi.Longitude,'xm')
    end
    if ~isempty(main)
        lc_event(main(:,2),main(:,1),'+b')
    end
    %title(strib,'FontWeight','bold',...
    %'FontSize',ZmapGlobal.Data.fontsz.m,'Color','k')
    
    uic = uicontrol('Units','normal',...
        'Position',[.05 .00 .40 .06],'String','Select Endpoints with cursor');
    
    titStr ='Create Crossection                      ';
    
    messtext= ...
        ['                                                '
        '  Please use the LEFT mouse button              '
        ' to select the two endpoints of the             '
        ' crossection                                    '
        ];
    
    zmap_message_center.set_message(titStr,messtext);
    
    
    [xsecx xsecy,  inde] = mysect(ZG.a.Latitude',ZG.a.Longitude',ZG.a.Depth,ZG.xsec_width_km);
    
    %if ~isempty(ZG.maepi)
    % [maex, maey] = lc_xsec2(ZG.maepi.Latitude',ZG.maepi.Longitude',ZG.maepi.Depth,ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
    %end
    
    if ~isempty(main)
        [maix, maiy] = lc_xsec2(main(:,2)',main(:,1)',main(:,3),ZG.xsec_width_km,leng,lat1,lon1,lat2,lon2);
        maiy = -maiy;
    end
    delete(uic)
    
    uic3 = uicontrol('Units','normal',...
        'Position',[.80 .88 .20 .10],'String','Make Grid',...
        'callback',@callbackfun_001);
    
    uic4 = uicontrol('Units','normal',...
        'Position',[.80 .68 .20 .10],'String','Make b cross ',...
        'callback',@callbackfun_002);
    uic5 = uicontrol('Units','normal',...
        'position',[.8 .48 .2 .1],'String','Select Eqs',...
        'callback',@callbackfun_003);
    
    figure(mapl);
    uic2 = uicontrol('Units','normal',...
        'Position',[.70 .92 .30 .06],'String','New selection ?',...
        'callback',@callbackfun_004);
    set_width = uicontrol('style','edit','value',ZG.xsec_width_km,...
        'string',num2str(ZG.xsec_width_km), 'background','y',...
        'units','norm','pos',[.90 .00 .08 .06],'min',0,'max',10000,...
        'callback',@callbackfun_005);
    
    wilabel = uicontrol('style','text','units','norm','pos',[.60 .00 .30 .06]);
    set(wilabel,'string','Width in km:','background','y');
    
    % create the selected catalog
    %
    newa  = ZG.a.subset(inde);
    newa = [newa xsecx'];
    % call the m script that produces a grid
    sel = 'in';
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        magrcros();
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        sel = 'in';
        bcross(sel);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        crosssel;
        ZG.newcat=newa ;
        replaceMainCatalog(newa);
        update(mainmap());
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        delete(uic2);
        lammap;
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.xsec_width_km=str2double(set_width.String);
    end
    
end
