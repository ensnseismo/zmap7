% this is zdataimport

ver = version;
ver = str2double(ver(1));

% check if Matlab 6+
if ver < 6
    helpdlg('Sorry - these import filters only work for Matlab version 6.0 and higher','Sorry');
    return
end

% start filters

[a] = import_start([ hodi fs 'importfilters']);
if isnan(a)
    % import cancelled / failed
    return
end
disp(['Catalog loaded with ' num2str(length(a(:,1))) ' events ']);
% Sort the catalog in time just to make sure ...
[s,is] = sort(a(:,3));
a = a(is(:,1),:) ;
minmag = max(a(:,6))-0.2;       %  as a default to be changed by inpu

% call the setup
inpu
