%
% Creates the input window for the parameters of the factal dimension
% calculation.
%
figure_w_normalized_uicontrolunits('Units','pixel','pos',[200 400 550 250 ],'Name','Parameters','visible','off',...
    'NumberTitle','off','MenuBar','none','Color',[c1 c2 c3],'NextPlot','new');
axis off;

input1 = uicontrol('Style','edit','Position',[.75 .80 .19 .09],...
    'Units','normalized','String',num2str(dim),...
    'Callback','dim=str2double(get(input1,''String'')); set(input1,''String'',num2str(dim));');

input2 = uicontrol(,'Style','popupmenu','Position',[.75 .60 .23 .09],...
    'Units','normalized','String','Automatic Range|Manual Fixed Range',...
    'Value',1,'Callback','range=(get(input2,''Value'')); set(input2,''Value'',range), actrange');

input3 = uicontrol('Style','edit','Position',[.34 .40 .10 .09],...
    'Units','normalized','String',num2str(radm), 'enable', 'off',...
    'Value',1,'Callback','radm=str2double(get(input3,''String'')); set(input3,''String'', num2str(radm));');

input4 = uicontrol('Style','edit','Position',[.75 .40 .10 .09],...
    'Units','normalized','String',num2str(rasm), 'enable', 'off',...
    'Value',1,'Callback','rasm=str2double(get(input4,''String'')); set(input4,''String'', num2str(rasm));');



tx1 = text('EraseMode','normal', 'Position',[0 .90 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Dimension of the Interevent Distances (2 or 3): ');

tx2 = text('EraseMode','normal', 'Position',[0 .65 0 ], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String',' Distance Range within which D is computed: ');

tx3 = text('EraseMode','normal', 'Position',[0 .40 0], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String','Minimum value: ', 'color', 'w');

tx4 = text('EraseMode','normal', 'Position',[.52 .40 0], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String','Maximum value: ', 'color', 'w');

tx5 = text('EraseMode','normal', 'Position',[.41 .40 0], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');

tx6 = text('EraseMode','normal', 'Position',[.94 .40 0], 'Rotation',0 ,...
    'FontSize',fontsz.m , 'FontWeight','bold' , 'String','km', 'color', 'w');


close_button=uicontrol('Style','Pushbutton',...
    'Position',[.60 .05 .20 .15 ],...
    'Units','normalized','Callback','close;welcome('' '','' '');done','String','Cancel');

go_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .05 .20 .15 ],...
    'Units','normalized',...
    'Callback','close;think; org = [8]; startfd;',...
    'String','Go');


set(gcf,'visible','on');
watchoff;
