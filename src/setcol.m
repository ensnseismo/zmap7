function setcol()
    % This is the machine-generated representation of a MATLAB object
    % and its children.  Note that handle values may change when these
    % objects are re-created. This may cause problems with some callbacks.
    % The command syntax may be supported in the future, but is currently
    % incomplete and subject to change.
    %
    % To re-open this system, just type the name of the m-file at the MATLAB
    % prompt. The M-file and its associtated MAT-file must be on your path.

    report_this_filefun(mfilename('fullpath'));

    load setcol

    a = figure_w_normalized_uicontrolunits('Color',[0.9 0.9 0.9], ...
        'Colormap',mat0, ...
        'InvertHardcopy','off', ...
        'PointerShapeCData',mat1, ...
        'Position',[153 555 362 215], ...
        'Tag','Fig1');
    b = uicontrol('Parent',a, ...
        'Units','points', ...
        'Callback','C = uisetcolor;cb1 = C(1);cb2=C(2);cb3=C(3);close;subcata', ...
        'Position',[53.3793 70.1379 108 21.7241], ...
        'String','Graph Background', ...
        'Tag','Pushbutton1');
    b = uicontrol('Parent',a, ...
        'Units','points', ...
        'Callback','C = uisetcolor;c1 = C(1);c2=C(2);c3=C(3);close;whitebg([c1 c2 c3]);subcata', ...
        'Position',[53.3793 35.3793 108 21.7241], ...
        'String','Figure Background', ...
        'Tag','Pushbutton1');
