 function new_nct_start(x,startpoint,runthrough) 
    
    
    % nct_start
    settings_general; % load settings
    id_global=settings_variables(x); % load folder path variables
    
    id_global.parent = x;
    cd(id_global.parent);
    
    fprintf('\n\n Network Connectivity Toolbox \n\n Start folder: \t %s \n \n', id_global.parent);
    
    % extraction of p-values
    settings.thresholding_pro.pvalueName = index_Pval(settings.thresholding_pro.pvaluePool);
    settings.thresholding_abs.pvalueName = index_Pval(settings.thresholding_abs.pvaluePool);

    % indexing of masks/subjects in ROI/source
    index.subject_data = index_Nii(id_global.source);
    index.mask_data = index_Nii(id_global.roi);

    fprintf('Initializing: done \n \n');
    save('workspace_information.mat');

    %% timeseries extraction
    if startpoint == 1;
        [~, ~] = mkdir (id_global.output_timeseries);
        [path_mask, path_subj] = timeseries_extraction(id_global.parent, index.mask_data, index.subject_data);
        save('workspace_information.mat');
        if runthrough ==1;
            startpoint=startpoint+1;
        end
    end    
    %% correlation
    if startpoint == 2;
        [~, ~] = mkdir (id_global.output_correlation);
        [path_mask_corr, path_subj_corr] = timeseries_correlation(id_global.parent, path_mask, path_subj, index.mask_data, index.subject_data);   
        save('workspace_information.mat');
        if runthrough ==1;
            startpoint=startpoint+1;
        end
    end
    %% thresholding
    if startpoint == 3;
        [~, ~] = mkdir (id_global.output_thresh);
        if settings.thresh.absolute == 1;
            [path_mask_thr, path_subj_thr] = thresholding_abs(id_global.parent, settings.thresholding_abs.pvaluePool, path_subj_corr, index.mask_data, index.subject_data);
        end
        if settings.thresh.proportional == 1;
            [path_mask_thr, path_subj_thr] = thresholding_pro(id_global.parent, settings.thresholding_pro.pvaluePool, path_subj_corr, index.mask_data, index.subject_data);
        end
        save('workspace_information.mat');
        if runthrough ==1;
            startpoint=startpoint+1;
        end
    end
    
    %% graph metrics
    if startpoint == 4;
        [~, ~] = mkdir (id_global.output_metrics);
        if settings_corr_types_bin == 1;
            [path_metric_subjects, path_metrics] = graph_metric_calculation_binary(id_global.parent);
        end
        
        save('workspace_information.mat');
        if runthrough ==1;
            startpoint=startpoint+1;
        end
    end

    %% nii output
    if startpoint == 5 && settings.output.nifti == 1;
        [~, ~] = mkdir (id_global.output_nii);
        nii_conversion(id_global.parent);
        if runthrough ==1;
            startpoint=startpoint+1;
        end
    end
end