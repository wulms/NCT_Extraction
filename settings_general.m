%% var settings for storing all settings
% types of thresholding
settings.thresh.absolute = [1];
settings.thresh.proportional = [1];

% types of correlation matrix
settings_corr_types_bin = [1];
settings_corr_types_wei = [0];
settings_corr_types_len = [0];

% Thresholds
settings.thresholding_pro.pvaluePool = [0.1];    % more values = more thresholds
settings.thresholding_abs.pvaluePool = [0.1 0.2 0.3];      % take care - order dependent - low to high values!

% output data (not implemented)
settings.output.nifti = [1];



%% Used Graph Metrices
% calculated - if settings.corr_matrix.bin == 1;
    settings.metrics.clustering_coef = [1]; % < 12 hours
    settings.metrics.transitivity = [0]; 
    settings.metrics.efficiency_global = [0]; 
    settings.metrics.efficiency_local = [0]; % takes very long! < 16 Hours
    settings.metrics.distance = [0]; % data bigger than 2 GB !!!
    settings.metrics.rich_club = [0]; 
    settings.metrics.betweenness_centrality = [1]; 
    settings.metrics.degrees = [1]; 
    settings.metrics.assortativity = [0]; 
    settings.metrics.modularity = [0]; 
    settings.metrics.density = [0]; 
    settings.metrics.link_communities = [0];


%{ 
calculated - if settings.corr_matrix.wei == 1;
    settings.metrics.strengths = [1]; 
    
% calculated - if settings.corr_matrix.len == 1;
    settings.metrics.distance = [1];
    settings.metrics.density = [1];
%}

%% REX Toolbox Settings

settings.rex.i_sum_meas          = 'mean';       % options: 'mean'|'eigenvariate'|'median'|'weighted mean'|'count'
settings.rex.i_level             = 'voxels';     % options: 'ROIs'|'clusters'|'peaks'|'voxels'
settings.rex.i_scale             = 'none';       % options: 'none'|'global'|'roi'
settings.rex.i_out               = 'saverex';       % options: 'none'|'save'|'saverex'
settings.rex.i_gui               = 0;            % 1 = gui, 0 = no gui
settings.rex.i_sel_clust         = 0;            % 1 = select cluster, 0 = no selection
settings.rex.i_dims              = 1;            % No. of eigenvariates to extract (for 'eigenvariate' summary measure only)
settings.rex.i_mindist           = 20;           % minimum distance (mm) between peaks (for 'peak' level only)
settings.rex.i_maxpeak           = 32;           % max. # peaks per cluster (for 'peak' level only)


save settings;