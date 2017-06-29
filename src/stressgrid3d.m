% This subroutine assigns creates a 3D grid with
% spacing dx,dy, dz (in degreees). The size will
% be selected interactiVELY. The pvalue in each
% volume around a grid point containing ni earthquakes
% will be calculated as well as the magnitude
% of completness
%   Stefan Wiemer 1/98

report_this_filefun(mfilename('fullpath'));
global no1 bo1 inb1 inb2

if sel == 'i1'
    % make the interface
    %
    figure_w_normalized_uicontrolunits(...
        'Name','Grid Input Parameter',...
        'NumberTitle','off', ...
        'MenuBar','none', ...
        'units','points',...
        'Visible','on', ...
        'Position',[ wex+200 wey-200 550 300]);
    axis off
    R = 5; Nmin = 10;



    % creates a dialog box to input grid parameters
    %
    freq_field=uicontrol('Style','edit',...
        'Position',[.30 .50 .12 .10],...
        'Units','normalized','String',num2str(ni),...
        'Callback','ni=str2double(get(freq_field,''String'')); set(freq_field,''String'',num2str(ni));set(tgl2,''value'',0); set(tgl1,''value'',1)');


    freq_field0=uicontrol('Style','edit',...
        'Position',[.70 .50 .12 .10],...
        'Units','normalized','String',num2str(R),...
        'Callback','R=str2double(get(freq_field0,''String'')); set(freq_field0,''String'',num2str(R)) ; set(tgl2,''value'',1); set(tgl1,''value'',0)');


    tgl1 = uicontrol('Style','checkbox',...
        'string','Number of Events:',...
        'Position',[.05 .50 .2 .10], 'Callback','set(tgl2,''value'',0)',...
        'Units','normalized');

    set(tgl1,'value',1);

    tgl2 =  uicontrol('Style','checkbox',...
        'string','OR: Constant Radius',...
        'Position',[.47 .50 .2 .10], 'Callback','set(tgl1,''value'',0)',...
        'Units','normalized');


    freq_field4 = uicontrol('Style','edit',...
        'Position',[.30 .20 .12 .10],...
        'Units','normalized','String',num2str(Nmin),...
        'Callback','Nmin=str2double(get(freq_field4,''String'')); set(freq_field4,''String'',num2str(Nmin));');

    close_button=uicontrol('Style','Pushbutton',...
        'Position',[.50 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Cancel');

    help_button=uicontrol('Style','Pushbutton',...
        'Position',[.70 .05 .15 .12 ],...
        'Units','normalized','Callback','close;done','String','Help');


    go_button1=uicontrol('Style','Pushbutton',...
        'Position',[.20 .05 .15 .12 ],...
        'Units','normalized',...
        'Callback','tgl1 =get(tgl1,''Value'');tgl2 =get(tgl2,''Value'');close,sel =''in'', stressgrid3d',...
        'String','Go');



    txt3 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[0.30 0.67 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.l ,...
        'FontWeight','bold',...
        'String',' Grid Parameter');

    txt1 = text(...
        'Color',[0 0 0 ],...
        'EraseMode','normal',...
        'Position',[-0.1 0.2 0 ],...
        'Rotation',0 ,...
        'FontSize',fontsz.m,...
        'FontWeight','bold',...
        'String','Min No. of events:');

end  % if sel = i1
if sel == 'in'
    % get the grid parameter
    % initial values
    %
    dx = 0.1;
    dy = 0.1 ;
    dz = 5.00 ;

    def = {'0.1','0.1',num2str(dz),num2str(max(a.Depth)), num2str(min(a.Depth))};

    tit ='Three dimesional b-value analysis';
    prompt={ 'Spacing in Longitude (dx in [deg])',...
        'Spacing in Latitude  (dy in [deg])',...
        'Spacing in Depth    (dz in [km ])',...
        'Depth Range: deep limit [km] ',...
        'Depth Range: shallow limit',...
        };


    ni2 = inputdlg(prompt,tit,1,def);

    l = ni2{1}; dx= str2double(l);
    l = ni2{2}; dy= str2double(l);
    l = ni2{3}; dz= str2double(l);
    l = ni2{4}; z1= str2double(l);
    l = ni2{5}; z2= str2double(l);


    sel = 'ca'; stressgrid3d


end   % if sel == 'in'

% get the grid-size interactively and
% calculate the b-value in the grid by sorting
% thge seimicity and selectiong the ni neighbors
% to each grid point

if sel == 'ca'
    selgp3dB


    gz = zvect;
    itotal = length(t5);
    zmap_message_center.set_info(' ','Running... ');think
    %  make grid, calculate start- endtime etc.  ...
    %
    bvg = ones(length(t5),8)*nan;

    t0b = min(a.Date)  ;
    n = a.Count;
    teb = a(n,3) ;
    tdiff = round((teb - t0b)*365/par1);
    loc = zeros(3, length(gx)*length(gy));
    Rconst = R;
    % loop over  all points
    %
    i2 = 0.;
    i1 = 0.;
    allcount = 0.;
    wai = waitbar(0,' Please Wait ...  ');
    set(wai,'NumberTitle','off','Name',' 3D gridding - percent done');;
    drawnow
    %
    %

    hodis = fullfile(hodi, 'external');
    do = ['cd  ' hodis ]; eval(do)
    z0 = 0; x0 = 0; y0 = 0; dt = 1;
    % loop over all points
    b = [];

    for il =1:length(t5);

        x = t5(il,1);
        y = t5(il,2);
        z = t5(il,3);

        allcount = allcount + 1.;

        % calculate distance from center point and sort wrt distance
        l = sqrt(((a.Longitude-x)*cos(pi/180*y)*111).^2 + ((a.Latitude-y)*111).^2 + ((a.Depth - z)).^2 ) ;
        [s,is] = sort(l);
        b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise

        if tgl1 == 0   % take point within r
            l3 = l <= R;
            b = a.subset(l3);      % new data per grid point (b) is sorted in distanc
            rd = length(b(:,1));
        else
            % take first ni points
            b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
            l2 = sort(l); rd = l2(ni);

        end

        if length(b(:,1)) > Nmin
            %estimate the completeness and b-value
            newt2 = b;

            tmpi = [newt2(:,10:12)];
            %[bv magco stan av me mer me2,  pr] =  bvalca3(b,1,1);

            fid = fopen('data2','w');
            str = ['Inversion data'];str = str';

            fprintf(fid,'%s  \n',str');
            fprintf(fid,'%7.3f  %7.3f  %7.3f\n',tmpi');

            fclose(fid);

            delete data2.slboot Xtemp.slboot

            try
                unix(['.' fs 'slfast data2 ']);
                load data2.slboot
                d0 = data2;
            catch
                d0 = [NaN NaN NaN NaN NaN NaN NaN  ; NaN NaN NaN NaN NaN NaN NaN  ];
            end

            bvg(allcount,:) = [d0(2,2:7) d0(1,1) rd ];

        else
            bvg(allcount,:) = [NaN NaN NaN NaN NaN NaN NaN NaN ];
        end

        waitbar(allcount/itotal)
    end  % for t5

    % save data
    %


    close(wai)
    watchoff




end  % if cal

