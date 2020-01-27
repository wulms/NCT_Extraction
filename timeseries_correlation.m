function [path_masks_corr, path_subj_corr] = timeseries_correlation(parent_folder, path_masks, path_subjects, masks, subjects)
    
    settings_general;
    id_global=settings_variables(parent_folder);

    % indexing of masks/subjects in ROI/source
    
    %% Correlation loop (over all masks, subjects)
    fprintf('\n >>>>> Correlation <<<<< started: \t %s \n',datetime)


    % ROI loop
    for count_roi_no = 1:length(masks)
        path_masks_corr{count_roi_no} = fullfile(id_global.output_correlation,masks{count_roi_no}(1:end-4),filesep);
                
        t_startROI = tic; % time measurement ROI mask
        [~, ~] = mkdir(path_masks_corr{count_roi_no});
        
        %subject loop
        for count_subject_no = 1:length(path_subjects{count_roi_no})
            
            path_subj_corr{count_roi_no,count_subject_no} = [path_masks_corr{count_roi_no} 'CORR_' masks{count_roi_no}(1:end-4) '_' subjects{count_subject_no}(1:end-4) '.mat'];
            if exist(path_subj_corr{count_roi_no,count_subject_no}) == 0;
                %load subject file - timeserie
                load(char(path_subjects{count_roi_no}(count_subject_no)));
                % timeseries extraction (saving in variable)
                t_startCorr = tic;
                corr_mat = triu(corrcoef(voxtime));
                clear voxtime;
                % maskvol = logical(corr_mat>0);  % find entries gt zero
                % fixing common issues (BCT tool)
                corr_mat = weight_conversion(corr_mat,'autofix');
                % very big files (>2 GB)
                % thresholding for file size saving
                save(path_subj_corr{count_roi_no,count_subject_no},'corr_mat','-v7.3'); 
                t_elapsedCorr = toc(t_startCorr);
                fprintf('\n Subject (%2.0f of %2.0f) with mask (%1.0f of %1.0f): \t "%s" \t Correlation done: %2.2f min.',count_subject_no,length(path_subjects{count_roi_no}),count_roi_no, length(masks),subjects{count_subject_no},t_elapsedCorr/60);
            else
                fprintf('\n File: "%s" already exists - calculation skipped.',path_subj_corr{count_roi_no,count_subject_no});
            end

        end
    t_elapsedROI = toc(t_startROI);
    fprintf('\n ----- All subjects correlated with ROI mask \t "%s" \t \t Duration: %2.2f min. -----',masks{count_roi_no},t_elapsedROI/60);
    end
    %}
    fprintf('\n \n +++++  Correlation done for all masks & subjects  +++++ \n \n '); 
        
end

