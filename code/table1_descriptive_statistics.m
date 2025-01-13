%% Replicating Table 1

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Computing descriptive statistics for realized variables
realized_variables = [

    mean(housData.changes(109:end,1)) median(housData.changes(109:end,1)) std(housData.changes(109:end,1)) ...
    skewness(housData.changes(109:end,1)) kurtosis(housData.changes(109:end,1)) min(housData.changes(109:end,1)) max(housData.changes(109:end,1))
    %
    mean(housData.igrowth(109:end,1)) median(housData.igrowth(109:end,1)) std(housData.igrowth(109:end,1)) ...
    skewness(housData.igrowth(109:end,1)) kurtosis(housData.igrowth(109:end,1)) min(housData.igrowth(109:end,1)) max(housData.igrowth(109:end,1))
    %
    mean(housData.changes) median(housData.changes) std(housData.changes) ...
    skewness(housData.changes) kurtosis(housData.changes) min(housData.changes) max(housData.changes)
    %
    mean(housData.igrowth) median(housData.igrowth) std(housData.igrowth) ...
    skewness(housData.igrowth) kurtosis(housData.igrowth) min(housData.igrowth) max(housData.igrowth)
    %
    mean(housData.changes(1:108,1)) median(housData.changes(1:108,1)) std(housData.changes(1:108,1)) ...
    skewness(housData.changes(1:108,1)) kurtosis(housData.changes(1:108,1)) min(housData.changes(1:108,1)) max(housData.changes(1:108,1))
    %
    mean(housData.igrowth(1:108,1)) median(housData.igrowth(1:108,1)) ...
    std(housData.igrowth(1:108,1)) skewness(housData.igrowth(1:108,1)) kurtosis(housData.igrowth(1:108,1)) min(housData.igrowth(1:108,1)) max(housData.igrowth(1:108,1))

];

% Computing descriptive statistics for survey variables
survey_variables = [

    mean(michiganData.hret1(:,2)) median(michiganData.hret1(:,2)) std(michiganData.hret1(:,2)) ...
    skewness(michiganData.hret1(:,2)) kurtosis(michiganData.hret1(:,2)) min(michiganData.hret1(:,2)) max(michiganData.hret1(:,2))
    %
    mean(michiganData.ssynth(:,2)) median(michiganData.ssynth(:,2)) std(michiganData.ssynth(:,2)) ...
    skewness(michiganData.ssynth(:,2)) kurtosis(michiganData.ssynth(:,2)) min(michiganData.ssynth(:,2)) max(michiganData.ssynth(:,2))
    %
    mean(michiganData.hret5(:,2)) median(michiganData.hret5(:,2)) std(michiganData.hret5(:,2)) ...
    skewness(michiganData.hret5(:,2)) kurtosis(michiganData.hret5(:,2)) min(michiganData.hret5(:,2)) max(michiganData.hret5(:,2))
    %
    mean(michiganData.income(109:end,2)) median(michiganData.income(109:end,2)) std(michiganData.income(109:end,2)) ... 
    skewness(michiganData.income(109:end,2)) kurtosis(michiganData.income(109:end,2)) min(michiganData.income(109:end,2)) max(michiganData.income(109:end,2))
    %
    mean(michiganData.lsynth(:,2)) median(michiganData.lsynth(:,2)) std(michiganData.lsynth(:,2)) ...
    skewness(michiganData.lsynth(:,2)) kurtosis(michiganData.lsynth(:,2)) min(michiganData.lsynth(:,2)) max(michiganData.lsynth(:,2))
    %
    mean(michiganData.income(:,2)) median(michiganData.income(:,2)) std(michiganData.income(:,2)) ...
    skewness(michiganData.income(:,2)) kurtosis(michiganData.income(:,2)) min(michiganData.income(:,2)) max(michiganData.income(:,2))
    %
    mean(michiganData.lsynth(1:108,2)) median(michiganData.lsynth(1:108,2)) std(michiganData.lsynth(1:108,2)) ...
    skewness(michiganData.lsynth(1:108,2)) kurtosis(michiganData.lsynth(1:108,2)) min(michiganData.lsynth(1:108,2)) max(michiganData.lsynth(1:108,2))
    %
    mean(michiganData.income(1:108,2)) median(michiganData.income(1:108,2)) std(michiganData.income(1:108,2)) ...
    skewness(michiganData.income(1:108,2)) kurtosis(michiganData.income(1:108,2)) min(michiganData.income(1:108,2)) max(michiganData.income(1:108,2))
    
];

% Writing result to LaTeX table
fid = fopen('../output/table1_descriptve_statistics.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Variable','Mean','Median','Std.dev.','Skew','Kurt','Min','Max');
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{8}{c}{Panel A: Realized OECD housing data}');
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','Housing returns',realized_variables(1,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\cmidrule(lr){2-8}\n ','Income growth',realized_variables(2,:));
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Long sample: 1980:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','Housing returns',realized_variables(3,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\cmidrule(lr){2-8}\n ','Income growth',realized_variables(4,:));
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Early sample: 1980:Q1 to 2006:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','Housing returns',realized_variables(5,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\midrule\n ','Income growth',realized_variables(6,:));
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{8}{c}{Panel A: Michigan survey expectations}');
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','One-year housing returns',survey_variables(1,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','One-year synthetic returns',survey_variables(2,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','Five-year housing',survey_variables(3,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\cmidrule(lr){2-8}\n ','One-year income growth',survey_variables(4,:));
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Long sample: 1980:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','One-year synthetic returns',survey_variables(5,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\cmidrule(lr){2-8}\n ','One-year income growth',survey_variables(6,:));
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-8}\n','','\multicolumn{7}{c}{Early sample: 1980:Q1 to 2006:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','One-year synthetic returns',survey_variables(7,:));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n ','One-year income growth',survey_variables(8,:));
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')