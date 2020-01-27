function [path_subjects_graph, graph_metric] = graph_metric_calculation(path_parent) %thresh

t_start = tic;

%id_global.output_metrics = input_folder;

settings_general;
id_global=settings_variables(path_parent);

[path_subjects, masks, thr_type, thr_subtype, p_value, thresh_subjects] = index_Thresh(path_parent);



% masks=index_Folders(input_folder)

for count_mask_no = 1:length(masks)
   path_mask_metric{count_mask_no}     = [id_global.output_metrics,char(masks(count_mask_no))]
   
   for count_thr_type_no = 1:length(thr_type{count_mask_no})
       path_thr_type_metric{count_mask_no,count_thr_type_no}   = ...
           [path_mask_metric{count_mask_no},filesep,...
           thr_type{count_mask_no}{count_thr_type_no}];
      
       for count_thr_subtype_no = 1:length(thr_subtype{count_mask_no,count_thr_type_no})
          path_thr_subtype_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no}  = ...
              [path_thr_type_metric{count_mask_no,count_thr_type_no},filesep,...
              char(thr_subtype{count_mask_no,count_thr_type_no}{count_thr_subtype_no})];
          
          for count_pval_no = 1:length(p_value{count_mask_no,count_thr_type_no,count_thr_subtype_no})
             path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no}   = ...
                 [path_thr_subtype_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no}, filesep,...
                 char(p_value{count_mask_no, count_thr_type_no,count_thr_subtype_no}{count_pval_no})];
             
             for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no})
                 path_subjects_metric{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_subject_no} = ...
                     [path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no},filesep,...
                     char(thresh_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no}{count_subject_no})];
                 
                 % load mat file
                 
                 fprintf(' >>>>> Clustering Coefficient binary <<<<<: calculation started');
                 [~,~] = mkdir(path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no});
                 t_start_loop = tic;

                 load(path_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no,count_subject_no});
                 metric = clustering_coef_bu(corr_binary);
                 corr_binary=0;
                 metric_name = [path_pval_metric{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no},filesep,...
                     'Clustering_Coeff\CC_',...
                     thresh_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no}{count_subject_no}];
                 
                 save(metric_name),'metric');
                 metric = 0;
                 
                 t_elapsed_loop = toc(t_start_loop);
                fprintf('\n VP:"%s" Clustering Coefficient binary: \t \t Duration: %2.2f min.',subjects{count_thr_no}{1,1}{count_thr_subjects},t_elapsed_loop/60);

                 
             end                            
          end
       end    
   end
end


t_elapsed = toc(t_start);
fprintf('\n All Clustering Coefficients calculated! \n Duration: %2.2f min. \n',t_elapsed/60);

end