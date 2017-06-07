%  This .m file selects the earthquakes within a polygon
%  and plots them. Sets "a" equal to the catalogue produced after the
%  general parameter selection. Operates on "org2", replaces "a"
%  with new data and makes "a" equal to newcat
%                                           Alexander Allmann

report_this_filefun(mfilename('fullpath'));

newt2 = [ ];           % reset catalogue variables
%a = org2;              % uses the catalogue with the pre-selected main
% general parameters
newcat = a;

xcordinate=0;
ycordinate=0;
%axes(h1)
x = [];
y = [];

n = 0;


figure_w_normalized_uicontrolunits(mess)
%set(gcf,'visible','off')
clf;
%cla;
set(gca,'visible','off');
set(gcf, 'Name','Polygon Input Parameters');
%set(gca,'visible','off');

%creates dialog box to input some parameters
%

inp1_field=uicontrol('Style','edit',...
    'Position',[.70 .60 .17 .10],...
    'Units','normalized',...
    'String',num2str(xcordinate),...
    'Callback','xcordinate=str2double(get(inp1_field,''String''));set(inp1_field,''String'',num2str(xcordinate));');

inp2_field=uicontrol('Style','edit',...
    'Position',[.70 .40 .17 .10],...
    'Units','normalized','String',num2str(ycordinate),...
    'Callback','ycordinate=str2double(get(inp2_field,''String''));set(inp2_field,''String'',num2str(ycordinate));');

more_button=uicontrol('Style','Pushbutton',...
    'Position', [.60 .05 .15 .15],...
    'Units','normalized',...
    'Callback','set(mouse_button,''visible'',''off'');but = 1;pickpo;set(load_button,''visible'',''off'');',...
    'String','More');
last_button=uicontrol('Style','Pushbutton',...
    'Position',[.40 .05 .15 .15],...
    'Units','normalized',...
    'Callback','but = 2;pickpo;',...
    'String','Last');

mouse_button=uicontrol('Style','Pushbutton',...
    'Position',[.20 .05 .15 .15],...
    'Units','normalized',...
    'Callback','selectp;',...
    'String','Mouse');

load_button=uicontrol('Style','Pushbutton',...
    'Position',[.80 .05 .15 .15],...
    'Units','normalized',...
    'Callback','but=3;pickpo;',...
    'String','Load');
cancel_button=uicontrol('Style','Pushbutton',...
    'Position',[.05 .80 .15 .15],...
    'Units','normalized',...
    'Callback','welcome;done',...
    'String','cancel');
txt1 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0. 0.65 0 ],...
    'Rotation',0,...
    'FontSize',fontsz.m,...
    'FontWeight','bold',...
    'String','Longitude:');
txt2 = text(...
    'Color',[0 0 0],...
    'EraseMode','normal',...
    'Position',[0. 0.45 0 ],...
    'Rotation',0,...
    'FontWeight','bold',...
    'FontSize',fontsz.m,...
    'String','Latitude:');



