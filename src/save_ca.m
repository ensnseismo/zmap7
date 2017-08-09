report_this_filefun(mfilename('fullpath'));

str = [];
[newmatfile, newpath] = uiputfile([ ZmapGlobal.Data.out_dir '*.dat'], 'Save As');  %Syntax change in the Matlab Version 7, window positiobibg does not functioning on a mac

s = [ZG.a.Longitude   ZG.a.Latitude  ZG.a.Date.Year  ZG.a.Date.Month  ZG.a.Date.Day  ZG.a.Magnitude  ZG.a.Depth ZG.a.Date.Hour ZG.a.Date.Minute  ];
fid = fopen([newpath newmatfile],'w') ;
fprintf(fid,'%8.3f   %7.3f %4.0f %6.0f  %6.0f %6.1f %6.2f  %6.0f  %6.0f\n',s');
fclose(fid);
clear s
return
