% extracts names from multiple p_values for file naming

function pvalueName = index_Pval(pvalues)

    pvalueName = cell(size(pvalues));
    fprintf(' - - - Indexing p-values - - - \n \n')
    for count_pvalueNo = 1:length(pvalues)
        name = num2str(pvalues(count_pvalueNo));
        pvalueName{count_pvalueNo} = ['0_',name(3:end)];
    end

end