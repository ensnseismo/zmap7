% Script: rc_cross_a2
% Calculate relative rate changes and Omori_parameters on cross section.
% This subroutine assigns creates a grid with spacing dx,dy (in degreees). The size will
% be selected interactively or the entire area. The values are calculated for in each volume
% around a grid point containing ni earthquakes
% J. Woessner
% last update: 31.08.03

report_this_filefun(mfilename('fullpath'));

global no1 bo1 inb1

% Do we have to create the dialogbox?
if sel == 'in'
    % Set the grid parameter
    % initial values
    %
    dd = 1.00; % Depth spacing in km
    dx = 1.00 ; % X-Spacing in km
    ni = 100;   % Number of events
    bv2 = NaN;
    Nmin = 50;  % Minimum number of events
    stan2 = NaN;
    stan = NaN;
    prf = NaN;
    av = NaN;
    nRandomRuns = 1000;
    bGridEntireArea = 0;
    time = 47;
    timef= 20;
    bootloops = 50;
    ra = 5;
    fMaxRadius = 5;

    % cut catalog at mainshock time:
    l = a(:,3) > maepi(1,3);
    a = a(l,:);

    % Create the dialog box
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'units','points',...
        'Visible','on', ...
        'Position',[ wex+200 wey-200 550 300], ...
        'Color', [0.8 0.8 0.8]);
    axis off

    %     % Dropdown list
    %     labelList2=[' Automatic Mc (max curvature) | Fixed Mc (Mc = Mmin) | Automatic Mc (90% probability) | Automatic Mc (95% probability) | Best combination (Mc95 - Mc90 - max curvature)'];
    %     hndl2=uicontrol(...
    %         'Style','popup',...
    %         'Position',[ 0.2 0.77  0.6  0.08],...
    %         'Units','normalized',...
    %         'String',labelList2,...
    %         'BackgroundColor','w',...
    %         'Callback','inb2 =get(hndl2,''Value''); ');

    %     % Set selection to 'Best combination'
    %     set(hndl2,'value',5);

    % Edit fields, radiobuttons, and checkbox
    freq_field=uicontrol('Style','edit',...
        'Position',[.30 .70 .12 .08],...
        'Units','normalized','String',num2str(ni),...
        'FontSize',fontsz.m ,...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));set(tgl2,''value'',0); set(tgl1,''value'',1)');

    freq_field0=uicontrol('Style','edit',...
        'Position',[.30 .60 .12 .08],...
        'Units','normalized','String',num2str(ra),...
        'FontSize',fontsz.m ,...
        'Callback','ra=str2double(get(freq_field0,''String'')); set(freq_field0,''String'',num2str(ra)) ; set(tgl2,''value'',1); set(tgl1,''value'',0)');

    freq_field2=uicontrol('Style','edit',...
        'Position',[.30 .40 .12 .08],...
        'Units','normalized','String',num2str(dx),...
        'FontSize',fontsz.m ,...
        'Callback','dx=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(dx));');

    freq_field3=uicontrol('Style','edit',...
        'Position',[.30 .30 .12 .08],...
        'Units','normalized','String',num2str(dd),...
        'FontSize',fontsz.m ,...
        'Callback','dd=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(dd));');

    freq_field7=uicontrol('Style','edit',...
        'Position',[.68 .40 .12 .080],...
        'Units','normalized','String',num2str(time),...
        'Callback','time=str2double(get(freq_field7,''String'')); set(freq_field7,''String'',num2str(time));');

    freq_field5=uicontrol('Style','edit',...
        'Position',[.68 .50 .12 .080],...
        'Units','normalized','String',num2str(timef),...
        'Callback','timef=str2double(get(freq_field5,''String'')); set(freq_field5,''String'',num2str(timef));');

    freq_field6=uicontrol('Style','edit',...
        'Position',[.68 .60 .12 .080],...
        'Units','normalized','String',num2str(bootloops),...
        'Callback','bootloops=str2double(get(freq_field6,''String'')); set(freq_field6,''String'',num2str(bootloops));');

    freq_field8=uicontrol('Style','edit',...
        'Position',[.68 .70 .12 .080],...
        'Units','normalized','String',num2str(fMaxRadius),...
        'Callback','fMaxRadius=str2double(get(freq_field8,''String'')); set(freq_field8,''String'',num2str(fMaxRadius));');

    tgl1 = uicontrol('BackGroundColor', [0.8 0.8 0.8], ...
        'Style','radiobutton',...
        'string','Number of events:',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Position',[.02 .70 .28 .08], 'Callback','set(tgl2,''value'',0)',...
        'Units','normalized');

    % Set to constant number of events
    set(tgl1,'value',1);

    tgl2 =  uicontrol('BackGroundColor',[0.8 0.8 0.8],'Style','radiobutton',...
        'string','Constant radius [km]:',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Position',[.02 .60 .28 .08], 'Callback','set(tgl1,''value'',0)',...
        'Units','normalized');

    %     chkRandom = uicontrol('BackGroundColor',[0.8 0.8 0.8],'Style','checkbox',...
    %         'String', 'Additional random simulation',...
    %         'FontSize',fontsz.m ,...
    %         'FontWeight','bold',...
    %         'Position',[.52 .35 .40 .08],...
    %         'Units','normalized');
    %     txtRandomRuns = uicontrol('Style','edit',...
    %         'Position',[.80 .25 .12 .08],...
    %         'Units','normalized','String',num2str(nRandomRuns),...
    %         'FontSize',fontsz.m ,...
    %         'Callback','nRandomRuns=str2double(get(txtRandomRuns,''String'')); set(txtRandomRuns,''String'',num2str(nRandomRuns));');

    freq_field4 =  uicontrol('Style','edit',...
        'Position',[.30 .20 .12 .08],...
        'Units','normalized','String',num2str(Nmin),...
        'FontSize',fontsz.m ,...
        'Callback','Nmin=str2double(get(freq_field4,''String'')); set(freq_field4,''String'',num2str(Nmin));');

    chkGridEntireArea = uicontrol('BackGroundColor', [0.8 0.8 0.8], ...
        'Style','checkbox',...
        'string','Create grid over entire area',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Position',[.02 .06 .40 .08], 'Units','normalized', 'Value', 0);

    % Buttons
    uicontrol('BackGroundColor', [0.8 0.8 0.8], 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [.80 .05 .15 .12], ...
        'Callback', 'close;done', 'String', 'Cancel');

    uicontrol('BackGroundColor', [0.8 0.8 0.8], 'Style', 'pushbutton', ...
        'Units', 'normalized', 'Position', [.60 .05 .15 .12], ...
        'Callback', 'tgl1 =get(tgl1,''Value'');tgl2 =get(tgl2,''Value''); bGridEntireArea = get(chkGridEntireArea, ''Value'');close,sel =''ca'', rc_cross_a2',...
        'String', 'OK');

    % Labels
    %     text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
    %         'Position', [0.2 1 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
    %         'FontSize', fontsz.l, 'FontWeight', 'bold', 'String', 'Please select a Mc estimation option');
    %
    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [0.3 0.95 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
        'FontSize', fontsz.l, 'FontWeight', 'bold', 'String', 'Grid parameters');

    text('Color',[0 0 0], 'EraseMode','normal', 'Units', 'normalized', ...
        'Position', [-.14 .42 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String','Horizontal spacing [km]:');

    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [-0.14 0.30 0], 'Rotation', 0, 'HorizontalAlignment', 'left', ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String', 'Depth spacing [km]:');

    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [-0.14 0.18 0], 'Rotation', 0, 'HorizontalAlignment', 'left', ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String', 'Min. number of events:');

    txt8 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.42 0.55 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Forecast period:');
    txt9 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.42 0.43 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Learning period:');

    txt10 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.42 0.66 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Bootstrap samples:');

    txt11 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.42 0.78 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'String','Max. Radius /[km]:');

    %     text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
    %         'Position', [0.5 0.24 0], 'Rotation', 0, 'HorizontalAlignment', 'left', ...
    %         'FontSize',fontsz.m, 'FontWeight', 'bold', 'String', 'Number of runs:');

    if term == 1 ; whitebg(gcf,[1 1 1 ]);end
    set(gcf,'visible','on');
    watchoff
end   % if sel == in

% get the grid-size interactively and
% calculate the b-value in the grid by sorting
% the seimicity and selecting the ni neighbors
% to each grid point

if sel == 'ca'

    figure_w_normalized_uicontrolunits(xsec_fig)
    hold on

    if bGridEntireArea % Use entire area for grid
        vXLim = get(gca, 'XLim');
        vYLim = get(gca, 'YLim');
        x = [vXLim(1); vXLim(1); vXLim(2); vXLim(2)];
        y = [vYLim(2); vYLim(1); vYLim(1); vYLim(2)];
        x = [x ; x(1)];
        y = [y ; y(1)];     %  closes polygon
        clear vXLim vYLim;
    else
        messtext=...
            ['To select a polygon for a grid.       '
            'Please use the LEFT mouse button of   '
            'or the cursor to the select the poly- '
            'gon. Use the RIGTH mouse button for   '
            'the final point.                      '
            'Mac Users: Use the keyboard "p" more  '
            'point to select, "l" last point.      '
            '                                      '];
        welcome('Select Polygon for a grid',messtext);

        ax = findobj('Tag','main_map_ax');
        [x,y, mouse_points_overlay] = select_polygon(ax);

        welcome('Message',' Thank you .... ')
    end % of if bGridEntireArea

    plos2 = plot(x,y,'b-','era','xor');        % plot outline
    sum3 = 0.;
    pause(0.3)

    %create a rectangular grid
    xvect=[min(x):dx:max(x)];
    yvect=[min(y):dd:max(y)];
    gx = xvect;gy = yvect;
    tmpgri=zeros((length(xvect)*length(yvect)),2);
    n=0;
    for i=1:length(xvect)
        for j=1:length(yvect)
            n=n+1;
            tmpgri(n,:)=[xvect(i) yvect(j)];
        end
    end
    %extract all gridpoints in chosen polygon
    XI=tmpgri(:,1);
    YI=tmpgri(:,2);

    ll = polygon_filter(x,y,XI,YI,'inside');
    newgri=tmpgri(ll,:);

    % Plot all grid points
    plot(newgri(:,1),newgri(:,2),'+k')

    if length(xvect) < 2  ||  length(yvect) < 2
        errordlg('Selection too small! (not a matrix)');
        return
    end

    itotal = length(newgri(:,1));
    if length(gx) < 4  ||  length(gy) < 4
        errordlg('Selection too small! ');
        return
    end


    welcome(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    t0b = newa(1,3)  ;
    n = length(newa(:,1));
    teb = newa(n,3) ;
    tdiff = round((teb - t0b)*365/par1);
    loc = zeros(3,length(gx)*length(gy));

    % loop over  all points
    %
    i2 = 0.;
    i1 = 0.;
    mRcCross = []; %NaN(length(newgri),14);
    allcount = 0.;
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name','b-value grid - percent done');;
    drawnow
    %
    % loop


    %   % overall b-value
    %   [bv magco stan av me mer me2,  pr] =  bvalca3(newa,inb1,inb2);
    %   bo1 = bv; no1 = length(newa(:,1));
    %
    for i= 1:length(newgri(:,1))
        x = newgri(i,1);y = newgri(i,2);
        allcount = allcount + 1.;
        i2 = i2+1;

        % Select subcatalog
        % Calculate distance from center point and sort with distance
        l = sqrt(((xsecx' - x)).^2 + ((xsecy + y)).^2) ;
        [s,is] = sort(l);
        b = newa(is(:,1),:) ;       % re-orders matrix to agree row-wise

        %         % Choose method of constant radius or constant number
        %         if tgl1 == 0   % take point within r
        %             l3 = l <= ra;
        %             b = newa(l3,:);      % new data per grid point (b) is sorted in distanc
        %             rd = ra;
        %         else
        %             % take first ni points
        %             b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
        %             rd = s(ni);
        %         end
        % Choose between constant radius or constant number of events with maximum radius
        if tgl1 == 0   % take point within r
            % Use Radius to determine grid node catalogs
            l3 = l <= ra;
            b = a(l3,:);      % new data per grid point (b) is sorted in distance
            rd = ra;
            vDist = sort(l(l3));
            fMaxDist = max(vDist);
            % Calculate number of events per gridnode in learning period time
            vSel = b(:,3) <= maepi(1,3)+time/365;
            mb_tmp = b(vSel,:);
        else
            % Determine ni number of events in learning period
            % Set minimum number to constant number
            Nmin = ni;
            % Select events in learning time period
            vSel = (b(:,3) <= maepi(1,3)+time/365);
            b_learn = b(vSel,:);
            vSel2 = (b(:,3) > maepi(1,3)+time/365 & b(:,3) <= maepi(1,3)+(time+timef)/365);
            b_forecast = b(vSel2,:);

            % Distance from grid node for learning period and forecast period
            vDist = sort(l(vSel));
            vDist_forecast = sort(l(vSel2));

            % Select constant number
            b_learn = b_learn(1:ni,:);
            % Maximum distance of events in learning period
            fMaxDist = vDist(ni);

            if fMaxDist <= fMaxRadius
                vSel3 = vDist_forecast <= fMaxDist;
                b_forecast = b_forecast(vSel3,:);
                b = [b_learn; b_forecast];
            else
                vSel4 = (l < fMaxRadius & b(:,3) <= maepi(1,3)+time/365);
                b = b(vSel4,:);
                b_learn = b;
            end
            length(b_learn)
            length(b_forecast)
            length(b)
            mb_tmp = b_learn;
        end % End If on tgl1

        %Set catalog after selection
        newt2 = b;

        % Calculate the relative rate change, p, c, k, resolution
        if length(b) >= Nmin  % enough events?
            [mRc] = calc_rcloglike_a2(b,time,timef,bootloops, maepi);
            % Relative rate change normalized to sigma of bootstrap
            if mRc.fStdBst~=0
                mRc.fRcBst = mRc.absdiff/mRc.fStdBst;
            else
                mRc.fRcBst = NaN;
            end

            % Number of events per gridnode
            [nY,nX]=size(mb_tmp);
            % Final grid
            mRc.nY = nY;
            mRc.fMaxDist = fMaxDist;
            mRcCross = [mRcCross; mRc.time mRc.absdiff mRc.numreal mRc.nummod mRc.pval1 mRc.pmedStd1 mRc.cval1 mRc.cmedStd1...
                mRc.kval1 mRc.kmedStd1 mRc.fStdBst mRc.nMod mRc.nY mRc.fMaxDist mRc.fRcBst...
                mRc.pval2 mRc.pmedStd2 mRc.cval2 mRc.cmedStd2 mRc.kval2 mRc.kmedStd2 mRc.H mRc.KSSTAT mRc.P mRc.fRMS];
        else
            mRcCross = [mRcCross; NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
        end
        waitbar(allcount/itotal)
    end  % for newgr

    % save data
    %
    drawnow
    gx = xvect;gy = yvect;

    % Save the data to rcval_grid.mat
    save rcval_grid.mat mRcCross gx gy dx dy par1 tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri ll bo1 newgri ra time timef bootloops maepi xsecx xsecy
    disp('Saving data to rcval_grid.mat in current directory')
    %     catSave3 =...
    %         [ 'welcome(''Save Grid'',''  '');think;',...
    %             '[file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Grid Datafile Name?'') ;',...
    %             ' sapa2 = [''save '' path1 file1 '' mRcCross gx gy dx dy par1 tdiff t0b teb a main faults mainfault coastline yvect xvect tmpgri ll bo1 newgri gll''];',...
    %             ' if length(file1) > 1, eval(sapa2),end , done']; eval(catSave3)

    close(wai)
    watchoff

    % plot the results
    %                mRcCross = [mRcCross; mRc.time mRc.absdiff mRc.numreal mRc.nummod mRc.pval1 mRc.pmedStd1 mRc.cval1 mRc.cmedStd1...
    %                     mRc.kval1 mRc.kmedStd1 mRc.fStdBst mRc.nMod mRc.nY mRc.fMaxDist mRc.fRcBst...
    %                     mRc.pval2 mRc.pmedStd2 mRc.cval2 mRc.cmedStd2 mRc.kval2 mRc.kmedStd2 mRc.H mRc.fRMS];

    normlap2=NaN(length(tmpgri(:,1)),1);
    % Relative rate change
    normlap2(ll)= mRcCross(:,15);
    mRelchange = reshape(normlap2,length(yvect),length(xvect));

    %%% p,c,k- values for period before large aftershock or just modified Omori law
    % p-value
    normlap2(ll)= mRcCross(:,5);
    mPval=reshape(normlap2,length(yvect),length(xvect));

    % p-value standard deviation
    normlap2(ll)= mRcCross(:,6);
    mPvalstd = reshape(normlap2,length(yvect),length(xvect));

    % c-value
    normlap2(ll)= mRcCross(:,7);
    mCval = reshape(normlap2,length(yvect),length(xvect));

    % c-value standard deviation
    normlap2(ll)= mRcCross(:,8);
    mCvalstd = reshape(normlap2,length(yvect),length(xvect));

    % k-value
    normlap2(ll)= mRcCross(:,9);
    mKval = reshape(normlap2,length(yvect),length(xvect));

    % k-value standard deviation
    normlap2(ll)= mRcCross(:,10);
    mKvalstd = reshape(normlap2,length(yvect),length(xvect));

    %%% Resolution parameters
    % Number of events per grid node
    normlap2(ll)= mRcCross(:,13);
    mNumevents = reshape(normlap2,length(yvect),length(xvect));

    % Radii of chosen events, Resolution
    normlap2(ll)= mRcCross(:,14);
    vRadiusRes = reshape(normlap2,length(yvect),length(xvect));

    % Chosen fitting model
    normlap2(ll)= mRcCross(:,12);
    mMod = reshape(normlap2,length(yvect),length(xvect));

    try
        %%% p,c,k- values for period AFTER large aftershock
        % p-value
        normlap2(ll)= mRcCross(:,16);
        mPval2=reshape(normlap2,length(yvect),length(xvect));

        % p-value standard deviation
        normlap2(ll)= mRcCross(:,17);
        mPvalstd2 = reshape(normlap2,length(yvect),length(xvect));

        % c-value
        normlap2(ll)= mRcCross(:,18);
        mCval2 = reshape(normlap2,length(yvect),length(xvect));

        % c-value standard deviation
        normlap2(ll)= mRcCross(:,19);
        mCvalstd2 = reshape(normlap2,length(yvect),length(xvect));

        % k-value
        normlap2(ll)= mRcCross(:,20);
        mKval2 = reshape(normlap2,length(yvect),length(xvect));

        % k-value standard deviation
        normlap2(ll)= mRcCross(:,21);
        mKvalstd2 = reshape(normlap2,length(yvect),length(xvect));

        % KS-Test (H-value) binary rejection criterion at 95% confidence level
        normlap2(ll)= mRcCross(:,22);
        mKstestH = reshape(normlap2,length(yvect),length(xvect));

        %  KS-Test statistic for goodness of fit
        normlap2(ll)= mRcCross(:,23);
        mKsstat = reshape(normlap2,length(yvect),length(xvect));

        %  KS-Test p-value
        normlap2(ll)= mRcCross(:,24);
        mKsp = reshape(normlap2,length(yvect),length(xvect));

        % RMS value for goodness of fit
        normlap2(ll)= mRcCross(:,25);
        mRMS = reshape(normlap2,length(yvect),length(xvect));
    catch
        disp('Values not calculated')
    end
    % Data to plot first map
    re3 = mRelchange;
    lab1 = 'Rate change';

    % View the map
    view_rccross_a2

end   % if sel = na

% Load exist b-grid
if sel == 'lo'
    [file1,path1] = uigetfile(['*.mat'],'b-value gridfile');
    if length(path1) > 1
        think
        load([path1 file1])

        normlap2=NaN(length(tmpgri(:,1)),1);
        % Relative rate change
        normlap2(ll)= mRcCross(:,15);
        mRelchange = reshape(normlap2,length(yvect),length(xvect));

        %%% p,c,k- values for period before large aftershock or just modified Omori law
        % p-value
        normlap2(ll)= mRcCross(:,5);
        mPval=reshape(normlap2,length(yvect),length(xvect));

        % p-value standard deviation
        normlap2(ll)= mRcCross(:,6);
        mPvalstd = reshape(normlap2,length(yvect),length(xvect));

        % c-value
        normlap2(ll)= mRcCross(:,7);
        mCval = reshape(normlap2,length(yvect),length(xvect));

        % c-value standard deviation
        normlap2(ll)= mRcCross(:,8);
        mCvalstd = reshape(normlap2,length(yvect),length(xvect));

        % k-value
        normlap2(ll)= mRcCross(:,9);
        mKval = reshape(normlap2,length(yvect),length(xvect));

        % k-value standard deviation
        normlap2(ll)= mRcCross(:,10);
        mKvalstd = reshape(normlap2,length(yvect),length(xvect));

        %%% Resolution parameters
        % Number of events per grid node
        normlap2(ll)= mRcCross(:,13);
        mNumevents = reshape(normlap2,length(yvect),length(xvect));

        % Radii of chosen events, Resolution
        normlap2(ll)= mRcCross(:,14);
        vRadiusRes = reshape(normlap2,length(yvect),length(xvect));

        % Chosen fitting model
        normlap2(ll)= mRcCross(:,12);
        mMod = reshape(normlap2,length(yvect),length(xvect));

        try
            %%% p,c,k- values for period AFTER large aftershock
            % p-value
            normlap2(ll)= mRcCross(:,16);
            mPval2=reshape(normlap2,length(yvect),length(xvect));

            % p-value standard deviation
            normlap2(ll)= mRcCross(:,17);
            mPvalstd2 = reshape(normlap2,length(yvect),length(xvect));

            % c-value
            normlap2(ll)= mRcCross(:,18);
            mCval2 = reshape(normlap2,length(yvect),length(xvect));

            % c-value standard deviation
            normlap2(ll)= mRcCross(:,19);
            mCvalstd2 = reshape(normlap2,length(yvect),length(xvect));

            % k-value
            normlap2(ll)= mRcCross(:,20);
            mKval2 = reshape(normlap2,length(yvect),length(xvect));

            % k-value standard deviation
            normlap2(ll)= mRcCross(:,21);
            mKvalstd2 = reshape(normlap2,length(yvect),length(xvect));

            % KS-Test (H-value) binary rejection criterion at 95% confidence level
            normlap2(ll)= mRcCross(:,22);
            mKstestH = reshape(normlap2,length(yvect),length(xvect));

            %  KS-Test statistic for goodness of fit
            normlap2(ll)= mRcCross(:,23);
            mKsstat = reshape(normlap2,length(yvect),length(xvect));

            %  KS-Test p-value
            normlap2(ll)= mRcCross(:,24);
            mKsp = reshape(normlap2,length(yvect),length(xvect));

            % RMS value for goodness of fit
            normlap2(ll)= mRcCross(:,25);
            mRMS = reshape(normlap2,length(yvect),length(xvect));
        catch
            disp('Values not calculated')
        end

        % Initial map set to relative rate change
        re3 = mRelchange;
        lab1 = 'Rate change';
        nlammap
        [xsecx xsecy,  inde] =mysect(a(:,2)',a(:,1)',a(:,7),wi,0,lat1,lon1,lat2,lon2);
        % Plot all grid points
        hold on

        old = re3;
        % Plot
        view_rccross_a2;
    else
        return
    end
end
