% Script: calc_Omoricross.m
%
% Calculate Omori parameters on cross section using different choices for Mc
% Data is displayed with view_Omoricross.m
%
% J. Woessner
% last update: 20.10.04

report_this_filefun(mfilename('fullpath'));

global no1 bo1 inb1

% Do we have to create the dialogbox?
if sel == 'in'
    % Set the grid parameter
    % initial values
    %
    inb2 = 1;
    dd = 1.00; % Depth spacing in km
    dx = 1.00 ; % X-Spacing in km
    ni = 100;   % Number of events
    bv2 = NaN;
    Nmin = 50;  % Minimum number of events
    bGridEntireArea = 0;
    time = 100;
    timef= 0; % No forecast done, but needed for functions
    bootloops = 50;
    ra = 5;
    fMaxRadius = 5;
    fBinning = 0.1;

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

    % Dropdown list
    labelList2=[' Fixed Mc (Mc = Mmin) | Automatic Mc (max curvature) | EMR-method'];
    hndl2=uicontrol(...
        'Style','popup',...
        'Units','normalized','Position',[ 0.2 0.8  0.6  0.08],...
        ...
        'String',labelList2,...
        'BackgroundColor','w',...
        'Callback','inb2 =get(hndl2,''Value''); ');

    % Set selection to 'Fix Mc'
    set(hndl2,'value',1);

    % Edit fields, radiobuttons, and checkbox
    freq_field=uicontrol('Style','edit',...
        'Units','normalized','Position',[.30 .70 .12 .08],...
        'String',num2str(ni),...
        'FontSize',fontsz.m ,...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));set(tgl2,''value'',0); set(tgl1,''value'',1)');

    freq_field0=uicontrol('Style','edit',...
        'Units','normalized','Position',[.30 .60 .12 .08],...
        'String',num2str(ra),...
        'FontSize',fontsz.m ,...
        'Callback','ra=str2double(get(freq_field0,''String'')); set(freq_field0,''String'',num2str(ra)) ; set(tgl2,''value'',1); set(tgl1,''value'',0)');

    freq_field2=uicontrol('Style','edit',...
        'Units','normalized','Position',[.30 .40 .12 .08],...
        'String',num2str(dx),...
        'FontSize',fontsz.m ,...
        'Callback','dx=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(dx));');

    freq_field3=uicontrol('Style','edit',...
        'Units','normalized','Position',[.30 .30 .12 .08],...
        'String',num2str(dd),...
        'FontSize',fontsz.m ,...
        'Callback','dd=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(dd));');

    freq_field7=uicontrol('Style','edit',...
        'Units','normalized','Position',[.68 .40 .12 .080],...
        'String',num2str(time),...
        'Callback','time=str2double(get(freq_field7,''String'')); set(freq_field7,''String'',num2str(time));');

    %     freq_field5=uicontrol('Style','edit',...
    %        'Units','normalized','Position',[.68 .50 .12 .080],...
    %         'String',num2str(timef),...
    %         'Callback','timef=str2double(get(freq_field5,''String'')); set(freq_field5,''String'',num2str(timef));');

    freq_field6=uicontrol('Style','edit',...
        'Units','normalized','Position',[.68 .60 .12 .080],...
        'String',num2str(bootloops),...
        'Callback','bootloops=str2double(get(freq_field6,''String'')); set(freq_field6,''String'',num2str(bootloops));');

    freq_field8=uicontrol('Style','edit',...
        'Units','normalized','Position',[.68 .70 .12 .080],...
        'String',num2str(fMaxRadius),...
        'Callback','fMaxRadius=str2double(get(freq_field8,''String'')); set(freq_field8,''String'',num2str(fMaxRadius));');

    tgl1 = uicontrol('BackGroundColor', [0.8 0.8 0.8], ...
        'Style','radiobutton',...
        'string','Number of events:',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Units','normalized','Position',[.02 .70 .28 .08], 'Callback','set(tgl2,''value'',0)');

    % Set to constant number of events
    set(tgl1,'value',1);

    tgl2 =  uicontrol('BackGroundColor',[0.8 0.8 0.8],'Style','radiobutton',...
        'string','Constant radius [km]:',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Units','normalized','Position',[.02 .60 .28 .08], 'Callback','set(tgl1,''value'',0)');

    freq_field4 =  uicontrol('Style','edit',...
        'Units','normalized','Position',[.30 .20 .12 .08],...
        'String',num2str(Nmin),...
        'FontSize',fontsz.m ,...
        'Callback','Nmin=str2double(get(freq_field4,''String'')); set(freq_field4,''String'',num2str(Nmin));');

    chkGridEntireArea = uicontrol('BackGroundColor', [0.8 0.8 0.8], ...
        'Style','checkbox',...
        'string','Create grid over entire area',...
        'FontSize',fontsz.m ,...
        'FontWeight','bold',...
        'Units','normalized','Position',[.02 .06 .40 .08], 'Units','normalized', 'Value', 0);

    % Buttons
    uicontrol('BackGroundColor', [0.8 0.8 0.8], 'Style', 'pushbutton', ...
        'Units', 'normalized','Position', [.80 .05 .15 .12], ...
        'Callback', 'close;done', 'String', 'Cancel');

    uicontrol('BackGroundColor', [0.8 0.8 0.8], 'Style', 'pushbutton', ...
        'Units', 'normalized','Position', [.60 .05 .15 .12], ...
        'Callback', 'tgl1 =get(tgl1,''Value'');tgl2 =get(tgl2,''Value''); bGridEntireArea = get(chkGridEntireArea, ''Value'');close,sel =''ca'', calc_Omoricross',...
        'String', 'OK');

    % Labels
    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [0.2 1 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
        'FontSize', fontsz.l, 'FontWeight', 'bold', 'String', 'Please select a Mc estimation option');

    %     text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
    %         'Position', [0.3 0.95 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
    %         'FontSize', fontsz.l, 'FontWeight', 'bold', 'String', 'Grid parameters');

    text('Color',[0 0 0], 'EraseMode','normal', 'Units', 'normalized', ...
        'Position', [-.14 .42 0], 'HorizontalAlignment', 'left', 'Rotation', 0, ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String','Horizontal spacing [km]:');

    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [-0.14 0.30 0], 'Rotation', 0, 'HorizontalAlignment', 'left', ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String', 'Depth spacing [km]:');

    text('Color', [0 0 0], 'EraseMode', 'normal', 'Units', 'normalized', ...
        'Position', [-0.14 0.18 0], 'Rotation', 0, 'HorizontalAlignment', 'left', ...
        'FontSize',fontsz.m, 'FontWeight', 'bold', 'String', 'Min. number of events:');

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


    %create a rectangular grid
    xvect=[min(x):dx:max(x)];
    yvect=[min(y):dd:max(y)];
    gx = xvect;
    gy = yvect;
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
    %grid points in polygon
    ll = polygon_filter(x,y,XI,YI,'inside');
    newgri=tmpgri(ll,:);

    % Plot all grid points
    plot(newgri(:,1),newgri(:,2),'+k')

    % Set itotal for waitbar
    itotal = length(newgri(:,1));

    welcome(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    t0b = newa(1,3)  ;
    n = length(newa(:,1));
    teb = newa(n,3) ;
    tdiff = round((teb - t0b)*365/par1);

    % loop over  all points
    mCross = [];%NaN(length(newgri),20);
    allcount = 0.;
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name','Omori grid - percent done');;
    drawnow

    if inb2 == 1
        def = {'1.5'};
        lines = 1;
        title = ['Fixed Mc input'];
        prompt = {'Enter Mc: '};
        answer  = inputdlg(prompt,title,lines,def);
        fMcFix = str2double(answer{1});
    end

    % Loop over grid nodes
    for i= 1:length(newgri(:,1))
        % Grid coordinates
        x = newgri(i,1);
        y = newgri(i,2);
        allcount = allcount + 1.;


        % Select subcatalog
        % Calculate distance from center point and sort with distance
        l = sqrt(((xsecx' - x)).^2 + ((xsecy + y)).^2) ;
        [s,is] = sort(l);
        b = newa(is(:,1),:) ;
        vDist = l(is(:,1),:);

        % Cut to time period
        vSel =  b(:,3)<= maepi(1,3)+time/365;
        b = b(vSel,:);
        vDist = vDist(vSel,:);

        if inb2 == 1
            fMc = fMcFix;
        elseif inb2 == 2 %Maximum curvature
            nMethod = 1;
        else % inb2 == 3 % EMR method
            nMethod = 6;
        end % END if inb2

        % Choose between constant radius or constant number of events with maximum radius
        if tgl1 == 0   % take point within r
            % Use Radius to determine grid node catalog
            l3 = vDist <= ra;
            b = b(l3,:);
            vDist = vDist(l3,:);
            % Check for global Mc or individual, cut catalog at Mc
            if inb2 ~= 1
                try
                    [fMc] = calc_Mc(b, nMethod, fBinning);
                catch
                    fMc = NaN;
                end
            end
            vSel = b(:,6) >= fMc;
            b = b(vSel,:);
            vDist = vDist(vSel,:);
            % Maximum Distance
            fMaxDist = max(vDist);
        else
            % Determine ni number of events in learning period
            % Set minimum number to constant number
            Nmin = ni;
            % Select constant number
            b = b(1:ni,:);
            % Maximum distance of events in learning period
            fMaxDist = vDist(ni);
            % Check for maximum distance
            if fMaxDist > fMaxRadius
                vSel4 = (vDist(1:length(b(:,1)),:) < fMaxRadius);
                b = b(vSel4,:);
            end
        end % End If on tgl1

        %Set catalog after selection
        newt2 = b;
        % Number of events per gridnode
        [nY,nX]=size(b);


        % Calculate the relative rate change, p, c, k, resolution
        if length(b) >= Nmin  % enough events?
            nMod = 1; % Single Omori law
            [mResult] = calc_Omoriparams(b,time,timef,bootloops,maepi,nMod);

            % Result matrix
            mCross = [mCross; mResult.pval1 mResult.pmeanStd1 mResult.cval1 mResult.cmeanStd1...
                mResult.kval1 mResult.kmeanStd1 mResult.nMod nY fMaxDist...
                mResult.pval2 mResult.pmeanStd2 mResult.cval2 mResult.cmeanStd2 mResult.kval2 mResult.kmeanStd2 mResult.H...
                mResult.KSSTAT mResult.P mResult.fRMS fMc];
        else
            if isempty(fMaxDist)
                fMaxDist = NaN;
            end
            mCross = [mCross; NaN NaN NaN NaN NaN NaN NaN nY fMaxDist NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN fMc];
        end
        waitbar(allcount/itotal)
    end  % for newgr

    drawnow
    gx = xvect;
    gy = yvect;

    % Save the data to rcval_grid.mat
    %save Omoricross.mat mCross gx gy dx dy par1 tdiff t0b teb newa a main faults mainfault coastline yvect xvect tmpgri ll bo1 newgri ra time timef bootloops maepi xsecx xsecy wi lon1 lat1 lon2 lat2
    %disp('Saving data to Omoricross.mat in current directory')
    catSave3 =...
        [ 'welcome(''Save Grid'',''  '');think;',...
        '[file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Grid Datafile Name?'') ;',...
        ' sapa2 = [''save '' path1 file1 '' mCross gx gy dx dy par1 tdiff t0b teb newa a main faults mainfault coastline yvect xvect tmpgri ll bo1 newgri ra time timef bootloops maepi xsecx xsecy wi lon1 lat1 lon2 lat2 ''];',...
        ' if length(file1) > 1, eval(sapa2),end , done']; eval(catSave3)

    close(wai)
    watchoff

    % Prepare plotting
    normlap2=NaN(length(tmpgri(:,1)),1);

    %%% p,c,k- values for period before large aftershock or just modified Omori law
    % p-value
    normlap2(ll)= mCross(:,1);
    mPval=reshape(normlap2,length(yvect),length(xvect));

    % p-value standard deviation
    normlap2(ll)= mCross(:,2);
    mPvalstd = reshape(normlap2,length(yvect),length(xvect));

    % c-value
    normlap2(ll)= mCross(:,3);
    mCval = reshape(normlap2,length(yvect),length(xvect));

    % c-value standard deviation
    normlap2(ll)= mCross(:,4);
    mCvalstd = reshape(normlap2,length(yvect),length(xvect));

    % k-value
    normlap2(ll)= mCross(:,5);
    mKval = reshape(normlap2,length(yvect),length(xvect));

    % k-value standard deviation
    normlap2(ll)= mCross(:,6);
    mKvalstd = reshape(normlap2,length(yvect),length(xvect));

    %%% Resolution parameters
    % Number of events per grid node
    normlap2(ll)= mCross(:,8);
    mNumevents = reshape(normlap2,length(yvect),length(xvect));

    % Radii of chosen events, Resolution
    normlap2(ll)= mCross(:,9);
    vRadiusRes = reshape(normlap2,length(yvect),length(xvect));

    % Chosen fitting model
    normlap2(ll)= mCross(:,7);
    mMod = reshape(normlap2,length(yvect),length(xvect));


    % KS-Test (H-value) binary rejection criterion at 95% confidence level
    normlap2(ll)= mCross(:,16);
    mKstestH = reshape(normlap2,length(yvect),length(xvect));

    %  KS-Test statistic for goodness of fit
    normlap2(ll)= mCross(:,17);
    mKsstat = reshape(normlap2,length(yvect),length(xvect));

    %  KS-Test p-value
    normlap2(ll)= mCross(:,18);
    mKsp = reshape(normlap2,length(yvect),length(xvect));

    % RMS value for goodness of fit
    normlap2(ll)= mCross(:,19);
    mRMS = reshape(normlap2,length(yvect),length(xvect));

    % Mc value
    normlap2(ll)= mCross(:,20);
    mMc = reshape(normlap2,length(yvect),length(xvect));

    % Data to plot first map
    re3 = mPval;
    lab1 = 'p-value';

    % View the map
    view_Omoricross

end   % if sel = ca

% Load existing cross section
if sel == 'lo'
    [file1,path1] = uigetfile(['*.mat'],'Omori parameter cross section');
    if length(path1) > 1
        think
        load([path1 file1])

        normlap2=NaN(length(tmpgri(:,1)),1);
        %%% p,c,k- values for period before large aftershock or just modified Omori law
        % p-value
        normlap2(ll)= mCross(:,1);
        mPval=reshape(normlap2,length(yvect),length(xvect));

        % p-value standard deviation
        normlap2(ll)= mCross(:,2);
        mPvalstd = reshape(normlap2,length(yvect),length(xvect));

        % c-value
        normlap2(ll)= mCross(:,3);
        mCval = reshape(normlap2,length(yvect),length(xvect));

        % c-value standard deviation
        normlap2(ll)= mCross(:,4);
        mCvalstd = reshape(normlap2,length(yvect),length(xvect));

        % k-value
        normlap2(ll)= mCross(:,5);
        mKval = reshape(normlap2,length(yvect),length(xvect));

        % k-value standard deviation
        normlap2(ll)= mCross(:,6);
        mKvalstd = reshape(normlap2,length(yvect),length(xvect));

        %%% Resolution parameters
        % Number of events per grid node
        normlap2(ll)= mCross(:,8);
        mNumevents = reshape(normlap2,length(yvect),length(xvect));

        % Radii of chosen events, Resolution
        normlap2(ll)= mCross(:,9);
        vRadiusRes = reshape(normlap2,length(yvect),length(xvect));

        % Chosen fitting model
        normlap2(ll)= mCross(:,7);
        mMod = reshape(normlap2,length(yvect),length(xvect));


        % KS-Test (H-value) binary rejection criterion at 95% confidence level
        normlap2(ll)= mCross(:,16);
        mKstestH = reshape(normlap2,length(yvect),length(xvect));

        %  KS-Test statistic for goodness of fit
        normlap2(ll)= mCross(:,17);
        mKsstat = reshape(normlap2,length(yvect),length(xvect));

        %  KS-Test p-value
        normlap2(ll)= mCross(:,18);
        mKsp = reshape(normlap2,length(yvect),length(xvect));

        % RMS value for goodness of fit
        normlap2(ll)= mCross(:,19);
        mRMS = reshape(normlap2,length(yvect),length(xvect));

        % Mc value
        normlap2(ll)= mCross(:,20);
        mMc = reshape(normlap2,length(yvect),length(xvect));
        % Initial map set to relative rate change
        re3 = mPval;
        lab1 = 'p-value';
        nlammap
        [xsecx, xsecy inde] =mysect(a(:,2)',a(:,1)',a(:,7),wi,0,lat1,lon1,lat2,lon2);
        % Plot all grid points
        hold on

        old = re3;
        % Plot
        view_Omoricross;
    else
        return
    end
end
