function fixax3() % autogenerated function wrapper
    %
    % make dialog interface for the fixing of colomap
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    
    
    % Input Rubberband
    %
    report_this_filefun(mfilename('fullpath'));
    ZG.freeze_colorbar = false;
    
    
    %initial values
    f = figure_w_normalized_uicontrolunits();
    set(gca,'visible','off')
    set(f,'Units','pixel','NumberTitle','off','Name','Input Parameters');
    
    set(f,'pos',[ ZG.welcome_pos ZG.welx+200 ZG.wely-50])
    
    
    % creates a dialog box to input some parameters
    %
    
    inp2_field  = uicontrol('Style','edit',...
        'Position',[.80 .775 .18 .15],...
        'Units','normalized','String',num2str(min(min(re3))),...
        'callback',@callbackfun_001);
    
    txt2 = text(...
        'Position',[0. 0.9 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Please input minimum of z-axis:');
    
    
    txt3 = text(...
        'Position',[0. 0.65 0 ],...
        'FontWeight','bold',...
        'FontSize',ZmapGlobal.Data.fontsz.m ,...
        'String','Please input maximum of z(or b)-values:');
    
    inp3_field=uicontrol('Style','edit',...
        'Position',[.80 .575 .18 .15],...
        'Units','normalized','String',num2str(max(max(re3))),...
        'callback',@callbackfun_002);
    
    %end   % if in = rub        ->no if no end
    
    close_button=uicontrol('Style','Pushbutton',...
        'Position', [.60 .05 .15 .15 ],...
        'Units','normalized','Callback',@(~,~)zmap_Message_center(),'String','Cancel');
    
    go_button=uicontrol('Style','Pushbutton',...
        'Position',[.25 .05 .15 .15 ],...
        'Units','normalized',...
        'callback',@callbackfun_003,...
        'String','Go');
    
    freeze_button = uicontrol(...
        'BackgroundColor',[ 0.7 0.7 0.7 ],...
        'callback',@callbackfun_004,...
        'ForegroundColor',[ 0 0 0 ],...
        'Position',[ 0.25 0.30 0.4 0.15 ],...
        'String','Freeze Colorbar? ',...
        'Style','checkbox',...
        'Units','normalized',...
        'Visible','on');
    
    
    set(f,'visible','on');watchoff
    
    
    
    function callbackfun_001(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        fix1=str2double(inp2_field.String);
        inp2_field.String=num2str(fix1);
    end
    
    function callbackfun_002(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        fix2=str2double(inp3_field.String);
        inp3_field.String=num2str(fix2);
    end
    
    function callbackfun_003(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        fix2=str2num(inp3_field.String);
        fix1=str2num(inp2_field.String);
        zmap_message_center();
        axes(h1);
        caxis([fix1 fix2]);
        hold off;
        h5 = colorbar('vert') ;
        set(h5,'Pos',[apo(1)+apo(3)+0.05 apo(2) 0.03 apo(4)],'FontWeight','bold','FontSize',ZmapGlobal.Data.fontsz.m);
        watchoff;
    end
    
    function callbackfun_004(mysrc,myevt)

        callback_tracker(mysrc,myevt,mfilename('fullpath'));
        ZG.freeze_colorbar=logical(freeze_button.Value);
    end
    
end
