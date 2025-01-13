%% Replicating Table 8

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Computing forecast errors
forecast_errors     = -[
    [NaN(4,1); housData.changes(5:end,1) - [NaN(108,1); michiganData.hret1(1:end-4,2)]] ... 
    [NaN(4,1); housData.changes(5:end,1) - michiganData.lsynth(1:end-4,2)] ...
    [NaN(4,1); housData.igrowth(5:end,1) - michiganData.income(1:end-4,2)] ...
]./100;

% Computing belief distortions
z               = [housData.igrowth./100 housData.changes./100 log(housData.py)];
res_var_main    = nwRegress(z(109+4:end,:),z(109:end-4,:),1,6);
B               = res_var_main.bv(1,:)';
A               = res_var_main.bv(2:end,:)';
z_hat_main      = (B + A*z(1:end,:)')';

res_var_long    = nwRegress(z(5:end,:),z(1:end-4,:),1,6);
B               = res_var_long.bv(1,:)';
A               = res_var_long.bv(2:end,:)';
z_hat_long      = (B + A*z(1:end,:)')';

res_var_early     = nwRegress(z(5:108,:),z(1:108-4,:),1,6);
B               = res_var_early.bv(1,:)';
A               = res_var_early.bv(2:end,:)';
z_hat_early       = (B + A*z(1:end,:)')';

% Collecting belief distortions
belief_distortions = -[
    z_hat_main(:,2).*100 - [NaN(108,1); michiganData.hret1(1:end,2)] ... 
    z_hat_main(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_main(:,1).*100 - michiganData.income(:,2) ...
    z_hat_long(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_long(:,1).*100 - michiganData.income(:,2) ...                      
    z_hat_early(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_early(:,1).*100 - michiganData.income(:,2) ...                      
]./100;

% Running forecast error regressions in the main sample
fe.ret_main1        = nwRegress(forecast_errors(109+4:end,1),log(housData.py(109:end-4,1)),1,6);
fe.ret_main2        = nwRegress(forecast_errors(109+4:end,1),housData.changes(109:end-4,1)./100,1,6);
fe.ret_main3        = nwRegress(forecast_errors(109+4:end,1),housData.igrowth(109:end-4,1)./100,1,6);
fe.syn_main1        = nwRegress(forecast_errors(109+4:end,2),log(housData.py(109:end-4,1)),1,6);
fe.syn_main2        = nwRegress(forecast_errors(109+4:end,2),housData.changes(109:end-4,1)./100,1,6);
fe.syn_main3        = nwRegress(forecast_errors(109+4:end,2),housData.igrowth(109:end-4,1)./100,1,6);
fe.inc_main1        = nwRegress(forecast_errors(109+4:end,3),log(housData.py(109:end-4,1)),1,6);
fe.inc_main2        = nwRegress(forecast_errors(109+4:end,3),housData.changes(109:end-4,1)./100,1,6);
fe.inc_main3        = nwRegress(forecast_errors(109+4:end,3),housData.igrowth(109:end-4,1)./100,1,6);

% Running forecast error regressions in the long smaple
fe.syn_long1        = nwRegress(forecast_errors(1+4:end,2),log(housData.py(1:end-4,1)),1,6);
fe.syn_long2        = nwRegress(forecast_errors(1+4:end,2),housData.changes(1:end-4,1)./100,1,6);
fe.syn_long3        = nwRegress(forecast_errors(1+4:end,2),housData.igrowth(1:end-4,1)./100,1,6);
fe.inc_long1        = nwRegress(forecast_errors(1+4:end,3),log(housData.py(1:end-4,1)),1,6);
fe.inc_long2        = nwRegress(forecast_errors(1+4:end,3),housData.changes(1:end-4,1)./100,1,6);
fe.inc_long3        = nwRegress(forecast_errors(1+4:end,3),housData.igrowth(1:end-4,1)./100,1,6);

% Running forecast error regressions in the early smaple
fe.syn_early1       = nwRegress(forecast_errors(1+4:108,2),log(housData.py(1:108-4,1)),1,6);
fe.syn_early2       = nwRegress(forecast_errors(1+4:108,2),housData.changes(1:108-4,1)./100,1,6);
fe.syn_early3       = nwRegress(forecast_errors(1+4:108,2),housData.igrowth(1:108-4,1)./100,1,6);
fe.inc_early1       = nwRegress(forecast_errors(1+4:108,3),log(housData.py(1:108-4,1)),1,6);
fe.inc_early2       = nwRegress(forecast_errors(1+4:108,3),housData.changes(1:108-4,1)./100,1,6);
fe.inc_early3       = nwRegress(forecast_errors(1+4:108,3),housData.igrowth(1:108-4,1)./100,1,6);

% Running belief distortion regressions in the main sample
bd.ret_main1        = nwRegress(belief_distortions(109:end,1),log(housData.py(109:end,1)),1,6);
bd.ret_main2        = nwRegress(belief_distortions(109:end,1),housData.changes(109:end,1)./100,1,6);
bd.ret_main3        = nwRegress(belief_distortions(109:end,1),housData.igrowth(109:end,1)./100,1,6);
bd.syn_main1        = nwRegress(belief_distortions(109:end,2),log(housData.py(109:end,1)),1,6);
bd.syn_main2        = nwRegress(belief_distortions(109:end,2),housData.changes(109:end,1)./100,1,6);
bd.syn_main3        = nwRegress(belief_distortions(109:end,2),housData.igrowth(109:end,1)./100,1,6);
bd.inc_main1        = nwRegress(belief_distortions(109:end,3),log(housData.py(109:end,1)),1,6);
bd.inc_main2        = nwRegress(belief_distortions(109:end,3),housData.changes(109:end,1)./100,1,6);
bd.inc_main3        = nwRegress(belief_distortions(109:end,3),housData.igrowth(109:end,1)./100,1,6);

% Running belief distortion regressions in the long sample
bd.syn_long1        = nwRegress(belief_distortions(1:end,4),log(housData.py(1:end,1)),1,6);
bd.syn_long2        = nwRegress(belief_distortions(1:end,4),housData.changes(1:end,1)./100,1,6);
bd.syn_long3        = nwRegress(belief_distortions(1:end,4),housData.igrowth(1:end,1)./100,1,6);
bd.inc_long1        = nwRegress(belief_distortions(1:end,5),log(housData.py(1:end,1)),1,6);
bd.inc_long2        = nwRegress(belief_distortions(1:end,5),housData.changes(1:end,1)./100,1,6);
bd.inc_long3        = nwRegress(belief_distortions(1:end,5),housData.igrowth(1:end,1)./100,1,6);

% Running belief distortion regressions in the early sample
bd.syn_early1       = nwRegress(belief_distortions(1:108,6),log(housData.py(1:108,1)),1,6);
bd.syn_early2       = nwRegress(belief_distortions(1:108,6),housData.changes(1:108,1)./100,1,6);
bd.syn_early3       = nwRegress(belief_distortions(1:108,6),housData.igrowth(1:108,1)./100,1,6);
bd.inc_early1       = nwRegress(belief_distortions(1:108,7),log(housData.py(1:108,1)),1,6);
bd.inc_early2       = nwRegress(belief_distortions(1:108,7),housData.changes(1:108,1)./100,1,6);
bd.inc_early3       = nwRegress(belief_distortions(1:108,7),housData.igrowth(1:108,1)./100,1,6);

% Creating table with results
fid = fopen('../output/table8_errors_housing.tex','w');
fprintf(fid, '%s  & %s & %s \\\\\\cmidrule(lr){2-4}\\cmidrule(lr){5-7}\n','','\multicolumn{3}{c}{Panel A: Forecast errors}','\multicolumn{3}{c}{Panel B: Belief distortions}');
fprintf(fid, '%s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','$py_{t}$','$h_{t}$','$\Delta y_{t}$','$py_{t}$','$h_{t}$','$\Delta y_{t}$');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective returns',fe.ret_main1.bv(2),fe.ret_main2.bv(2),fe.ret_main3.bv(2),bd.ret_main1.bv(2),bd.ret_main2.bv(2),bd.ret_main3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.ret_main1.sbv(2),fe.ret_main2.sbv(2),fe.ret_main3.sbv(2),bd.ret_main1.sbv(2),bd.ret_main2.sbv(2),bd.ret_main3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',fe.ret_main1.R2v,fe.ret_main2.R2v,fe.ret_main3.R2v,bd.ret_main1.R2v,bd.ret_main2.R2v,bd.ret_main3.R2v);
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',fe.syn_main1.bv(2),fe.syn_main2.bv(2),fe.syn_main3.bv(2),bd.syn_main1.bv(2),bd.syn_main2.bv(2),bd.syn_main3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.syn_main1.sbv(2),fe.syn_main2.sbv(2),fe.syn_main3.sbv(2),bd.syn_main1.sbv(2),bd.syn_main2.sbv(2),bd.syn_main3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',fe.syn_main1.R2v,fe.syn_main2.R2v,fe.syn_main3.R2v,bd.syn_main1.R2v,bd.syn_main2.R2v,bd.syn_main3.R2v);
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',fe.inc_main1.bv(2),fe.inc_main2.bv(2),fe.inc_main3.bv(2),bd.inc_main1.bv(2),bd.inc_main2.bv(2),bd.inc_main3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.inc_main1.sbv(2),fe.inc_main2.sbv(2),fe.inc_main3.sbv(2),bd.inc_main1.sbv(2),bd.inc_main2.sbv(2),bd.inc_main3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\cmidrule(lr){2-7}\n','',fe.inc_main1.R2v,fe.inc_main2.R2v,fe.inc_main3.R2v,bd.inc_main1.R2v,bd.inc_main2.R2v,bd.inc_main3.R2v);
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Long sample: 1980:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',fe.syn_long1.bv(2),fe.syn_long2.bv(2),fe.syn_long3.bv(2),bd.syn_long1.bv(2),bd.syn_long2.bv(2),bd.syn_long3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.syn_long1.sbv(2),fe.syn_long2.sbv(2),fe.syn_long3.sbv(2),bd.syn_long1.sbv(2),bd.syn_long2.sbv(2),bd.syn_long3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',fe.syn_long1.R2v,fe.syn_long2.R2v,fe.syn_long3.R2v,bd.syn_long1.R2v,bd.syn_long2.R2v,bd.syn_long3.R2v);
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',fe.inc_long1.bv(2),fe.inc_long2.bv(2),fe.inc_long3.bv(2),bd.inc_long1.bv(2),bd.inc_long2.bv(2),bd.inc_long3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.inc_long1.sbv(2),fe.inc_long2.sbv(2),fe.inc_long3.sbv(2),bd.inc_long1.sbv(2),bd.inc_long2.sbv(2),bd.inc_long3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\cmidrule(lr){2-7}\n','',fe.inc_long1.R2v,fe.inc_long2.R2v,fe.inc_long3.R2v,bd.inc_long1.R2v,bd.inc_long2.R2v,bd.inc_long3.R2v);
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Early sample: 1980:Q1 to 2006:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',fe.syn_early1.bv(2),fe.syn_early2.bv(2),fe.syn_early3.bv(2),bd.syn_early1.bv(2),bd.syn_early2.bv(2),bd.syn_early3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.syn_early1.sbv(2),fe.syn_early2.sbv(2),fe.syn_early3.sbv(2),bd.syn_early1.sbv(2),bd.syn_early2.sbv(2),bd.syn_early3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',fe.syn_early1.R2v,fe.syn_early2.R2v,fe.syn_early3.R2v,bd.syn_early1.R2v,bd.syn_early2.R2v,bd.syn_early3.R2v);
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',fe.inc_early1.bv(2),fe.inc_early2.bv(2),fe.inc_early3.bv(2),bd.inc_early1.bv(2),bd.inc_early2.bv(2),bd.inc_early3.bv(2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',fe.inc_early1.sbv(2),fe.inc_early2.sbv(2),fe.inc_early3.sbv(2),bd.inc_early1.sbv(2),bd.inc_early2.sbv(2),bd.inc_early3.sbv(2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',fe.inc_early1.R2v,fe.inc_early2.R2v,fe.inc_early3.R2v,bd.inc_early1.R2v,bd.inc_early2.R2v,bd.inc_early3.R2v);
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')