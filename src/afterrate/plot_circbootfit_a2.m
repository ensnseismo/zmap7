% Script: plot_circbootfit_a2
% Selects earthquakes in the radius ra around a grid node
% Jochen Woessner
% last update: 17.07.03

report_this_filefun(mfilename('fullpath'));
try
    delete(plos1)
catch
    disp(' ');
end

titStr ='Selecting EQ in Circles                         ';
messtext= ...
    ['                                                '
    '  Please use the LEFT mouse button              '
    ' to select the center point.                    '
    ' The "ni" events nearest to this point          '
    ' will be selected and displayed in the map.     '];

welcome(titStr,messtext);

% Input center of circle with mouse
axes(h1)
[xa0,ya0]  = ginput(1);

stri1 = [ 'Circle: ' num2str(xa0,5) '; ' num2str(ya0,4)];
stri = stri1;
pause(0.1)

%  Calculate distance for each earthquake from center point
%  and sort by distance l
% Calculate distance from center point and sort with distance
sFigName = get(gcf,'Name')

%if (sFigName == 'Omoricros-section' | sFigName == 'RC-Cross-section')
if bMap == 0    % Cross section
    newt2 = newa;
    l = sqrt(((xsecx' - xa0)).^2 + (((xsecy+ya0))).^2) ;
else % Map view
    newt2 = a;
    l = sqrt(((newt2(:,1)-xa0)*cos(pi/180*ya0)*111).^2 + ((newt2(:,2)-ya0)*111).^2) ;
end
[s,is] = sort(l);
newt2 = newt2(is(:,1),:) ;

l =  sort(l);

% Select data in radius ra
l3 = l <= ra;
newt2 = newt2(l3,:);

% Select radius in time
newt3=newt2;
vSel = (newt2(:,3) <= maepi(:,3)+time/365);
newt2 = newt2(vSel,:);
R2 = l(ni);
messtext = ['Number of selected events: ' num2str(length(newt2))  ];
disp(messtext)
welcome('Message',messtext)


% Sort the catalog
[st,ist] = sort(newt2);
newt2 = newt2(ist(:,3),:);
R2 = ra;

% Plot selected earthquakes
hold on;

plos1 = plot(newt2(:,1),newt2(:,2),'xk','EraseMode','normal');

% plot circle containing events as circle
x = -pi-0.1:0.1:pi;
pl = plot(xa0+sin(x)*R2/(cos(pi/180*ya0)*111), ya0+cos(x)*R2/(cos(pi/180*ya0)*111),'k','era','normal')

% Compute and Plot the forecast
%calc_bootfitF(newt3,time,timef,bootloops,maepi)
plot_bootfitloglike_a2(newt3,time,timef,bootloops,maepi);

set(gcf,'Pointer','arrow')
%
newcat = newt2;                   % resets newcat and newt2

% Call program "timeplot to plot cumulative number
clear l s is
timeplot
