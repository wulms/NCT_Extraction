function [path_subjects_metric, path_pval_metric] = graph_metric_calculation(input_folder) %thresh

t_start = tic;

%id_global.output_metrics = input_folder;

settings_general;
id_global=settings_variables(input_folder);

[path_subjects, masks, thr_type, thr_subtype, p_value, thresh_subjects] = index_Thresh(input_folder);

% masks=index_Folders(input_folder)
fprintf('>>>>>  Clustering Coefficient binary <<<<< calculation started');

for count_mask_no = 1:length(masks)
   path_mask_metric{count_mask_no}     = [id_global.output_metrics,char(masks(count_mask_no))];
   
   for count_thr_type_no = 1:length(thr_type{count_mask_no})
       path_thr_type_metric{count_mask_no,count_thr_type_no}   = ...
           [path_mask_metric{count_mask_no},filesep,...
           thr_type{count_mask_no}{count_thr_type_no}];
      
%        for count_thr_subtype_no = 1:length(thr_subtype{count_mask_no,count_thr_type_no})
           path_thr_subtype_metric{count_mask_no, count_thr_type_no, 1}  = ...
               [path_thr_type_metric{count_mask_no,count_thr_type_no},filesep,...
               char(thr_subtype{count_mask_no,count_thr_type_no}{1})];
          
          for count_pval_no = 1:length(p_value{count_mask_no,count_thr_type_no,1})
             path_pval_metric{count_mask_no, count_thr_type_no, 1, count_pval_no}   = ...
                 [path_thr_subtype_metric{count_mask_no, count_thr_type_no, 1}, filesep,...
                 char(p_value{count_mask_no, count_thr_type_no,1}{count_pval_no})];
     %% clustering coefficient loop
     % if statement include
             [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no, 1, count_pval_no},'\Clustering_Coeff']);

             
             for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                 path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                     [path_pval_metric{count_mask_no, count_thr_type_no, 1, count_pval_no},filesep,...
                     char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];
                 
                 % load mat file
                 
                 fprintf(' >>>>> Clustering Coefficient binary <<<<<: calculation started');            
                 t_start_loop = tic;

                 load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                 metric = clustering_coef_bu(corr_binary);
                 corr_binary=0;
                 metric_name = [path_pval_metric{count_mask_no, count_thr_type_no, 1, count_pval_no},filesep,...
                     'Clustering_Coeff\CC_',...
                     thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                 
                 save(metric_name,'metric');
                 metric = 0;
                 
                 t_elapsed_loop = toc(t_start_loop);
                 fprintf('\n Subject: "%s" \t Clustering Coefficient binary: %2.2f min.',...
                    thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);

                 
             end   
      % if statement end
          end
           
   end
end


t_elapsed = toc(t_start);
fprintf('\n \n All Clustering Coefficients calculated! \n Duration: %2.2f min. \n',t_elapsed/60);

end