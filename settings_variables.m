%% Folder Sub_Structure Setup
function id_global=settings_variables(x);

if x(end) == '\';
else;
    x=[x,'\']
end;


id_global.parent=x;

% Input Folders
id_global.roi = [id_global.parent,'input\roi'];
id_global.source = [id_global.parent,'input\source'];

% Output Folders
id_global.output_timeseries = [id_global.parent,'1_extraction\1_timeseries\'];
id_global.output_correlation = [id_global.parent,'1_extraction\2_correlation\'];
id_global.output_thresh = [id_global.parent,'1_extraction\3_threshold\'];
id_global.output_metrics = [id_global.parent,'2_metrics\'];
id_global.output_nii = [id_global.parent,'3_nii_output\'];



%{
thresh_subtype{1}= {'len'};
thresh_subtype{2}= {'bin'};
thresh_subtype{3}= {'wei'};
%}
end
% output+threshold folders
