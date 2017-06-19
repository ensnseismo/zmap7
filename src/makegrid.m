%
%   This .m file creates a rectangular grid and calculates the
%   cumulative number curve at each grid point. The grid is
%   saved in the file "cumugrid.mat".
%                        Operates on catalogue "a"
%
% define size of the area
%
% ________________________________________________________________________
%  Please use the left mouse button or the cursor to select the lower
%  left corner of the area of investigation. Please use the left
%  mouse again to select the upper right corner. The calculation might take
%  some time. This time can be reduced by using a smaller area and/or
%  a larger grid-spacing! The amount of calculation done will be displayed
%  in percent of the total time.
%
%_________________________________________________________________________

report_this_filefun(mfilename('fullpath'));

selgp

itotal = length(newgri(:,1));
if length(gx) < 2  ||  length(gy) < 2
    errordlg('Selection too small! (not a matrix)');
    return
end

try close(gpf); end
try close(gh); end

welcome(' ',' ');think
%  make grid, calculate start- endtime etc.  ...
%
t0b = a(1,3)  ;
n = length(a(:,1));
teb = a(n,3) ;
tdiff = round((teb - t0b)*365/par1);
cumu = zeros(length(t0b:par1/365:teb)+2);
ncu = length(cumu);
cumuall = zeros(ncu,length(newgri(:,1)));
loc = zeros(3,length(newgri(:,1)));

% loop over  all points
%
i2 = 0.;
i1 = 0.;
allcount = 0.;
%
% loop for all grid points
wai = waitbar(0,' Please Wait ...  ');
set(wai,'NumberTitle','off','Name','Makegrid - Percent completed');;
drawnow
cvg = [];

for i= 1:length(newgri(:,1))

    x = newgri(i,1);y = newgri(i,2);
    allcount = allcount + 1.;
    i2 = i2+1;
    % calculate distance from center point and sort wrt distance
    %
    l = sqrt(((a(:,1)-x)*cos(pi/180*y)*111).^2 + ((a(:,2)-y)*111).^2) ;
    [s,is] = sort(l);
    b = a(is(:,1),:) ;       % re-orders matrix to agree row-wise
    % take first ni points
    %
    b = b(1:ni,:);      % new data per grid point (b) is sorted in distance
    [st,ist] = sort(b);   % re-sort wrt time for cumulative count
    b = b(ist(:,3),:);
    cumu = cumu * 0;
    % time (bin) calculation
    n = length(b(:,1));
    cumu = histogram(b(1:n,3),t0b:par1/365:teb);
    cumu2 = cumsum(cumu);
    %calcsimp
    %cvg = [cvg ; cv rcv];
    % end

    l = sort(l);
    cumuall(:,allcount) = [cumu';  x; l(ni)];
    loc(:,allcount) = [x ; y; l(ni)];

    waitbar(allcount/itotal)

end  % for x0

%
% save data
%
%  set(txt1,'String', 'Saving data...')
close(wai)
drawnow
%save cumugrid.mat cumuall par1 ni dx dy gx gy tdiff t0b teb loc

catSave3 =...
    [ 'welcome(''Save Grid'',''  '');think;',...
    ' [file1,path1] = uiputfile(fullfile(hodi, ''eq_data'', ''*.mat''), ''Grid Datafile'',400,400);',...
    ' sapa2 = [''save '' path1 file1 '' x y tmpgri newgri xvect yvect ll cumuall par1 ni dx dy gx gy tdiff t0b teb loc a main faults mainfault coastline''];',...
    ' if length(file1) > 1, eval(sapa2),end , done'];

eval(catSave3)

watchoff
zmapmenu
return

figure_w_normalized_uicontrolunits(mess)
clf
set(gca,'visible','off')

te = text(0.01,0.95,'The cumulative number array \newlinehas been saved in \newlinefile cumugrid.mat \newlinePlease rename it \newlineto protect if from overwriting.');
set(te,'FontSize',fontsz.m,'FontWeight','bold')

uicontrol('Units','normal','Position',...
    [.7 .10 .2 .12],'String','Options ', 'Callback','zmapmenu')

uicontrol('Units','normal','Position',...
    [.3 .10 .2 .12],'String','Back', 'Callback','welcome')

return

normlap2=ones(length(tmpgri(:,1)),1)*nan;
normlap2(ll)= cvg(:,1);
re3=reshape(normlap2,length(yvect),length(xvect));
Prmap = re3;
old1 = re3;
view_bva;


