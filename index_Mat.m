function mat = index_Mat(input_folder)

%indexing of source files
mat= dir(input_folder);
count_tmp_idx = find(arrayfun(@(x) length(mat(x).name),1:length(mat))>4);
count_tmp_idx2 = count_tmp_idx(arrayfun(@(x) strcmp(mat(x).name(end-3:end), '.mat'),count_tmp_idx));
mat = {mat(count_tmp_idx2).name};

end