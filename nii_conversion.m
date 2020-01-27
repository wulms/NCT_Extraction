function [path_subjects_metric, path_pval_metric] = nii_conversion(input_folder) %thresh



t_start = tic;

settings_general;
id_global=settings_variables(input_folder);

[path_subjects, masks, thr_type, thr_subtype, p_value, graph_metrics, metric_subjects] = index_graph_theory_folder(id_global.parent);

% masks=index_Folders(input_folder)
fprintf('\n\n >>>>>  NII conversion <<<<< calculation started \n ');
%%
    for count_mask_no = 1:length(masks)
       path_mask_metric{count_mask_no}     = [id_global.output_nii,char(masks(count_mask_no))];
       
       for count_thr_type_no = 1:length(thr_type{count_mask_no})
           path_thr_type_metric{count_mask_no,count_thr_type_no}   = ...
               [path_mask_metric{count_mask_no},filesep,...
               thr_type{count_mask_no}{count_thr_type_no}];

            for count_thr_subtype_no = 1:length(thr_subtype{count_mask_no,count_thr_type_no})
               path_thr_subtype_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no}  = ...
                   [path_thr_type_metric{count_mask_no,count_thr_type_no},filesep,...
                   char(thr_subtype{count_mask_no,count_thr_type_no}{count_thr_subtype_no})];

              for count_pval_no = 1:length(p_value{count_mask_no,count_thr_type_no,1})
                 path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no}   = ...
                     [path_thr_subtype_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no}, filesep,...
                     char(p_value{count_mask_no, count_thr_type_no,count_thr_subtype_no}{count_pval_no})];

                 for count_metrics_no = 1:length(graph_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no})
                         path_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no} = ...
                             [path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no},filesep,...
                             char(graph_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no}{count_metrics_no})];
                       %  metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no} = ...
                      %       index_Folders([path_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no}]);


                         [~,~] = mkdir([path_metrics{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no, count_metrics_no}]);
                     for count_subject_no = 1:length(metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no})
                         path_subjects_nii{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no,  count_subject_no} = ...
                             [path_metrics{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no, count_metrics_no},filesep,...
                             char(metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no}{count_subject_no})];

                         % load mat file

                                     
                         % Nii Filename for output
                         name = [path_subjects_nii{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no, count_subject_no}(1:end-4),'.nii'];
                         %%
                         if exist(name,'file') == 0;
                             Rex_file=index_Mat([id_global.output_timeseries,masks{count_mask_no}]);
                             load([id_global.output_timeseries,masks{count_mask_no},filesep,Rex_file{1}]);
                             % load file (input)
                             load(path_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no,count_subject_no});
                             % recon2nii_nct(metric,output_path)

                             % fprintf(name);
                             recon2nii_nct(metric, name);
                             fprintf('\n')
                             metric=0;
                             voxtime=0;
                             maskvol=0;
                         else
                             fprintf('\n File: "%s" already exists - calculation skipped.',name);                             
                         end




                     end
                 end                            
              end
           end
       end
    end

t_elapsed = toc(t_start);
fprintf('\n \n >>>>>  All NII - Images Converted <<<<< \n Duration: %2.2f min. \n',t_elapsed/60);

end