function [path_subjects_metric, path_pval_metric] = graph_metric_calculation_binary(input_folder) %thresh



%id_global.output_metrics = input_folder;

settings_general;
id_global=settings_variables(input_folder);

[path_subjects, masks, thr_type, thr_subtype, p_value, thresh_subjects] = index_Thresh(input_folder);

% masks=index_Folders(input_folder)
fprintf('\n\n >>>>>  Metric calculation binary <<<<<  started');

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
             path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no}   = ...
                 [path_thr_subtype_metric{count_mask_no, count_thr_type_no, 1}, filesep,...
                 char(p_value{count_mask_no, count_thr_type_no,1}{count_pval_no})];
            %% clustering coefficient loop
             if settings.metrics.clustering_coef == 1;
             [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Clustering_Coeff']);
             fprintf('\n \n>>>>> Clustering Coefficient binary <<<<<: calculation started');
             t_start = tic;
             for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                 path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                     [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                     char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];                                                                          
                 metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                     'Clustering_Coeff\CC_',...
                     thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                 
                 if exist(metric_name) == 0;
                     t_start_loop = tic;
                     load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});                 
                     metric = clustering_coef_bu(corr_binary);
                     corr_binary=0;
                     save(metric_name,'metric');
                     metric = 0;
                     t_elapsed_loop = toc(t_start_loop);
                     fprintf('\n Subject: "%s" \t Clustering Coefficient binary: %2.2f min.',...
                        thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);
                 else
                        fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                 end                                                
             end
             t_elapsed = toc(t_start);
             fprintf('\n \n All Clustering Coefficients calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
            % if statement end
             end

             %% transitivity
             if settings.metrics.transitivity == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Transitivity']);
                 fprintf('\n \n>>>>> Transitivity binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                    metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Transitivity\Trans_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = transitivity_bu(corr_binary);
                         corr_binary=0;                     
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Transitivity binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60); 
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end                                                    
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Transitivities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% efficiency_global
             if settings.metrics.efficiency_global == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Efficiency_glob']);
                 fprintf('\n \n>>>>> Efficiency Global binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Efficiency_glob\Eff_glob_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = efficiency_bin(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Efficiency Global binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end                     
                     
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Efficiencies Global calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% efficiency_local
             if settings.metrics.efficiency_local == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Efficiency_loc']);
                 fprintf('\n \n>>>>> Efficiency Local binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Efficiency_loc\Eff_loc_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = efficiency_bin(corr_binary,1);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Efficiency Local binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Efficiencies Local calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% distance
             if settings.metrics.distance == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Distance']);
                 fprintf('\n \n>>>>> Distance binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Distance\DIST_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = distance_bin(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Distance binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Distances calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% rich_club
             if settings.metrics.rich_club == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Rich_Club']);
                 fprintf('\n \n>>>>> Rich Club binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Rich_Club\RC_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];

                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = rich_club_bu(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Rich Club binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Rich Clubs calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% betweenness_centrality
             if settings.metrics.betweenness_centrality == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Betweenness_Centrality']);
                 fprintf('\n \n>>>>> Betweenness Centrality binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Betweenness_Centrality\BC_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = betweenness_bin(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Betweenness Centrality binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Betweenness Centralities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% degrees
             if settings.metrics.degrees == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Degrees']);
                 fprintf('\n \n>>>>> Degrees binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Degrees\DG_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = degrees_und(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Degrees binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Degrees calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% assortativity
             if settings.metrics.assortativity == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Assortativity']);
                 fprintf('\n \n>>>>> Assortativity binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Assortativity\ASS_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = assortativity_bin(corr_binary,0);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Assortativity binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Assortativities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% modularity (normally to outputs!)
             if settings.metrics.modularity == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Modularity']);
                 fprintf('\n \n>>>>> Modularity binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name_Ci = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Modularity\MOD_Ci_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name_Ci) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         [Ci, Q] = modularity_und(corr_binary);
                        % normally two outputs! Ci & Q
                         corr_binary=0;
                         % Ci output
                         save(metric_name_Ci,'Ci');
                         Ci = 0;
                         % Q output
                         metric_name_Q = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                             'Modularity\MOD_Q_',...
                             thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                         save(metric_name_Q,'Q');
                         Q = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Modularity binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Modularities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% density
             if settings.metrics.density == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Density']);
                 fprintf('\n \n>>>>> Density binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Density\DEN_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];

                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = density_und(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Density binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Densities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
             %% link_communities
             if settings.metrics.link_communities == 1;
                 [~,~] = mkdir([path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},'\Link_communities']);
                 fprintf('\n \n>>>>> Link Communities binary <<<<<: calculation started');
                 t_start = tic;
                 for count_subject_no = 1:length(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no})
                     path_subjects_metric{count_mask_no, count_thr_type_no,1, count_pval_no, count_subject_no} = ...
                         [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         char(thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no})];              
                     metric_name = [path_pval_metric{count_mask_no, count_thr_type_no,1, count_pval_no},filesep,...
                         'Link_communities\LC_',...
                         thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no}];
                     
                     if exist(metric_name) == 0;
                         t_start_loop = tic;
                         load(path_subjects{count_mask_no, count_thr_type_no,1, count_pval_no,count_subject_no});
                         metric = link_communities(corr_binary);
                         corr_binary=0;
                         save(metric_name,'metric');
                         metric = 0;
                         t_elapsed_loop = toc(t_start_loop);
                         fprintf('\n Subject: "%s" \t Link Communities binary: %2.2f min.',...
                            thresh_subjects{count_mask_no, count_thr_type_no,1, count_pval_no}{count_subject_no},t_elapsed_loop/60);               
                     else
                            fprintf('\n File: "%s" already exists - calculation skipped.',metric_name); 
                     end
                 end
                 t_elapsed = toc(t_start);
                 fprintf('\n \n All Link Communities calculated! \t Duration: %2.2f min. \n',t_elapsed/60);
                % if statement end
             end
             
       
%% end big loop             
          end
% end function          
   end




end

end