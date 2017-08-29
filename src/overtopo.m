function overtopo() % autogenerated function wrapper
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    report_this_filefun(mfilename('fullpath'));
    
    to1 = figure_w_normalized_uicontrolunits( ...
        'Name','Topographic Map',...
        'NumberTitle','off', ...
        'backingstore','on',...
        'NextPlot','add', ...
        'Visible','on', ...
        'Position',[ (fipo(3:4) - [600 500]) ZmapGlobal.Data.map_len]);
    
    
    labelList=[' flat | interp | faceted '];
    labelPos = [0.9 0.93 0.10 0.05];
    hndl3=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_001);
    
    
    labelList=[' Volcanoes on  | off '];
    labelPos = [0.9 0.75 0.10 0.05];
    hndl2=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_002);
    
    
    uicontrol('Units','normal',...
        'Position',[.0 .0 .28 .04],'String','Plot using Mapping Toolbox ',...
        'callback',@callbackfun_003)
    
    
    
    labelList=[' EQ (dot) | EQ (o) | No EQ '];
    labelPos = [0.9 0.65 0.10 0.05];
    hndl4=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_004);
    
    
    labelList=[' Faults  | No Faults '];
    labelPos = [0.9 0.55 0.10 0.05];
    hndl5a=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_005);
    
    labelList=[' Coast  | No Coast'];
    labelPos = [0.9 0.45 0.10 0.05];
    hndl5=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_006);
    
    
    labelList=[' Main  | No Main '];
    labelPos = [0.9 0.35 0.10 0.05];
    hndl7=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_007);
    
    labelList=[' Stations   '];
    labelPos = [0.9 0.25 0.10 0.05];
    hndl8=uicontrol(...
        'Style','popup',...
        'Units','normalized',...
        'Position',labelPos,...
        'Value',1,...
        'String',labelList,...
        'BackgroundColor',[0.7 0.7 0.7]',...
        'callback',@callbackfun_008);
    
    
    

    %% callbacks 
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl3,'Value');
        if in3 == 1 ; shading flat ; end
        if in3 == 2 ; shading interp ; end
        if in3 == 3 ; shading faceted ; end
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl2,'Value');
        if in3 == 1
            plovo = plot(vo.Longitude,vo.Latitude,'^r');
            set(plovo,'LineWidth',1.5,'MarkerSize',8,...
                'MarkerFaceColor','w','MarkerEdgeColor','r');
        end
        if in3 == 2 ; delete(plovo);  end
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        overmaptb();
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        
        in3 =get(hndl4,'Value');
        if in3 == 1 ; ploe = plot(ZG.a.Longitude,ZG.a.Latitude,'.r','MarkerSize',1) ; end
        if in3 == 2 ; ploe = plot(ZG.a.Longitude,ZG.a.Latitude,'or','MarkerSize',2) ; end
        if in3 == 3 ; delete(ploe);  end
    end
    
    function callbackfun_005(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl5a,'Value');
        if in3 == 1 ; plof = plot(faults(:,1),faults(:,2),'m','Linewidth',2) ; end
        if in3 == 2 ; delete(plof) ; end
        
    end
    
    function callbackfun_006(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl5,'Value');
        if in3 == 1 ; ploc = plot(coastline(:,1),coastline(:,2),'w','Linewidth',2) ; end
        if in3 == 2 ; delete(ploc) ; end
    end
    
    function callbackfun_007(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl7,'Value');
        if in3 == 1
            epimax2 = plot(ZG.maepi.Longitude,ZG.maepi.Latitude,'hm');
            set(epimax2,'LineWidth',1.5,'MarkerSize',12,...
                'MarkerFaceColor','y','MarkerEdgeColor','k')
            te1 = text(ZG.maepi.Longitude,ZG.maepi.Latitude,stri2);
            set(te1,'FontWeight','bold','Color','k','FontSize',9,'Clipping','on')
        end
        
        if in3 == 2 ; delete(epimax2); delete(te1) ; end
    end
    
    function callbackfun_008(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        in3 =get(hndl8,'Value');
        if in3 == 1 ; h1 = h1topo; plotstations ; end
    end
    
end
