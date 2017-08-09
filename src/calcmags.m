uicontrol('Units','normal','Position',[.90 .10 .10 .10],'String','Wait... ')

report_this_filefun(mfilename('fullpath'));

% n2 = length(cumunew) - tmid;

pause(0.1)
minmag2 = min(b.Magnitude +0.1 );

masi =[];
masi2 =[];
%
% loop over all magnitude bands
%
for i = minmag2:0.1:maxmag

    disp(i)

    %
    % and below
    l =  b.Date > t1p(1) & b.Date < t3p(1) & b.Magnitude < i;
    junk = b(l,:);
    if ~isempty(junk)
        [cumunew, xt] = hist(junk(:,3),t1p(1):days(ZG.bin_days):t3p(1));

        n2 = length(cumunew) - tmid;

        mean1 = mean(cumunew(1:tmid));
        mean2 = mean(cumunew(tmid:length(cumunew)));

        if mean1 & mean2 > 0

            var1 = cov(cumunew(1:tmid));
            var2 = cov(cumunew(tmid:length(cumunew)));
            masi = [masi  (mean1 - mean2)/(sqrt(var1/tmid+var2/(n2)))];
        else
            masi =  [masi 0];
        end   % if mean1

    else
        masi =  [masi 0];
    end   % if junk

    % and above
    %
    l =  b.Date > t1p(1) & b.Date < t3p(1) & b.Magnitude > i;
    junk = b(l,:);
    if ~isempty(junk)
        [cumunew2, xt] = hist(junk(:,3),t1p(1):days(ZG.bin_days):t3p(1));

        mean1a = mean(cumunew2(1:tmid));
        mean2a = mean(cumunew2(tmid:length(cumunew2)));

        if mean1a | mean2a > 0
            var1a = cov(cumunew2(1:tmid));
            var2a = cov(cumunew2(tmid:length(cumunew2)));
            masi2 = [masi2 (mean1a  - mean2a )/(sqrt(var1a /tmid+var2a /(n2)))];
        else
            masi2 = [masi2 0];
        end   % if mean1a

    else
        masi2 = [masi2 0];

    end   % if junk

    % mag(i) = i;
    cumunew = cumunew * 0;
    cumunew2 = cumunew2 * 0;
end  %    for i


% plot Magnitude Signature
%
rect = [0.2,  0.05 0.30, 0.25];
axes('position',rect)
ploma1 = plot(minmag2:0.1:maxmag,masi,'om');
min1 = min([masi masi2]);
max1 = max([masi masi2] );
axis([minmag2 maxmag min1 max1 ]);
set(ploma1,'MarkerSize',8)
hold on
axis([minmag2 maxmag min1 max1 ]);
mag1 = gca;
set(mag1,'TickLength',[0 0])
nu = [0.5 0 ; 3.0 0 ];
plot(nu(:,1),nu(:,2),'-.g')
title('Magnitude ')
xlabel('and below')
ylabel('z-value')
axis([minmag2 maxmag min1 max1 ]);
rect = [0.5,  0.05 0.30, 0.25];
axes('position',rect)
axis([0.5 maxmag  -7 7 ])
ploma2 = plot(minmag2:0.1:maxmag,masi2,'om');

set(ploma2,'MarkerSize',8)

hold on
axis([minmag2 maxmag min1 max1 ]);
%ploma3 = plot(mag(5:maxmag*10)/10,masi2(5:maxmag*10),'y')
%set(ploma3,'LineWidth',3)
axis([minmag2 maxmag min1 max1 ]);
h = gca;
set(h,'YTick',[-10 10])
xlabel('and above')
title('Signature ')
nu = [0.5 0 ; 3.0 0 ];
plot(nu(:,1),nu(:,2),'-.g')

uicontrol('Units','normal','Position',[.90 .10 .10 .10],'String','Done... ')
uicontrol(,'Units','normal','Position',[.90 .51 .10 .05],'String','Print ', 'Callback','print ')
uicontrol('Units','normal','Position',[.90 .71 .10 .05],'String','Save  ', 'Callback','save_ma')
