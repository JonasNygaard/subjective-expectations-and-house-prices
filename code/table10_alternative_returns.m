%% Replicating Table 10

% Housekppeing
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Compute constants for the log-linearization
pr_mean             = mean(log(housData.pr));             % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter
decay_regression    = nwRegress(michiganData.hret5_alt(:,2),michiganData.hret1_alt(:,2),1,6);
phi_h               = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h^3;
se_phi_h            = decay_regression.sbv(2)/grad;
coeff_h             = 1/(1-rho*phi_h);
grad_coeff_h        = abs(rho*(1/(1-rho*phi_h)^2));
se_coeff_h          = se_phi_h*grad_coeff_h;

% Estimate one-year and full-horizon subjective decompositions
sub_decomp_main     = subjective_decomposition(michiganData.hret1_alt(:,2)./100,michiganData.income(109:end,2)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);
sub_decomp_main_s   = subjective_decomposition(michiganData.ssynth_alt(:,2)./100,michiganData.income(109:end,2)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);
sub_decomp_long     = subjective_decomposition(michiganData.lsynth_alt(:,2)./100,michiganData.income(1:end,2)./100,log(housData.py(1:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);
sub_decomp_early    = subjective_decomposition(michiganData.lsynth_alt(1:108,2)./100,michiganData.income(1:108,2)./100,log(housData.py(1:108,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);

% Creating table with results
fid = fopen('../output/table10_alternative_returns.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','Sample','CF$_{1}$','DR$_{1}$','LT');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007:Q1 to 2021:Q4',sub_decomp_main.CF1(1),sub_decomp_main.DR1(1),sub_decomp_main.LT(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main.CF1(2),sub_decomp_main.DR1(2),sub_decomp_main.LT(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic','2007:Q1 to 2021:Q4',sub_decomp_main_s.CF1(1),sub_decomp_main_s.DR1(1),sub_decomp_main_s.LT(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main_s.CF1(2),sub_decomp_main_s.DR1(2),sub_decomp_main_s.LT(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic','1980:Q1 to 2021:Q4',sub_decomp_long.CF1(1),sub_decomp_long.DR1(1),sub_decomp_long.LT(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_long.CF1(2),sub_decomp_long.DR1(2),sub_decomp_long.LT(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Synthetic','1980:Q1 to 2006:Q4',sub_decomp_early.CF1(1),sub_decomp_early.DR1(1),sub_decomp_early.LT(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\\midrule\n','','',sub_decomp_early.CF1(2),sub_decomp_early.DR1(2),sub_decomp_early.LT(2));
fprintf(fid, '%s \\\\\\midrule\n','\multicolumn{5}{c}{Panel B: Full-horizon decomposition}');
fprintf(fid, '%s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','Sample','$\phi_{h}$','CF','DR');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007:Q1 to 2021:Q4',phi_h,sub_decomp_main.CF(1),sub_decomp_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',se_phi_h,sub_decomp_main.CF(2),sub_decomp_main.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','2007:Q1 to 2021:Q4','',sub_decomp_main_s.CF(1),sub_decomp_main_s.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',sub_decomp_main_s.CF(2),sub_decomp_main_s.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980:Q1 to 2021:Q4','',sub_decomp_long.CF(1),sub_decomp_long.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',sub_decomp_long.CF(2),sub_decomp_long.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980:Q1 to 2006:Q4','',sub_decomp_early.CF(1),sub_decomp_early.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',sub_decomp_early.CF(2),sub_decomp_early.DR(2));
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')