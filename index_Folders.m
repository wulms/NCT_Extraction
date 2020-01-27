function folders = index_Folders(input_folder)

%indexing of source files
folders= dir(input_folder);
count_tmp_idx = find(arrayfun(@(x) length(folders(x).name),1:length(folders))>2);
folders = {folders(count_tmp_idx).name};

end