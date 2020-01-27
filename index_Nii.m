function nii = index_Nii(input_folder)

%indexing of source files
nii= dir(input_folder);
count_tmp_idx = find(arrayfun(@(x) length(nii(x).name),1:length(nii))>4);
count_tmp_idx2 = count_tmp_idx(arrayfun(@(x) strcmp(nii(x).name(end-3:end), '.nii'),count_tmp_idx));
nii = {nii(count_tmp_idx2).name};

end