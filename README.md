>>>>>     NCT Extraction     <<<<< 
(FURCON) - Functional rs Connectivity Networks 
(GraBa) - Graph Batch processing
(NECT) - Network extration correlation thresholding
    FUnctional
    Resting-state
    COnnectivity/Correlation
    Nii Output
    Network
    Extraction
    Correlation
    Thresholding
    Metric/Graph
    Batch Processing
Credits:
    Supervisor: Prof. Dr. Tobias Schmidt-Wilcke
    Developed at: St. Mauritius Therapy Clinics, Meerbusch, Germany
    Coding: Niklas Wulms, PhD. Cand., IGSN
used scripts:
    BCT - Toolbox
    REX - Toolbox
        -take a look at recon2nii (who has the rights to this script (Stefanie Heba, Benjamin Glaubitz)? 
        used for NII output
How to use:
    you need a folder named "input", containing a folder "source" (your
    functional images) and "roi" (your roi images for extraction)
    working folder -> contains "input" folder
run script using "start_nct(working folder, program step to start, run all following analyses); 
    programm steps:
        1=extraction
        2=correlation
        3=thresholding
        4=graph_metrices
        5=nii_output
    run all following
        1=yes
        2=no, only mentioned step
previous versions:
    -calculation of 
        -multiple ROIS, 
        -p_values, 
        -threshold types (absolute, proportional), 
        -threshold subtypes (binary, weighted, length),  
        possible.
Simply switch on (1) and off (0) in the "settings_general.m" file.
    --> Standard settings - run ALL.
File output: 
    Structured depending on ROIS, choosen p_vals, threshold_types and subtypes,
    as well as metrics
Structure:
    input - input folder containing "roi"s and "source" (subject) images
    creation of
    1_extraction - containing:
        1_timeseries - extracted timeseries (with REX toolbox)
        2_correlation - correlated timeseries, only one half of the correlation
            matrix is saved
        3_threshold
            ROI folders
                threshold type folders (absolute / proportional)
                    Threshold subtype folders (bin, wei, len)
                        p_values
    2_metrics
        same structure as 3_threshold folder + metric name as folders
    3_nii_output
        same structure as 2_metrics
        nii files for each file in metrics folders (very fast calculation)
        
Use NII files with e.g. SPM for conducting your parametrical test
V. 0.5 - 05.01.2018 - NW
    -Backslash error fixed if last '\' in path_variable is missing
    -implementation of binary graph metrices
        -"if conditions" for selection of metrices
        08.01.2018 - NW
    -Implementation of file existence check to reduce amount of written
    data, when something was already calculated
future versions
    -Implementation of
        -mean correlation matrix of whole group
            -which then is applied to all subjects
        -non-parametrical testing procedures
            -permutation testing
    -benchmark of metrics, calculation of time amount, progress tracking
    -Excel output of global metrics/mean metrics
    -possibility to start only one step of analysis
    -parallel computing toolbox (enhance processing time)
    -minor changes
        -shorten code
            -delete useless variables
            -use only code, that is really needed
            -write smarter functions

