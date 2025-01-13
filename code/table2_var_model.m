%% Replicating Table 2

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Building demeaned z-matrix
z               = [housData.igrowth./100 housData.changes./100 log(housData.py)];

% Estimating VAR model equation-by-equation for the main sample: 2007-2021
res_var_main    = nwRegress(z(109+4:end,:),z(109:end-4,:),1,6);

% Estimating VAR model equation-by-equation for the long sample: 1980-2021
res_var_long    = nwRegress(z(5:end,:),z(1:end-4,:),1,6);

% Estimating VAR model equation-by-equation for the early sample: 1980-2006
res_var_early   = nwRegress(z(5:108,:),z(1:108-4,:),1,6);

% Writing result to LaTeX table
fid = fopen('../output/table2_var_model_estimates.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s \\\\\\midrule\n','Variable','$\Delta y_{t}$','$h_{t}$','$py_{t}$','R$^{2}\left(\%\right)$');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-5}\n','','\multicolumn{4}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$\Delta y_{t+1}$',res_var_main.bv(2:end,1),res_var_main.R2v(1));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_main.sbv(2:end,1),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$h_{t+1}$',res_var_main.bv(2:end,2),res_var_main.R2v(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_main.sbv(2:end,2),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$py_{t+1}$',res_var_main.bv(2:end,3),res_var_main.R2v(3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\\cmidrule(lr){2-5}\n','',res_var_main.sbv(2:end,3),'');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-5}\n','','\multicolumn{4}{c}{Long sample: 1980:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$\Delta y_{t+1}$',res_var_long.bv(2:end,1),res_var_long.R2v(1));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_long.sbv(2:end,1),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$h_{t+1}$',res_var_long.bv(2:end,2),res_var_long.R2v(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_long.sbv(2:end,2),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$py_{t+1}$',res_var_long.bv(2:end,3),res_var_long.R2v(3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\\cmidrule(lr){2-5}\n','',res_var_long.sbv(2:end,3),'');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-5}\n','','\multicolumn{4}{c}{Early sample: 1980:Q1 to 2006:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$\Delta y_{t+1}$',res_var_early.bv(2:end,1),res_var_early.R2v(1));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_early.sbv(2:end,1),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$h_{t+1}$',res_var_early.bv(2:end,2),res_var_early.R2v(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_early.sbv(2:end,2),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n','$py_{t+1}$',res_var_early.bv(2:end,3),res_var_early.R2v(3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',res_var_early.sbv(2:end,3),'');
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')