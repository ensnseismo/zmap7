%
%   genascum.m  creates a rectangular grid and calls GenAS
%   at each grid point. The output for each grid point is compressed
%   (averaged) magnitude-wise and saved in the file "cumgenas.mat".
%   A map is created with these values.  Operates on catalogue "newcat"
%                                        R. Zuniga  GI, 5/94
%
report_this_filefun(mfilename('fullpath'));

figure_w_normalized_uicontrolunits(mess)
clf
set(gca,'visible','off')

te = text(0.01,0.80,'Please use the LEFT mouse button or the cursor \newlineto select the lower left corner of the area of \newlineinvestigation. Use the LEFT mouse button again \newlineto select the upper right corner ');
set(te,'FontSize',12);

%if exist('fplo') > 0 ; delete(fplo); clear fplo; end
%if exist('mark1') > 0 ; delete(mark1); clear mark1;end

b = newcat;                       % reset b
as2 = [];
count = 0;
figure_w_normalized_uicontrolunits(map)
[x0,y0]  = ginput(1);
mark1 =    plot(x0,y0,'ro','era','normal')
set(mark1,'MarkerSize',10,'LineWidth',2.0)
[x1,y1]  = ginput(1);
f = [x0 y0 ; x1 y0 ; x1 y1 ; x0 y1 ; x0 y0];
fplo = plot(f(:,1),f(:,2),'r','era','normal');
set(fplo,'LineWidth',2)
welcome

gx = x0:dx:x1;
gy = y0:dy:y1;
itotal = length(gx) * length(gy);
clear global ztimes ztime1 ztime2
incx = par1/365;
maxmag = floor(max(newcat(:,6)));
minmg = floor(min(newcat(:,6))); %added the missing minmg similar to maxmag
magstep = 0.5;                   %set the missing magstep to 0.5
evsum = length(newcat(:,1));
n = evsum;
t0b = newcat(1,3)
teb = newcat(evsum,3)
tdiff = round((teb - t0b)*365/par1);
xt = t0b:incx:teb;
bin0 = 1;
bin1 = length(xt)
nmag = minmg:magstep:maxmag;
ztime1 = 1:bin1;
ztime2 = zeros(size(ztime1));
cumu1 = zeros(size(ztime1));
cumu2 = zeros(size(ztime1));
Zsum = zeros(size(ztime1));
Zsuma = Zsum;
Zsumb = Zsum;
Zabsa = Zsum;
Zabsb = Zsum;
Zabs = Zsum;
ncu = length(Zsum)+2;
Zsumall = zeros(ncu,length(gx)*length(gy));
Zabsall = Zsumall;
%
%               labels and tick marks for figures
xsum = ni;
nummag = length(nmag);         %  5 magnitude axis tick marks and labels
tickinc = nummag/4;
xtick = 0:tickinc:nummag;
xtick(1) = 1;
for i = 1:5
    xtlabls(i,:) = sprintf('%3.1f',nmag(xtick(i)));
end
tickinc = bin1/9;                   %  10 tick marks for time axis
ytick = 0:tickinc:bin1;
ytick(1) = 1;
ytlabls(1,:) = sprintf('%3.2f',xt(1));
for i = 1:10
    ytlabls(i,:) = sprintf('%3.2f',xt(ytick(i)));
end


%  make grid, calculate start- endtime etc.  ...
%
% loop over  all points
%
i2 = 0.;
i1 = 0.;
allcount = 0.;
wai = waitbar(0,' Please Wait ...  ');
set(wai,'NumberTitle','off','Name','Makegrid  -Percent done');
set(gcf,'Pointer','watch');
pause(0.1)
figure
cumfg = gcf;
set(cumfg,[50 100 550 400 ],'NumberTitle','off','Name','GenAS-Grid-1');
set(cumfg,'pos',[50 500 550 400]);

set(gca,'visible','off')
txt1 = text(...
    'Color',[0 0 0 ],...
    'EraseMode','normal',...
    'Position',[0.1 0.50 0 ],...
    'Rotation',0 ,...
    'FontSize',16 );
set(txt1,'String', '')
set(txt1,'String',  ' Please Wait...' );
set(gcf,'Pointer','watch');
pause(0.1)
figure;
gen2 = gcf;
set(gen2,[100 100 550 400 ],'NumberTitle','off','Name','GenAS-Grid-2');
figure_w_normalized_uicontrolunits(cumfg);
%
% longitude  loop
%
for x =  x0:dx:x1
    i1 = i1+ 1;

    % latitude loop
    %
    for  y = y0:dy:y1
        cla                         %clear axis of figure
        allcount = allcount + 1.;
        i2 = i2+1;
        % calculate distance from center point and sort wrt distance
        %
        newcat(:,7) = sqrt((newcat(:,1)-x).^2 + (newcat(:,2)-y).^2) * 92.0;
        [s,is] = sort(newcat);
        b = newcat(is(:,7),:) ;       % re-orders matrix to agree row-wise
        % take first ni points
        %
        b = b(1:ni,:);      % new data per grid point (b) is sorted in distance

        [st,ist] = sort(b);   % re-sort wrt time for cumulative count
        b = b(ist(:,3),:);

        for i = minmg:magstep:maxmag,         % steps in magnitude
            clear global ztimes                %clears ztimes from previous results
            cumu1 = cumu1*0;
            cumu2 = cumu2*0;
            ztime1 = ztime1*0;
            ztime2 = ztime2*0;

            l =   b(:,6) < i;            % Mags and below
            junk = b(l,:);
            if ~isempty(junk), [cumu1, xt] = hist(junk(:,3),xt); end

            ztime1 = genas(cumu1,xt,bin1,bin0,bin1);    % call GenAS algorithm

            if i == minmg
                ZBEL = ztime1';
            else
                ZBEL = [ZBEL,  ztime1' ];
            end      % if i

            Zsumb = [Zsumb+ztime1 ];           % calculate sum of Z for below M
            Zabsb = [Zabsb+abs(ztime1) ];      % calculate sum of absolute Z

            clear global ztimes               %clears ztimes from previous results

            l =   b(:,6) > i;           % Mags and above
            junk = b(l,:);
            if ~isempty(junk), [cumu2, xt] = hist(junk(:,3),xt); end

            ztime2 = genas(cumu2,xt,bin1,bin0,bin1);   % call GenAS algorithm

            if i == minmg
                ZABO = ztime2';
            else
                ZABO = [ZABO,  ztime2' ];
            end  %if i

            Zsuma = [Zsuma+ztime2 ];          % calculate sum of Z for above M
            Zabsa = [Zabsa+abs(ztime2) ];     % calculate sum of absolute Z

            S = sprintf('                            magnitude %3.1f done!', i);
            disp(S);

            cumbelow=cumsum(cumu1);
            cumabove=cumsum(cumu2);

            figure_w_normalized_uicontrolunits(cumfg); set(gca,'visible','on');
            plot(xt,cumbelow,'r');
            plot(xt,cumabove,'b-.');
            xlabel('time (yrs)');
            ylabel('cum number of events');

            t1 = xsum-0.05*xsum;
            text(xt(5), t1, '                                   ');
            st1 = num2str(x); st2 = num2str(y); stn = ['grid node ' st2 ' ' st1];
            text(xt(5), t1, stn);
            t1 = xsum-xsum*0.1;
            t1p = [  xt(10)  t1; xt(30)   t1];
            plot(t1p(:,1),t1p(:,2),'r');
            text(xt(35), t1,' mag and below');
            t1 = xsum-xsum*0.2;
            t1p = [  xt(10)  t1; xt(30)   t1];
            plot(t1p(:,1),t1p(:,2),'b-.');
            text(xt(35), t1,' mag and above');

        end        % for i
        % calculate mean Z values over magnitude cuts
        Zsuma = Zsuma/i;         % as a function of time per grid point (Zsumall)
        Zsumb = Zsumb/i;
        Zsum = (Zsumb+Zsuma)/2;  % sum belowM + aboveM and average
        Zabsa = Zabsa/i;
        Zabsb = Zabsb/i;
        Zabs = (Zabsa+Zabsb)/2;
        Zabs = Zabsa + Zabsb;    % same for absolute values

        Zsumall(:,allcount) = [Zsum';  x; y ];
        Zabsall(:,allcount) = [Zabs';  x; y ];

        figure_w_normalized_uicontrolunits(wai);
        waitbar(allcount/itotal);

        figure_w_normalized_uicontrolunits(gen2)                 % show results of GenAS every grid point
        subplot(1,2,1),contour(ZBEL);
        colormap(jet)
        shading interp
        xlabel('Mag and Below');
        ylabel('Time (yrs)');
        set(gca,'Xtick',xtick,'Xticklabels',xtlabls,'Ytick',ytick,...
            'Yticklabels',ytlabls);
        stri = [  ' GenAS - ' file1];
        title(stri)
        %set(gca,'Ytick',ytick,'Yticklabels',ytlabls)
        subplot(1,2,2),contour(ZABO);
        colormap(jet)
        shading interp
        xlabel('Mag and Above');
        set(gca,'Xtick',xtick,'Xticklabels',xtlabls,'Ytick',ytick,...
            'Yticklabels',ytlabls);
        title(stn);
        %set(gca,'Ytick',ytick,'Yticklabels',ytlabls);
        figure_w_normalized_uicontrolunits(cumfg);
    end  % for y0

    i2 = 0;
end  % for x0
S = sprintf('                 FINISH!', i);
disp(S);
set(gcf,'Pointer','arrow');
drawnow
close(wai)

figure;           % plot a comparison of mean Z and  mean absolute Z values
clf;
ma1 = max(max(Zsumall(1:ncu-2,:)));
mi1 = min(min(Zsumall(1:ncu-2,:)));

subplot(1,2,1),pcolor(Zsumall);
colormap(jet)
shading interp
caxis([mi1 ma1])
xlabel('grid node');
ylabel('Time (yrs)');
set(gca,'Ytick',ytick,'Yticklabels',ytlabls);
stri = [  'MeanZ - ' file1];
title(stri)
caxis([mi1 ma1])
colorbar
hold on;
ma1 = max(max(Zabsall(1:ncu-2,:)));
mi1 = min(min(Zabsall(1:ncu-2,:)));

subplot(1,2,2),pcolor(Zabsall);
colormap(jet)
shading interp
caxis([mi1 ma1])
xlabel('grid node');
set(gca,'Ytick',ytick,'Yticklabels',ytlabls);
stri = [  'SumAbsZ ' ];
title(stri)
caxis([mi1 ma1])
colorbar
hold on;

figure_w_normalized_uicontrolunits(mess)
clf
set(gca,'visible','off')

[len, ncu] = size(Zsumall);       % redefine ncu as number of grid points
len = len -2;
max_meanZ = zeros(1,ncu);
min_meanZ = max_meanZ;
cumuall = Zsumall;               % to be able to run other routines

meanZ = Zsumall(1:len,:);
max_meanZ = max(meanZ);           % to use routine view_max
min_meanZ = min(meanZ);
re_1 = reshape(max_meanZ,length(gy),length(gx));
re_2 = reshape(min_meanZ,length(gy),length(gx));
% save data
save cumgenas.mat Zsumall Zabsall re3 par1 ni dx dy gx gy tdiff t0b teb

te = text(0.01,0.90,'The cumulative no. curve was saved in\newline file cumgenas.mat\newline Please rename it if desired.');
set(te,'FontSize',12);

uicontrol('Units','normal','Position',...
    [.1 .10 .2 .12],'String','meanZ at time', 'Callback','ic = 0; timgenas')

uicontrol('Units','normal','Position',...
    [.4 .10 .2 .12],'String','minZmap', 'Callback','stri = [''Min of mean Z'']; re3 = re_2; view_max')

uicontrol('Units','normal','Position',...
    [.7 .10 .2 .12],'String','maxZmap', 'Callback','stri = [''Max of mean Z'']; re3 = re_1; view_max')

close_button = uicontrol('Units','normal','Position',...
    [.7 .7 .2 .12],'String','Close ', 'Callback','welcome')

clear Zsumb Zsuma Zsum Zabsa Zabsb Zabs meanZ max_meanZ min_meanZ;
