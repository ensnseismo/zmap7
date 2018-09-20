% add relevant paths
hodi = fileparts(which('zmap'));
path_list = [
    {hodi};
    fullfile(hodi, {'src';
    'help';
    'zmapwww';
    'importfilters';
    'resrc';
    });
    split(genpath(fullfile(hodi,'dem'))); %location for DEM data files
    fullfile(hodi, 'resrc', {'features';'sample';'focalmech'});
    fullfile(hodi, 'src',{'afterrate';
    'cgr_utils';
    'as_class';
    'declus';
    'pvals';
    'synthetic';
    'utils';
    'distance2curve';
    fullfile('system_dependent',computer)});
    fullfile(hodi,'src','cgr_utils',{'grids';'gui';'selections'});
    {fullfile(hodi, 'src', 'danijel')};
    fullfile(hodi, 'src', 'danijel', {'calc';
    'ex';
    'focal';
    'gui';
    'plot';
    'probfore'});
    {fullfile(hodi, 'src', 'jochen')};
    fullfile(hodi, 'src', 'jochen', {'auxfun';
    'ex';
    'plot';
    'seisvar';
    'stressinv'});
    fullfile(hodi, 'src', 'jochen', 'seisvar', 'calc');
    {fullfile(hodi, 'src', 'thomas')};
    fullfile(hodi, 'src', 'thomas', {'decluster';
    'etas';
    'slabanalysis';
    'seismicrates';
    });
    fullfile(hodi, 'src','thessa');
    fullfile(hodi, 'src', 'thomas', 'decluster', 'reasen');
    ];
addpath(path_list{:});