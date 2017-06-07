report_this_filefun(mfilename('fullpath'));

switch(ac3)

    case 'new'


        to1 = figure_w_normalized_uicontrolunits( ...
            'Name','Topographic Map',...
            'NumberTitle','off', ...
            'backingstore','on',...
            'NextPlot','add', ...
            'Visible','on', ...
            'Position',[ fipo(3)-600 fipo(4)-500 winx winy]);

        matdraw


        labelList=[' flat | interp | faceted '];
        labelPos = [0.9 0.93 0.10 0.05];
        hndl3=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva1''; overtopo');


        labelList=[' Volcanoes on  | off '];
        labelPos = [0.9 0.75 0.10 0.05];
        hndl2=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva2''; overtopo');


        uicontrol('Units','normal',...
            'Position',[.0 .0 .28 .04],'String','Plot using Mapping Toolbox ',...
             'Callback','overmaptb')



        labelList=[' EQ (dot) | EQ (o) | No EQ '];
        labelPos = [0.9 0.65 0.10 0.05];
        hndl4=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva4''; overtopo');


        labelList=[' Faults  | No Faults '];
        labelPos = [0.9 0.55 0.10 0.05];
        hndl5a=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva5''; overtopo');

        labelList=[' Coast  | No Coast'];
        labelPos = [0.9 0.45 0.10 0.05];
        hndl5=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva9''; overtopo');


        labelList=[' Main  | No Main '];
        labelPos = [0.9 0.35 0.10 0.05];
        hndl7=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva7''; overtopo');

        labelList=[' Stations   '];
        labelPos = [0.9 0.25 0.10 0.05];
        hndl8=uicontrol(...
            'Style','popup',...
            'Units','normalized',...
            'Position',labelPos,...
            'Value',1,...
            'String',labelList,...
            'BackgroundColor',[0.7 0.7 0.7]',...
            'Callback','ac3 = ''eva8''; overtopo');





    case 'eva1'
        in3 =get(hndl3,'Value');
        if in3 == 1 ; shading flat ; end
        if in3 == 2 ; shading interp ; end
        if in3 == 3 ; shading faceted ; end

    case 'eva2'
        in3 =get(hndl2,'Value');
        if in3 == 1
            plovo = plot(vo(:,1),vo(:,2),'^r');
            set(plovo,'LineWidth',1.5,'MarkerSize',8,...
                'MarkerFaceColor','w','MarkerEdgeColor','r');
        end
        if in3 == 2 ; delete(plovo);  end

    case 'eva4'

        in3 =get(hndl4,'Value');
        if in3 == 1 ; ploe = plot(a(:,1),a(:,2),'.r','MarkerSize',1) ; end
        if in3 == 2 ; ploe = plot(a(:,1),a(:,2),'or','MarkerSize',2) ; end
        if in3 == 3 ; delete(ploe);  end

    case 'eva5'
        in3 =get(hndl5a,'Value');
        if in3 == 1 ; plof = plot(faults(:,1),faults(:,2),'m','Linewidth',2) ; end
        if in3 == 2 ; delete(plof) ; end

    case 'eva9'
        in3 =get(hndl5,'Value');
        if in3 == 1 ; ploc = plot(coastline(:,1),coastline(:,2),'w','Linewidth',2) ; end
        if in3 == 2 ; delete(ploc) ; end

    case 'eva8'

        in3 =get(hndl8,'Value');
        if in3 == 1 ; h1 = h1topo; plotstations ; end
        if in3 == 2 ;  ; end


    case 'eva7'
        in3 =get(hndl7,'Value');
        if in3 == 1 
            epimax2 = plot(maepi(:,1),maepi(:,2),'hm');
            set(epimax2,'LineWidth',1.5,'MarkerSize',12,...
                'MarkerFaceColor','y','MarkerEdgeColor','k')
            te1 = text(maepi(:,1),maepi(:,2),stri2);
            set(te1,'FontWeight','bold','Color','k','FontSize',9,'Clipping','on')
        end

        if in3 == 2 ; delete(epimax2); delete(te1) ; end


end
