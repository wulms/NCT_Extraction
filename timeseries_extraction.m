function [maskPath, subjectPath] =  timeseries_extraction(parent_folder, mask_data, subject_data)

settings_general;
id_global=settings_variables(parent_folder); % or load workspace?

fprintf('\n >>>>> ROI timeseries extraction <<<<< started: \t %s \n \n',datetime)

t_startExtraction = tic;

for count_roi_no = 1:length(mask_data)
    roiPath = [id_global.roi,filesep,mask_data{count_roi_no}];
    t_startROI = tic; % time measurement ROI mask
    
    
    maskPath{count_roi_no} = fullfile(id_global.output_timeseries,mask_data{count_roi_no}(1:end-4));
    [~, ~] = mkdir(maskPath{count_roi_no});
    
    for count_subject_no = 1:length(subject_data)
        rex_name = [maskPath{count_roi_no} '\REX_' mask_data{count_roi_no}(1:end-4) '_' subject_data{count_subject_no}(1:end-4) '.mat'];
        subjPath = [id_global.source,filesep,subject_data{count_subject_no}];      
        subjectPath{count_roi_no}{count_subject_no} = rex_name;

        if exist(rex_name) == 0;
            t_startSubj = tic;
            % timeseries extraction (saving in variable)
            temp_rex=rex(subjPath,roiPath,... 
                        'summary_measure',settings.rex.i_sum_meas, 'level',settings.rex.i_level, 'scaling',settings.rex.i_scale,...
                        'output_type',settings.rex.i_out, 'gui',settings.rex.i_gui, 'select_clusters',settings.rex.i_sel_clust,...
                        'dims',settings.rex.i_dims, 'mindist',settings.rex.i_mindist, 'maxpeak',settings.rex.i_maxpeak);

            % Rex saving as .mat file       
            load('REX.mat');
            voxtime = params.ROIdata;
            % maskvol = logical(voxtime>0);  % find entries gt zero
            save(rex_name,'voxtime','params'); % 'maskvol',
            t_elapsedSubj = toc(t_startSubj);
            fprintf('Subject (%2.0f of %2.0f) with mask (%2.0f of %2.0f): \t "%s" \t Extraction done: %2.2f min. \n',count_subject_no, length(subject_data),count_roi_no,length(mask_data),subject_data{count_subject_no},t_elapsedSubj/60);
        else
            fprintf('\n File: "%s" already exists - calculation skipped.',rex_name);
        end
    end
    
   
    t_elapsedROI = toc(t_startROI);

    fprintf('----- All subjects extracted with ROI mask \t "%s" \t \t Duration: %2.2f min. -----\n',mask_data{count_roi_no},t_elapsedROI/60);
end

% clear maskvol;
clear temp_rex;
clear voxtime;

save('workspace_information.mat');

t_elapsedExtraction=toc(t_startExtraction);

fprintf(' \n +++++  ROI timeseries extraction done: %2.2f min.  +++++ \n \n',t_elapsedExtraction/60);

end
