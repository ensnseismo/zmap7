report_this_filefun(mfilename('fullpath'));

figure_w_normalized_uicontrolunits(map);
x = [];
y = [];
hold on
but=1;
while but==1 | but == 112
    [xi,yi,but] = ginput(1)
    mark1 =    plot(xi,yi,'+k','erase','back'); % doesn't matter what erase mode is
    % used so long as its not NORMAL
    set(mark1,'MarkerSize',8,'LineWidth',2.0)
    n = n + 1;
    % mark2 =     text(xi,yi,[' ' int2str(n)],'era','normal');
    % set(mark2,'FontSize',15,'FontWeight','bold')

    x = [x; xi];
    y = [y; yi];

end

x = [x ; x(1)];
y = [y ; y(1)];     %  closes polygon
figure_w_normalized_uicontrolunits(map)

plos2 = plot(x,y,'k-','Linewidth',2);        % plot outline
sum3 = 0.;
pause(0.3)

do = [' s' num2str(k) ' = [ x(1) y(1) ; x(2) y(2) ; x(4) y(4) ; x(3) y(3) ]; '];
eval(do)

if k == 1
    do = [' save peruzones.mat  s' num2str(k) ' k  '];
    eval(do)
else
    do = [' save peruzones.mat  s' num2str(k) ' k  -append  '];
    eval(do)
end

cu = cu+1;
do = [ ' s = s' num2str(k) ' ;' ]; eval(do);
p = s; v = s;
% resort polygons from seisrisk format
if length(s(:,1)) == 4;  p(3,:) = s(4,:); p(4,:) = s(3,:); p = [p ; p(1,:) ];  end
if length(s(:,1)) == 6;  p(3,:) = s(4,:); p(4,:) = s(6,:); p(6,:) = s(3,:); p = [p ; p(1,:) ];end
if length(s(:,1)) == 8;  p(3,:) = s(4,:); p(4,:) = s(6,:); p(5,:) = s(8,:); p(6,:) = s(6,:);  p(7,:) = s(5,:); p(8,:) = s(3,:); p = [p ; p(1,:) ];end

pl = plot(p(:,1),p(:,2),'r');
set(pl,'Linewidth',2)

x = [p(:,1)];
y = [p(:,2)];      %  closes polygon

sum3 = 0.;
XI = a(:,1);          % this substitution just to make equation below simple
YI = a(:,2);
m = length(x)-1;      %  number of coordinates of polygon
l = 1:length(XI);
l = (l*0)';
l2 = l;               %  Algorithm to select points inside a closed
%  polygon based on Analytic Geometry    R.Z. 4/94
for i = 1:m

    l= ((y(i)-YI < 0) & (y(i+1)-YI >= 0)) & ...
        (XI-x(i)-(YI-y(i))*(x(i+1)-x(i))/(y(i+1)-y(i)) < 0) | ...
        ((y(i)-YI >= 0) & (y(i+1)-YI < 0)) & ...
        (XI-x(i)-(YI-y(i))*(x(i+1)-x(i))/(y(i+1)-y(i)) < 0);

    if i ~= 1
        l2(l) = 1 - l2(l);
    else
        l2 = l;
    end         % if i

end         %  for

newt2 = a(l2,:);
newt2 = a(l2,:);

if length(newt2(:,1)) > 10   % nur wenn mindestens 6 EQ in zone

    timeplot

    set(pl,'color','k')
    figure_w_normalized_uicontrolunits(map); hold on;
    plot(newt2(:,1),newt2(:,2),'go')
    disp(['This is source zone # ' num2str(k) ]);


    %This adjust the data for the completeness and computes rates per year
    l2 = newt2(:,3) >= 1963; newt3 = newt2(l2,:);td = 30;

    l = newt3(:,6) >= 4.75 & newt3(:,6) < 5.25;
    r0 = length(newt3(l,6))/td;
    l = newt3(:,6) >= 5.25 & newt3(:,6) < 5.75;
    r1 = length(newt3(l,6))/td;
    l = newt3(:,6) >= 5.75 & newt3(:,6) < 6.25;
    r2 = length(newt3(l,6))/td;


    l2 = newt2(:,3) >= 1930; newt3 = newt2(l2,:); td = 63;

    l = newt3(:,6) >= 6.25 & newt3(:,6) < 6.75;
    r3 = length(newt3(l,6))/td;
    l = newt3(:,6) >= 6.75 & newt3(:,6) < 7.25;
    r4 = length(newt3(l,6))/td;
    l = newt3(:,6) >= 7.25 & newt3(:,6) < 7.95;
    r5 = length(newt3(l,6))/td;


    if r4 == 0 r4 = r5; end
    if r3 == 0 r3 = r4; end
    if r2 == 0 r2 = r3; end
    if r1 == 0 r1 = r2; end
    if r0 == 0 r0 = r1; end


    r = [r0 r1 r2 r3 r4 r5 ];
    f = min(find(r(2:6) == 0));
    %  if isempty(f) == 0
    %   if f < 6  && f > 1
    %      r(f) = r(f-1)*0.0035
    %  end
    %end
    % write info to file
    % cd /home2/stefan/ZMAP/aspar

    s = ['98   1.     -1          zn9930.00' ]; s = s';
    fprintf(fid2,'%s\n',s);
    s = [num2str(length(v)/2,1) ' 1 1']; s = s';
    fprintf(fid2,'%s\n',s);
    s = [num2str(-v(3,1),5) ' ' num2str(-v(3,2),5) ' ' num2str(-v(4,1),5) ' ' num2str(-v(4,2),5)]; s = s';

    fprintf(fid2,'%s\n',s);
    s = [num2str(-v(1,1),5) ' ' num2str(-v(1,2),5) ' ' num2str(-v(2,1),5) ' ' num2str(-v(2,2),5)]; s = s';

    fprintf(fid2,'%s\n',s);

    anz = [r(1) 5.0 ; r(2) 5.5 ; r(3) 6 ; r(4) 6.5 ; r(5) 7.0 ; r(6) 7.5 ];

    fprintf(fid2,'%7.6f    ',anz(:,1));
    fprintf(fid2,'\n');
    fprintf(fid2,'\n');
    fprintf(fid2,'%3.2f  ',anz(:,2));
    fprintf(fid2,'\n');
end %if at leats 6


ans_ = questdlg('  ',...
    'Define More source zones',...
    'Yes please','No thank you','No' );

switch ans_
    case 'Yes please'
        k = k+1;
        defzones
    case 'No thank you'
        return
end

