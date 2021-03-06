function actrange(range) 
    % activate range editor in fractal dimension parameters input window
    % This code is responsable for the activation (enable, on) of the range editor in the
    % fractal dimension parameter input window. It is called from fdparain.m,
    % dcparain.m,
    % Francesco Pacchiani 1/2000
    %
    % turned into function by Celso G Reyes 2017
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    if range == 2
        myenable = 'on';
        mycolor = 'k';
    else
        myenable = 'off';
        mycolor = 'w';
        radm = [];
        rasm = [];
        
    end
    set([tx2, tx3, tx4, tx5], 'color', mycolor);
    set([input2,input3], 'enable', myenable);
    
    
end

