function [path_subjects, masks, thr_type, thr_subtype, p_value, graph_metrics, metric_subjects] = index_graph_metrics(input_folder)

    settings_general;
    id_global=settings_variables(input_folder);

    masks=index_Folders(id_global.output_thresh);
    fprintf('- - - Indexing data in "metric" folder - - -')
    
    for count_mask_no = 1:length(masks)
       path_mask{count_mask_no}     = [id_global.output_metrics,char(masks(count_mask_no))];
       thr_type{count_mask_no}      = index_Folders([path_mask{count_mask_no}]);

       
       for count_thr_type_no = 1:length(thr_type{count_mask_no})
           path_thr_type{count_mask_no,count_thr_type_no}   = [path_mask{count_mask_no},filesep,...
               thr_type{count_mask_no}{count_thr_type_no}];          
           thr_subtype{count_mask_no,count_thr_type_no}     = index_Folders([path_thr_type{count_mask_no,count_thr_type_no}]);

           
           for count_thr_subtype_no = 1:length(thr_subtype{count_mask_no,count_thr_type_no})
              path_thr_subtype{count_mask_no, count_thr_type_no, count_thr_subtype_no}  = [path_thr_type{count_mask_no,count_thr_type_no},filesep,...
                  char(thr_subtype{count_mask_no,count_thr_type_no}{count_thr_subtype_no})];             
              p_value{count_mask_no,count_thr_type_no,count_thr_subtype_no}             = ...
                  index_Folders([path_thr_subtype{count_mask_no,count_thr_type_no, count_thr_subtype_no}]);

              
              for count_pval_no = 1:length(p_value{count_mask_no,count_thr_type_no,count_thr_subtype_no})
                 path_pval{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no}   = [path_thr_subtype{count_mask_no, count_thr_type_no, count_thr_subtype_no}, filesep,...
                     char(p_value{count_mask_no, count_thr_type_no,count_thr_subtype_no}{count_pval_no})];                
                 graph_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no} = ...
                     index_Folders([path_pval{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no}]);
                 
                 
                 for count_metrics_no = 1:length(graph_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no})
                     path_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no} = ...
                         [path_pval{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no},filesep,...
                         char(graph_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no}{count_metrics_no})];
                     metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no} = ...
                         index_Folders([path_metrics{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no}]);

                 
                     for count_subject_no = 1:length(metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no})
                    path_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no,  count_subject_no} = ...
                         [path_metrics{count_mask_no, count_thr_type_no, count_thr_subtype_no, count_pval_no, count_metrics_no},filesep,...
                         char(metric_subjects{count_mask_no, count_thr_type_no,count_thr_subtype_no, count_pval_no, count_metrics_no}{count_subject_no})];
                     end
                 end                            
              end
           end    
       end
    end
end