% Script: cross_stress.m
%
% Script creates a grid with % spacing dx,dy (in degreees). The size will
% be selected interactively or on the entire region.
%
% Parameters to be calculated:
% fTS1     : Trend of Maximum compressive principal stress axis
% fPS1     : Plunge of the Maximum compressive principal stress axis
% fTS2     : Trend of Intermediate compressive principal stress axis
% fPS2     : Plunge of the Intermediate compressive principal stress axis
% fTS3     : Trend of Minimum compressive principal stress axis
% fPS3     : Plunge of the Minimum compressive principal stress axis
% fPhi     : Relative magnitude of principal stresses
% fSigma   : Variance of stress tensor inversion
%
% last update: J. Woessner, 08.03.2004

report_this_filefun(mfilename('fullpath'));

global no1 bo1 inb1 inb2

if sel == 'in'
    % Get the grid parameter
    % Set initial values
    dd = 1.00;  % Depth spacing [km]
    dx = 1.00 ; % Horizontal spacing [km]
    ni = 50;   % Constant number of events
    Nmin = 30;  % Minimum number of events
    ra = 3;     % Radius [km]
    fMaxRad = 3;  % Maximum radius [km] in case of constant number of events
    fStrike = 0;  % Strike of fault plane (0-179.9999)
    % Create interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'units','points',...
        'Visible','on', ...
        'Position',[ wex+200 wey-200 550 300]);
    axis off

    labelList2=[' Michaels method | sorry, no other option'];
    labelPos = [0.2 0.77  0.6  0.08];
    hndl2=uicontrol(...
        'Style','popup',...
        'Position',labelPos,...
        'Units','normalized',...
        'String',labelList2,...
        'Callback','inb2 =get(hndl2,''Value''); ');

    set(hndl2,'value',1);


    % Create a dialog box to input grid parameters
    %
    freq_field=uicontrol('Style','edit',...
        'Position',[.30 .58 .10 .08],...
        'Units','normalized','String',num2str(ni),...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));set(tgl2,''value'',0); set(tgl1,''value'',1)');


    freq_field0=uicontrol('Style','edit',...
        'Position',[.75 .58 .10 .08],...
        'Units','normalized','String',num2str(ra),...
        'Callback','ra=str2double(get(freq_field0,''String'')); set(freq_field0,''String'',num2str(ra)) ; set(tgl2,''value'',1); set(tgl1,''value'',0)');

    freq_field1=uicontrol('Style','edit',...
        'Position',[.75 .48 .10 .08],...
        'Units','normalized','String',num2str(Nmin),...
        'Callback','Nmin=str2double(get(freq_field1,''String''));set(freq_field1,''String'',num2str(Nmin));');

    freq_field2=uicontrol('Style','edit',...
        'Position',[.30 .48 .10 .08],...
        'Units','normalized','String',num2str(dx),...
        'Callback','dx=str2double(get(freq_field2,''String'')); set(freq_field2,''String'',num2str(dx));');

    freq_field3=uicontrol('Style','edit',...
        'Position',[.30 .38 .10 .08],...
        'Units','normalized','String',num2str(dd),...
        'Callback','dd=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(dd));');

    freq_field4=uicontrol('Style','edit',...
        'Position',[.75 .38 .10 .08],...
        'Units','normalized','String',num2str(fMaxRad),...
        'Callback','fMaxRad=str2double(get(freq_field1,''String''));set(freq_field1,''String'',num2str(fMaxRad));');

    freq_field5=uicontrol('Style','edit',...
        'Position',[.30 .28 .10 .08],...
        'Units','normalized','String',num2str(fStrike),...
        'Callback','fStrike=str2double(get(freq_field3,''String'')); set(freq_field3,''String'',num2str(fStrike));');

    % Checkbox for gridding entie area
    chkGridEntireArea = uicontrol('BackGroundColor', [0.8 0.8 0.8], ...
        'Style','checkbox',...
        'string','Create grid over entire area',...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'Position',[.05 .2 .32 .08], 'Units','normalized', 'Value', 0);

    load_grid =  uicontrol('BackGroundColor', [0.8 0.8 0.8],'Style','checkbox',...
        'string','Load grid and parameters file','Position',[.5 .28 .32 .080],...
        'Units','normalized','FontSize',fontsz.s,'FontWeight','bold');

    save_grid =  uicontrol('BackGroundColor', [0.8 0.8 0.8],'Style','checkbox',...
        'string','Save grid and parameters to file',...
        'Position',[.5 .2 .32 .080],...
        'Units','normalized','FontSize',fontsz.s,'FontWeight','bold');


    tgl1 = uicontrol('BackGroundColor', [0.8 0.8 0.8],'Style','checkbox',...
        'string','Number of Events:',...
        'Position',[.04 .58 .2 .08], 'Callback','set(tgl2,''value'',0)',...
        'Units','normalized','FontSize',fontsz.s,'FontWeight','bold');

    set(tgl1,'value',1);

    tgl2 =  uicontrol('BackGroundColor', [0.8 0.8 0.8],'Style','checkbox',...
        'string','OR: Constant Radius',...
        'Position',[.5 .58 .22 .08], 'Callback','set(tgl1,''value'',0)',...
        'Units','normalized','FontSize',fontsz.s,'FontWeight','bold');


    % Buttons
    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.50 .05 .15 .08 ],...
        'Units','normalized','Callback','close;done','String','Cancel');


    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .08 ],...
        'Units','normalized',...
        'Callback','inb1 =get(hndl2,''Value'');tgl1 =get(tgl1,''Value'');tgl2 =get(tgl2,''Value'');bGridEntireArea = get(chkGridEntireArea, ''Value''); save_grid = get(save_grid,''Value'');load_grid = get(load_grid,''Value'');close,sel =''ca'', cross_stress',...
        'String','Go');

    % Text fields
    text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.20 1.0 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.l ,...
        'FontWeight','bold',...
        'String','Choose stress tensor inversion method');

    txt1 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.5 0.5 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s,...
        'FontWeight','bold',...
        'String','Min No. of events');

    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.30 0.75 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String','Grid Parameter');

    txt4 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.5 0.4 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s,...
        'FontWeight','bold',...
        'String','Max. Radius');

    txt5 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.10 0.5 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String','Horizontal Spacing [km]');

    txt6 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.10 0.38 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String','Depth spacing [km]');

    txt7 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.10 0.26 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.s ,...
        'FontWeight','bold',...
        'String','Strike [deg]');

    if term == 1 ; whitebg(gcf,[1 1 1 ]);end
    set(gcf,'visible','on');
    watchoff

end   % if sel == in

% get the grid-size interactively and
% calculate the b-value in the grid by sorting
% thge seimicity and selectiong the ni neighbors
% to each grid point

if sel == 'ca'

    figure_w_normalized_uicontrolunits(xsec_fig)
    hold on
    if load_grid == 1
        [file1,path1] = uigetfile(['*.mat'],'previously saved grid');
        if length(path1) > 1
            think
            load([path1 file1])
            plot(newgri(:,1),newgri(:,2),'k+')
        end
    elseif (load_grid == 0  &&  bGridEntireArea) % Use entire area for grid
        vXLim = get(gca, 'XLim');
        vYLim = get(gca, 'YLim');
        x = [vXLim(1); vXLim(1); vXLim(2); vXLim(2)];
        y = [vYLim(2); vYLim(1); vYLim(1); vYLim(2)];
        x = [x ; x(1)];
        y = [y ; y(1)];     %  closes polygon
        clear vXLim vYLim;
    else % Interactive gridding
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

        hold on
        ax = findobj('Tag','main_map_ax');
        [x,y, mouse_points_overlay] = select_polygon(ax);
        welcome('Message',' Thank you .... ')
    end % of if bGridEntireArea

    % Plot outline if grid is interactively chosen or when gridding
    % entirely
    if load_grid ~= 1
        % Plot outline
        plos2 = plot(x,y,'b-','era','xor');
        pause(0.3)
        % Create a rectangular grid
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

        ll = polygon_filter(x,y, XI, YI, 'inside');
        %grid points in polygon
        newgri=tmpgri(ll,:);
    end % END of load_grid ~= 1

    % Plot all grid points
    plot(newgri(:,1),newgri(:,2),'+k','era','back')

    if length(xvect) < 2  ||  length(yvect) < 2
        errordlg('Selection too small! (not a matrix)');
        return
    end

    if save_grid == 1
        grid_save =...
            [ 'welcome(''Saving Grid'',''  '');think;',...
            '[file1,path1] = uiputfile([my_dir fs ''eq_data'' fs ''*.mat''], ''Grid File Name?'') ;',...
            ' gs = [''save '' path1 file1 '' newgri dx dy gx gy xvect yvect tmpgri ll dd dx ra ni Nmin fMaxRad tgl1 xsecx xsecy''];',...
            ' if length(file1) > 1, eval(gs),end , done']; eval(grid_save)
        %newgri dx dy xvect yvect tmpgri ll
    end

    % Total number of grid points (needed for waitbar)
    itotal = length(newgri(:,1));

    welcome(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    % loop over  all points
    %
    allcount = 0.;
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name','Percent done');;
    drawnow

    % create mResult
    mResult = zeros(length(newgri),15)*nan;

    % Path
    sPath = pwd;

    % Path to Stress Inversion program
    hodis = fullfile(hodi, 'external');
    do = ['cd  ' hodis ]; eval(do)


    for i= 1:length(newgri(:,1))
        x = newgri(i,1);y = newgri(i,2);
        allcount = allcount + 1.;

        % calculate distance from center point and sort wrt distance
        l = sqrt(((xsecx' - x)).^2 + ((xsecy + y)).^2) ;
        [s,is] = sort(l);
        b = newa(is(:,1),:) ;       % re-orders matrix to agree row-wise


        if tgl1 == 0   % take point within r
            l3 = l <= ra;
            b = newa(l3,:);      % new data per grid point (b) is sorted in distanc
            rd = ra;
        else  % Take first ni points
            % Set minimum number to constant number of events
            Nmin = ni;
            if length(b(:,1)) < ni
                b = b;
                rd = s(ni); % rd: Maximum distance [km]
            else
                b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
                rd = s(ni);
            end % Check on length of b
            % Check for maximum radius
            fMaxDist = s(ni);
            if fMaxDist > fMaxRad
                b = b(1:round(ni/2),:); % This reduces the number so that no computation occurs
            end
        end

        % New catalog to work on
        newt2 = b;

        % Number of events in catalog
        fNumEvents = length(b(:,1));

        % Check for minimum number of events
        if length(b) >= Nmin
            % Take the focal mechanism from actual catalog
            % tmpi-input: [dip direction (East of North), dip , rake (Kanamori)]
            tmpi = [newt2(:,10:12)];
            % Take the first thousand FMS (Restriction by slfast.c)
            if length(tmpi(:,1)) >=1000
                tmpi = tmpi(1:999,:);
            end
            % Create file for inversion
            fid = fopen('data2','w');
            str = ['Inversion data'];
            str = str';
            fprintf(fid,'%s  \n',str');
            fprintf(fid,'%7.3f  %7.3f  %7.3f\n',tmpi');
            fclose(fid);

            % slick calculates the best solution for the stress tensor according to
            % Michael(1987): creates data2.oput
            if strcmp(cputype,'GLNX86') == 1
                unix(['.' fs 'slick_linux data2 ']);
            elseif strcmp(cputype,'MAC') == 1
                unix(['.' fs 'slick_macppc data2 ']);
            elseif strcmp(cputype,'MACI') == 1
                unix(['.' fs 'slick_maci data2 ']);
            else
                dos(['.' fs 'slick.exe data2 ']);
            end
            %unix([hodi fs 'external/slick data2 ']);
            % Get data from data2.oput
            sFilename = ['data2.oput'];
            [fBeta, fStdBeta, fTauFit, fAvgTau, fStdTau] = import_slickoput(sFilename)

            % Delete existing data2.slboot
            sData2 = [hodi fs 'external/data2.slboot'];
            delete(sData2);

            % Stress tensor inversion
            if strcmp(cputype,'GLNX86') == 1
                unix([hodi fs 'external/slfast_linux data2 ']);
            elseif strcmp(cputype,'MAC') == 1
                unix([hodi fs 'external/slfast_macpcc data2 ']);
            elseif strcmp(cputype,'MACI') == 1
                unix([hodi fs 'external/slfast_maci data2 ']);
            else
                dos([hodi fs 'external/slfast.exe data2 ']);
            end
            %unix([hodi fs 'external/slfast data2 ']);
            sGetFile = [hodi fs 'external/data2.slboot'];
            load(sGetFile)
            d0 = data2;

            % Result matrix containing
            % Phi fTS1 fPS1 fTS2 fPS2 fTS3 fPS3 Variance Resolution
            % Number of events
            mResult(allcount,:) = [d0(2,1:7) d0(1,1) rd fNumEvents fBeta fStdBeta fAvgTau fStdTau fTauFit];
        else
            mResult(allcount,:) = [NaN NaN NaN NaN NaN NaN NaN NaN NaN fNumEvents NaN NaN NaN NaN NaN];
        end % if Nmin
        waitbar(allcount/itotal)
    end  % for  newgri
    close(wai);
    watchoff
    % Back to original directory
    do = ['cd  ' sPath ]; eval(do)
    % Compute equivalent angles for fTS1 relative to strike
    [vTS1Rel] = calc_Rel2Strike(fStrike,mResult(:,2));

    % Compute equivalent angles for fTS1 relative to north
    vSel = mResult(:,2) < 0;
    mResult(vSel,2) = mResult(vSel,2)+180;


    % Add vTS1Rel to mResult
    mResult = [mResult vTS1Rel];

    % save data
    save Result_Crossstress.mat mResult gx gy dx dy fMaxRad a newa main faults mainfault coastline yvect xvect tmpgri ll newgri ra Nmin dd dx ni maepi xsecx xsecy tgl1
    %
    drawnow
    gx = xvect;gy = yvect;

    % Create output matrix to view results
    normlap2=ones(length(tmpgri(:,1)),1)*nan;

    % Martix Phi
    normlap2(ll)= mResult(:,1);
    mPhi=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S1
    normlap2(ll)= mResult(:,2);
    mTS1=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S1
    normlap2(ll) = mResult(:,3);
    mPS1 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S2
    normlap2(ll)= mResult(:,4);
    mTS2=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S2
    normlap2(ll) = mResult(:,5);
    mPS2 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S3
    normlap2(ll)= mResult(:,6);
    mTS3=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S3
    normlap2(ll) = mResult(:,7);
    mPS3 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Variance
    normlap2(ll)= mResult(:,8);
    mVariance=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Resolution: km
    normlap2(ll)= mResult(:,9);
    mResolution=reshape(normlap2,length(yvect),length(xvect));
    % Matrix ResolutionL Number of Events
    normlap2(ll)= mResult(:,10);
    mNumber=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Beta
    normlap2(ll)= mResult(:,11);
    mBeta=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Beta standard deviation
    normlap2(ll)= mResult(:,12);
    mBetaStd=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau
    normlap2(ll)= mResult(:,13);
    mTau=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau Standard deviation
    normlap2(ll)= mResult(:,14);
    mTauStd=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau Ratio
    normlap2(ll)= mResult(:,15);
    mTauRatio=reshape(normlap2,length(yvect),length(xvect));
    % Matrix S1 relative to strike
    normlap2(ll) = mResult(:,16);
    mTS1Rel = reshape(normlap2,length(yvect),length(xvect));

    lab1 = 'Trend S1';
    re3 = mTS1;
    old1 = re3;

    % View results
    view_xstress
end % End sel == 'ca'

if sel == 'lo'
    [file1,path1] = uigetfile(['*.mat'],'Load grid and result file');
    if length(path1) > 1
        think
        load([path1 file1])
    end
    % Create output matrix to view results
    normlap2=ones(length(tmpgri(:,1)),1)*nan;

    % Martix Phi
    normlap2(ll)= mResult(:,1);
    mPhi=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S1
    normlap2(ll)= mResult(:,2);
    mTS1=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S1
    normlap2(ll) = mResult(:,3);
    mPS1 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S2
    normlap2(ll)= mResult(:,4);
    mTS2=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S2
    normlap2(ll) = mResult(:,5);
    mPS2 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Trend S3
    normlap2(ll)= mResult(:,6);
    mTS3=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Plunge S3
    normlap2(ll) = mResult(:,7);
    mPS3 = reshape(normlap2,length(yvect),length(xvect));
    % Matrix Variance
    normlap2(ll)= mResult(:,8);
    mVariance=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Resolution: km
    normlap2(ll)= mResult(:,9);
    mResolution=reshape(normlap2,length(yvect),length(xvect));
    % Matrix ResolutionL Number of Events
    normlap2(ll)= mResult(:,10);
    mNumber=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Beta
    normlap2(ll)= mResult(:,11);
    mBeta=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Beta standard deviation
    normlap2(ll)= mResult(:,12);
    mBetaStd=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau
    normlap2(ll)= mResult(:,13);
    mTau=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau Standard deviation
    normlap2(ll)= mResult(:,14);
    mTauStd=reshape(normlap2,length(yvect),length(xvect));
    % Matrix Tau Ratio
    normlap2(ll)= mResult(:,15);
    mTauRatio=reshape(normlap2,length(yvect),length(xvect));
    try
        % Matrix S1 relative to strike
        normlap2(ll) = mResult(:,16);
        mTS1Rel = reshape(normlap2,length(yvect),length(xvect));
        lab1 = 'S1 trend [deg]';
        re3 = mTS1;
        old1 = re3;
    catch
    end
    % View results
    view_xstress
end % sel == 'lo'