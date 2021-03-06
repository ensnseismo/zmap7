function prepinp() 
    % collect res
    
    global pgdem % gtopo30 DEM directory
    global pgt30
    global psloc
    
    pgdem = fullfile(hodi, 'dem', 'globedem');
    pgt30 = fullfile(hodi, 'dem', 'gtopo30');
    psloc = [hodi];
    
    import zmaptopo.*
    
    ZG=ZmapGlobal.Data; % used by get_zmap_globals
    clear resu
    ind=1;
    if exist('bls','var')
        resu(ind).data=bls;
        resu(ind).name='b-value map (WLS)';
        resu(ind).lab='b-value';
        ind=ind+1;
    end
    
    if exist('bml','var')
        resu(ind).data=bml;
        resu(ind).name='b(max likelihood) map';
        resu(ind).lab='b-value';
        ind=ind+1;
    end
    
    if exist('oldl','var')
        resu(ind).data=oldl;
        resu(ind).name='Magnitude of completness map';
        resu(ind).lab='Mcomp';
        ind=ind+1;
    end
    
    if exist('Prmap','var')
        resu(ind).data=Prmap;
        resu(ind).name='Goodness of fit to power law map';
        resu(ind).lab='%';
        ind=ind+1;
    end
    
    if exist('valueMap','var')
        resu(ind).data=valueMap;
        resu(ind).name='last valueMap';
        resu(ind).lab='  ';
        ind=ind+1;
    end
    
    
    %frame=[s2_west s1_east s4_south s3_north];
    figure(map);
    frame=[get(gca,'XLim') get(gca,'Ylim')];
    
    
    s=1
    if ind==1
        resu=1
        gx=1
        gy=1
        s=2
    end
    
    cd(psloc)
    topo(frame,a,faults,coastline,resu,gx,gy,s);
    
end
