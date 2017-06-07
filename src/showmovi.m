%  this is the file showmovi.m. It dispays a movie with the variable
%  name 'm'.
%   Stefan Wiemer 11/94

report_this_filefun(mfilename('fullpath'));


% This is the info window text
%
ttlStrmov='The Movie Window                                ';
hlpStr1mov= ...
    ['                                                '
    ' This window displays a movie, a series of      '
    ' equivally spaced time cuts. Dispalyed are      '
    ' z-values of the selected function (e.g AS(t))  '
    ' in map view. The colorbar scaling is the same  '
    ' for eah frame, the maximum and minimum are the '
    ' overll maximum for all frames.                 '
    ' Menu options:                                  '
    '                                                '
    ' Circle: select the ni closest earthquakes to a '
    '       point selected with the mouse.           '
    ' Play:  Plays the movie. First the movie is     '
    '       loaded into the memory, then it is played'
    '       n-times (depending on the setting of the '
    '       <# of run> input box)                    '
    ' Speed: This is the number of frames per second '
    '       displayed. Your computer may not be able '
    '       to diplay the movie in high speed.       '
    ' Forward one frame (>) : Displays the next frame'
    ' Backward one frame: Displays the previous frame'
    ' Colormap: Seelect one of the colormaps in the  '
    '       pulldownmenu.                            '
    '                                                '];

% find out if figure exists
[existFlag,figNumber]=figure_exists('Movie Window',1);
newmovWindowFlag=~existFlag;

% Set up the Movie window Enviroment
%
%if newmovWindowFlag
mov =   figure_w_normalized_uicontrolunits( ...
    'Name','Movie Window',...
    'NumberTitle','off', ...
    'MenuBar','none', ...
    'NextPlot','new', ...
    'Visible','on', ...
    'Position',fs);

%end % if exist

figure_w_normalized_uicontrolunits(mov)
hold on
mov = gcf;
whitebg([ c1 c2 c3]);
h = gcf;
speed = 0.5;
clf reset
drawnow;
set(gcf,'resize','off');
set(gca,'pos',rect1)
matdraw
axis off;
cur_color = 'jet';
colormap(jet);
m0 = uicontrol('style','text','unit','norm','pos',[.06 .5 .8 .1]);
set(m0,'string','Please Wait .... loading Data');
set(m0,'background',[c1 c2 c3]);
drawnow;

delete(m0);
[a1,b1] = size(m);

m1 = 'Loading movie to the Graphics Server ... please wait';

movie(m(:,1),1,30);

rect = [0.15 0.90 0.50 0.05 ];
axes('position',rect)
pco2 = pcolor([minc:0.1:maxc ; minc:0.1:maxc]);
set(gca,'visible','on')
h4 = gca;
set(h4,'YTick',[-10 10])
set(h4,'XTick',[-1000 1000])
set(h4,'FontWeight','bold')
shading flat

rect = [0.15 0.90 0.50 0.05 ];
pco5 = axes('position',rect);
h5 = gca;
axis([ minc maxc 0 1  ])
set(h5,'YTick',[-10 10])
set(h5,'FontWeight','bold')

%rect = rect1;
rect = [0.05 0.20 0.82 0.73 ];

pco6 = axes('position',rect1);
axis([min(gx) max(gx) min(gy)  max(gy) ])
hold on
h6 = gca;
hmo = gca;
set(h6,'FontWeight','bold')

movie(m(:,1),1,30);

cs = uicontrol('style','popupmenu','string','HSV|Hot|Cool|Pink|Bone|Gary|Jet');
set(cs,'unit','norm','pos',[.763 .05 .202 .05],...
 'Callback','v = get(cs,''value'');if v==1,cur_color = ''hsv'';elseif v==2,cur_color = ''hot'';elseif v==3,cur_color = ''cool'';elseif v==4,cur_color = ''pink'';elseif v==5,cur_color = ''bone'';elseif v==6,cur_color = ''gray'';elseif v==7,cur_color = ''jet'';end,colormap(cur_color);movie(m(:,i),1,1);');
h2 = uicontrol('style','text','unit','norm','string','Colormap');
set(h2,'pos',[.763 .1 .2 .05],'background',[c1 c2 c3]);


frame_slide = uicontrol('style','slider','max',b1,'min',1,'uni','norm');
set(frame_slide,'value',1,'pos',[.750 .25 .04 .5], 'Callback','i=(get(frame_slide,''Value'')),movie(m(:,i),1,1)');
frame = uicontrol('style','edit','value',10,'string',num2str(i),'call','speed=str2double(get(frame,''String''))');
flabel = uicontrol('style','text','units','norm','pos',[.55 .13 .2 .05]);
set(flabel,'string','Speed','background',[c1 c2 c3]);
set(frame,'units','norm','pos',[.60 .07 .1 .05],'min',0.1,'max',30);

uicontrol('style','text','units','norm','pos',[.80 .90 .20 .05],...
    'String','Forward 1 ','background',[c1 c2 c3]);
uicontrol('style','text','units','norm','pos',[.80 .80 .20 .05],...
    'String','Backward 1 ','background',[c1 c2 c3]);

next = uicontrol('style','pushbutton','unit','norm','pos',[0.75 .90 .04 .05]);
set(next,'string','>','ForeGroundColor','k');
set(next, 'Callback','i=i+1;if i > b1; i=b1;end;movie(m(:,i),1,1);set(frame_slide,''value'',i)');
bac = uicontrol('style','pushbutton','unit','norm','pos',[0.75 .80 .04 .05]);
set(bac,'string','<');
set(bac, 'Callback','i=i-1;if i < 1; i=1;end;movie(m(:,i),1,1);set(frame_slide,''value'',i)');
time = uicontrol('style','edit','value',3,'string',num2str(3),'call','set(time,''value'',str2double(get(time,''string'')))');
set(time,'units','norm','pos',[.23 .07 .1 .05],'min',1,'max',1000);
tlabel = uicontrol('style','text','units','norm','pos',[.18 .13 .2 .05]);
set(tlabel,'string','# of runs','background',[c1 c2 c3]);
start = uicontrol('style','pushbutton','unit','norm','pos',[.06 .05 .15 .1]);
set(start,'interruptible','yes','string','Play');
set(start, 'Callback','disp(m1),movie(m,fix(get(time,''value'')*15/size(m,2)),speed)');
mc = 'close(gcf)';

circ = uicontrol('units','norm','pos',[.40 .10 .10 .1],'style','pushbutton');
set(circ,'string','Circle', 'Callback',' circmo');

set_ni = uicontrol('style','edit','value',100,'string',num2str(100));

set(set_ni,'Callback','ni=str2double(get(set_ni,''String'')); set(set_ni,''String'',num2str(ni));');

set(set_ni,'units','norm','pos',[.40 .02 .15 .05],'min',10,'max',10000);
nilabel = uicontrol('style','text','units','norm','pos',[.36 .02 .04 .05]);
set(nilabel,'string','ni:','background',[c1 c2 c3]);


uicontrol('Units','normal',...
    'Position',[.0 .95 .08 .06],'String','Close ',...
     'Callback','clear m;close(mov);welcome;done')

uicontrol('Units','normal',...
    'Position',[.0 .85 .08 .06],'String','Info ',...
     'Callback','zmaphelp(ttlStrmov,hlpStr1mov)')

uicontrol('Units','normal',...
    'Position',[.0 .75 .08 .06],'String','Refresh ',...
     'Callback','close; showmovi');

%si = signatur('ZMAP','',[0.01 0.02]);
%set(si,'Color','k')

axes(h6);
watchoff(mess)
watchoff(mov)
done

