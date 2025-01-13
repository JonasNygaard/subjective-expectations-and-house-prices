%% Replicating Table 9

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
];

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

res_var_early   = nwRegress(z(5:108,:),z(1:108-4,:),1,6);
B               = res_var_early.bv(1,:)';
A               = res_var_early.bv(2:end,:)';
z_hat_early     = (B + A*z(1:end,:)')';

% Collecting belief distortions
belief_distortions = -[
    z_hat_main(:,2).*100 - [NaN(108,1); michiganData.hret1(1:end,2)] ... 
    z_hat_main(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_main(:,1).*100 - michiganData.income(:,2) ...
    z_hat_long(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_long(:,1).*100 - michiganData.income(:,2) ...                      
    z_hat_early(:,2).*100 - michiganData.lsynth(:,2) ...
    z_hat_early(:,1).*100 - michiganData.income(:,2) ...                      
];

% Running forecast erorr regressions with AR term
fe.ret_main1        = nwRegress(forecast_errors(109+8:end,1),[forecast_errors(109+4:end-4,1) sloosData.sloos(109+4:end-4,:)],1,6);
fe.syn_main1        = nwRegress(forecast_errors(109+8:end,2),[forecast_errors(109+4:end-4,2) sloosData.sloos(109+4:end-4,:)],1,6);
fe.inc_main1        = nwRegress(forecast_errors(109+8:end,3),[forecast_errors(109+4:end-4,3) sloosData.sloos(109+4:end-4,:)],1,6);
fe.syn_long1        = nwRegress(forecast_errors(41+8:end,2),[forecast_errors(41+4:end-4,2) sloosData.sloos(41+4:end-4,:)],1,6);
fe.inc_long1        = nwRegress(forecast_errors(41+8:end,3),[forecast_errors(41+4:end-4,3) sloosData.sloos(41+4:end-4,:)],1,6);
fe.syn_early1       = nwRegress(forecast_errors(41+8:109,2),[forecast_errors(41+4:109-4,2) sloosData.sloos(41+4:109-4,:)],1,6);
fe.inc_early1       = nwRegress(forecast_errors(41+8:109,3),[forecast_errors(41+4:109-4,3) sloosData.sloos(41+4:109-4,:)],1,6);

% Running forecast erorr regressions without AU term
fe.ret_main2        = nwRegress(forecast_errors(109+8:end,1),sloosData.sloos(109+4:end-4,:),1,6);
fe.syn_main2        = nwRegress(forecast_errors(109+8:end,2),sloosData.sloos(109+4:end-4,:),1,6);
fe.inc_main2        = nwRegress(forecast_errors(109+8:end,3),sloosData.sloos(109+4:end-4,:),1,6);
fe.syn_long2        = nwRegress(forecast_errors(41+8:end,2),sloosData.sloos(41+4:end-4,:),1,6);
fe.inc_long2        = nwRegress(forecast_errors(41+8:end,3),sloosData.sloos(41+4:end-4,:),1,6);
fe.syn_early2       = nwRegress(forecast_errors(41+8:109,2),sloosData.sloos(41+4:109-4,:),1,6);
fe.inc_early2       = nwRegress(forecast_errors(41+8:109,3),sloosData.sloos(41+4:109-4,:),1,6);

% Running belief distortion regressions with AR term
bd.ret_main1        = nwRegress(belief_distortions(109+4:end,1),[belief_distortions(109:end-4,1) sloosData.sloos(109+4:end,:)],1,6);
bd.syn_main1        = nwRegress(belief_distortions(109+4:end,2),[belief_distortions(109:end-4,2) sloosData.sloos(109+4:end,:)],1,6);
bd.inc_main1        = nwRegress(belief_distortions(109+4:end,3),[belief_distortions(109:end-4,3) sloosData.sloos(109+4:end,:)],1,6);
bd.syn_long1        = nwRegress(belief_distortions(41+4:end,4),[belief_distortions(41:end-4,4) sloosData.sloos(41+4:end,:)],1,6);
bd.inc_long1        = nwRegress(belief_distortions(41+4:end,5),[belief_distortions(41:end-4,5) sloosData.sloos(41+4:end,:)],1,6);
bd.syn_early1       = nwRegress(belief_distortions(41+4:109,6),[belief_distortions(41:109-4,6) sloosData.sloos(41+4:109,:)],1,6);
bd.inc_early1       = nwRegress(belief_distortions(41+4:109,7),[belief_distortions(41:109-4,7) sloosData.sloos(41+4:109,:)],1,6);

% Running belief distortion regressions without AR term
bd.ret_main2        = nwRegress(belief_distortions(109:end,1),sloosData.sloos(109:end,:),1,6);
bd.syn_main2        = nwRegress(belief_distortions(109:end,2),sloosData.sloos(109:end,:),1,6);
bd.inc_main2        = nwRegress(belief_distortions(109:end,3),sloosData.sloos(109:end,:),1,6);
bd.syn_long2        = nwRegress(belief_distortions(44:end,4),sloosData.sloos(44:end,:),1,6);
bd.inc_long2        = nwRegress(belief_distortions(44:end,5),sloosData.sloos(44:end,:),1,6);
bd.syn_early2       = nwRegress(belief_distortions(44:109,6),sloosData.sloos(44:109,:),1,6);
bd.inc_early2       = nwRegress(belief_distortions(44:109,7),sloosData.sloos(44:109,:),1,6);

% Creating table with results
fid = fopen('../output/table9_errors_sloos.tex','w');
fprintf(fid, '%s  & %s & %s \\\\\\cmidrule(lr){2-5}\\cmidrule(lr){6-9}\n','','\multicolumn{4}{c}{Panel A: Forecast errors}','\multicolumn{4}{c}{Panel B: Belief distortions}');
fprintf(fid, '%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','AR$\left(1\right)$','Demand','Supply','R$^{2}\left(\%\right)$','AR$\left(1\right)$','Demand','Supply','R$^{2}\left(\%\right)$');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-9}\n','','\multicolumn{6}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Subjective returns','',fe.ret_main2.bv(2),fe.ret_main2.bv(3),fe.ret_main2.R2v,'',bd.ret_main2.bv(2),bd.ret_main2.bv(3),bd.ret_main2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.ret_main2.sbv(2),fe.ret_main2.sbv(3),'','',bd.ret_main2.sbv(2),bd.ret_main2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.ret_main1.bv(2),fe.ret_main1.bv(3),fe.ret_main1.bv(4),fe.ret_main1.R2v,bd.ret_main1.bv(2),bd.ret_main1.bv(3),bd.ret_main1.bv(4),bd.ret_main1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',fe.ret_main1.sbv(2),fe.ret_main1.sbv(3),fe.ret_main1.sbv(4),'',bd.ret_main1.sbv(2),bd.ret_main1.sbv(3),bd.ret_main1.sbv(4),'');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic returns','',fe.syn_main2.bv(2),fe.syn_main2.bv(3),fe.syn_main2.R2v,'',bd.syn_main2.bv(2),bd.syn_main2.bv(3),bd.syn_main2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.syn_main2.sbv(2),fe.syn_main2.sbv(3),'','',bd.syn_main2.sbv(2),bd.syn_main2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.syn_main1.bv(2),fe.syn_main1.bv(3),fe.syn_main1.bv(4),fe.syn_main1.R2v,bd.syn_main1.bv(2),bd.syn_main1.bv(3),bd.syn_main1.bv(4),bd.syn_main1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',fe.syn_main1.sbv(2),fe.syn_main1.sbv(3),fe.syn_main1.sbv(4),'',bd.syn_main1.sbv(2),bd.syn_main1.sbv(3),bd.syn_main1.sbv(4),'');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Subjective income','',fe.inc_main2.bv(2),fe.inc_main2.bv(3),fe.inc_main2.R2v,'',bd.inc_main2.bv(2),bd.inc_main2.bv(3),bd.inc_main2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.inc_main2.sbv(2),fe.inc_main2.sbv(3),'','',bd.inc_main2.sbv(2),bd.inc_main2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.inc_main1.bv(2),fe.inc_main1.bv(3),fe.inc_main1.bv(4),fe.inc_main1.R2v,bd.inc_main1.bv(2),bd.inc_main1.bv(3),bd.inc_main1.bv(4),bd.inc_main1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\\cmidrule(lr){2-9}\n','',fe.inc_main1.sbv(2),fe.inc_main1.sbv(3),fe.inc_main1.sbv(4),'',bd.inc_main1.sbv(2),bd.inc_main1.sbv(3),bd.inc_main1.sbv(4),'');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-9}\n','','\multicolumn{6}{c}{Long sample: 1991:Q1 to 2021:Q4}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic returns','',fe.syn_long2.bv(2),fe.syn_long2.bv(3),fe.syn_long2.R2v,'',bd.syn_long2.bv(2),bd.syn_long2.bv(3),bd.syn_long2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.syn_long2.sbv(2),fe.syn_long2.sbv(3),'','',bd.syn_long2.sbv(2),bd.syn_long2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.syn_long1.bv(2),fe.syn_long1.bv(3),fe.syn_long1.bv(4),fe.syn_long1.R2v,bd.syn_long1.bv(2),bd.syn_long1.bv(3),bd.syn_long1.bv(4),bd.syn_long1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',fe.syn_long1.sbv(2),fe.syn_long1.sbv(3),fe.syn_long1.sbv(4),'',bd.syn_long1.sbv(2),bd.syn_long1.sbv(3),bd.syn_long1.sbv(4),'');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Subjective income','',fe.inc_long2.bv(2),fe.inc_long2.bv(3),fe.inc_long2.R2v,'',bd.inc_long2.bv(2),bd.inc_long2.bv(3),bd.inc_long2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.inc_long2.sbv(2),fe.inc_long2.sbv(3),'','',bd.inc_long2.sbv(2),bd.inc_long2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.inc_long1.bv(2),fe.inc_long1.bv(3),fe.inc_long1.bv(4),fe.inc_long1.R2v,bd.inc_long1.bv(2),bd.inc_long1.bv(3),bd.inc_long1.bv(4),bd.inc_long1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\\cmidrule(lr){2-9}\n','',fe.inc_long1.sbv(2),fe.inc_long1.sbv(3),fe.inc_long1.sbv(4),'',bd.inc_long1.sbv(2),bd.inc_long1.sbv(3),bd.inc_long1.sbv(4),'');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-9}\n','','\multicolumn{6}{c}{Early sample: 1991:Q1 to 2006:Q4}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic returns','',fe.syn_early2.bv(2),fe.syn_early2.bv(3),fe.syn_early2.R2v,'',bd.syn_early2.bv(2),bd.syn_early2.bv(3),bd.syn_early2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.syn_early2.sbv(2),fe.syn_early2.sbv(3),'','',bd.syn_early2.sbv(2),bd.syn_early2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.syn_early1.bv(2),fe.syn_early1.bv(3),fe.syn_early1.bv(4),fe.syn_early1.R2v,bd.syn_early1.bv(2),bd.syn_early1.bv(3),bd.syn_early1.bv(4),bd.syn_early1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',fe.syn_early1.sbv(2),fe.syn_early1.sbv(3),fe.syn_early1.sbv(4),'',bd.syn_early1.sbv(2),bd.syn_early1.sbv(3),bd.syn_early1.sbv(4),'');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %s & %.2f & %.2f & %.2f \\\\\n','Subjective income','',fe.inc_early2.bv(2),fe.inc_early2.bv(3),fe.inc_early2.R2v,'',bd.inc_early2.bv(2),bd.inc_early2.bv(3),bd.inc_early2.R2v);
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & %s & %s & (%.2f) & (%.2f) & %s \\\\\n','','',fe.inc_early2.sbv(2),fe.inc_early2.sbv(3),'','',bd.inc_early2.sbv(2),bd.inc_early2.sbv(3),'');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','',fe.inc_early1.bv(2),fe.inc_early1.bv(3),fe.inc_early1.bv(4),fe.inc_early1.R2v,bd.inc_early1.bv(2),bd.inc_early1.bv(3),bd.inc_early1.bv(4),bd.inc_early1.R2v);
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & %s & (%.2f) & (%.2f) & (%.2f) & %s \\\\\n','',fe.inc_early1.sbv(2),fe.inc_early1.sbv(3),fe.inc_early1.sbv(4),'',bd.inc_early1.sbv(2),bd.inc_early1.sbv(3),bd.inc_early1.sbv(4),'');
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')