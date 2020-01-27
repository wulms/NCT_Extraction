function [path_masks_thr, path_subj_thr] = thresholding_abs(path_parent, pvalues, subjects_path, masks, subjects)
    

    
    settings_general;
    id_global=settings_variables(path_parent);
    pvalues_names = index_Pval(pvalues);
    
    %Thresholds
    thresh_type_path{1}{1} = {'absolute\bin\'};
    thresh_type_path{1}{2}= {'absolute\wei\'};
    thresh_type_path{1}{3}= {'absolute\len\'};
    thresh_type_path{2}{1}= {'proportional\bin\'};
    thresh_type_path{2}{2}= {'proportional\wei\'};
    thresh_type_path{2}{3}= {'proportional\len\'};

    thresh_type{1} = {'absolute'};
    thresh_type{2}= {'proportional'};

    fprintf('\n >>>>> Thresholding: "Absolute" <<<<< started: \t %s \n',datetime)
    % ROI loop
     for count_roi_no = 1:length(masks)
        path_masks_thr{count_roi_no} = fullfile(id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep);
                
        t_startROI = tic; % time measurement ROI mask
        [~, ~] = mkdir(path_masks_thr{count_roi_no});

        for count_subject_no = 1:length(subjects)
            t_startSubj = tic;
            %load subject file - correlation matrix


            for count_pval_no = 1:length(pvalues);
                fprintf('\n Threshold Value (%2.0f of %2.0f): %2.3f \t VP (%2.0f of %2.0f): "%s" \t Mask (%2.0f of %2.0f): "%s" \n ----- Thresholding: ', count_pval_no, length(pvalues), pvalues(count_pval_no),count_subject_no, length(subjects), subjects{count_subject_no}, count_roi_no, length(masks), masks{count_roi_no})

                % thresholding
                if settings_corr_types_bin == 1;
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{1})]);
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{1}),pvalues_names{count_pval_no}]);
                    path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no} = [id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{1}),pvalues_names{count_pval_no},filesep,'Thresh_abs_bin_',char(pvalues_names{count_pval_no}),'_',masks{count_roi_no}(1:end-4),'_',subjects{count_subject_no}(1:end-4),'.mat'];
                    if exist(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no}) == 0;
                        t_startThresh_Abs_bin = tic;
                        load(subjects_path{count_roi_no,count_subject_no});
                        corr_binary = weight_conversion(threshold_absolute(corr_mat,pvalues(count_pval_no)),'binarize');
                        save(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no},'corr_binary','-v7.3');
                        corr_binary=0;
                        corr_mat=0;
                        t_elapsedThresh_Abs_bin = toc(t_startThresh_Abs_bin);
                        fprintf(' Abs Binary: \t %2.2f min.\t',t_elapsedThresh_Abs_bin/60);
                    else
                        fprintf('\n File: "%s" already exists - calculation skipped.',path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no}); 
                    end
                end

                if settings_corr_types_wei == 1;
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{2})]);
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{2}),pvalues_names{count_pval_no}]);
                    path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no} = [id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{2}),pvalues_names{count_pval_no},filesep,'Thresh_abs_wei_',pvalues_names{count_pval_no},'_',masks{count_roi_no}(1:end-4),'_',subjects{count_subject_no}(1:end-4),'.mat'];
                    if exist(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no}) == 0;
                        t_startThresh_Abs_wei = tic;              
                        load(subjects_path{count_roi_no,count_subject_no});
                        corr_weighted = weight_conversion(threshold_absolute(corr_mat,pvalues(count_pval_no)),'normalize');
                        save(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no},'corr_weighted','-v7.3');
                        corr_weighted=0;
                        corr_mat=0;
                        t_elapsedThresh_Abs_wei = toc(t_startThresh_Abs_wei);
                        fprintf(' Abs Weighted: \t %2.2f min.\t',t_elapsedThresh_Abs_wei/60);
                    else
                        fprintf('\n File: "%s" already exists - calculation skipped.',path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no});
                    end
                end

                if settings_corr_types_len == 1;
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{3})]);
                    [~, ~] = mkdir([id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{3}),pvalues_names{count_pval_no}]);
                    path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no} = [id_global.output_thresh,masks{count_roi_no}(1:end-4),filesep,char(thresh_type_path{1}{3}),pvalues_names{count_pval_no},filesep,'Thresh_abs_len_',pvalues_names{count_pval_no},'_',masks{count_roi_no}(1:end-4),'_',subjects{count_subject_no}(1:end-4),'.mat'];
                    if exist(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no}) == 0;
                        t_startThresh_Abs_len = tic;              
                        load(subjects_path{count_roi_no,count_subject_no});
                        corr_length = weight_conversion(threshold_absolute(corr_mat,pvalues(count_pval_no)),'lengths');
                        save(path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no},'corr_length','-v7.3');
                        corr_mat=0;
                        corr_length=0;
                        t_elapsedThresh_Abs_len = toc(t_startThresh_Abs_len);
                        fprintf(' Abs Length: \t Duration: %2.2f min.\t',t_elapsedThresh_Abs_len/60);
                    else
                        fprintf('\n File: "%s" already exists - calculation skipped.',path_subj_thr{1}{count_pval_no}{count_roi_no}{count_subject_no});
                    end
                end
            end
        end
        t_elapsedROI = toc(t_startROI);
        fprintf('\n +++++ All subjects *Absolute* thresholded with ROI mask \t "%s" \t \t Duration: %2.2f min. +++++ \n ',masks{count_roi_no},t_elapsedROI/60);
    end
    %}
    fprintf('\n \n +++++   **Absolute** Thresholding done for all masks & subjects & pvalues  +++++ \n \n ');
   
end


