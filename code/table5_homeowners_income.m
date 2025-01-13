%% Replicating Table 5

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Compute constants for the log-linearization
pr_mean             = mean(log(housData.pr));             % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter
decay_regression    = nwRegress(michiganData.hret5(:,2),michiganData.hret1(:,2),1,6);
phi_h               = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h^3;
se_phi_h            = decay_regression.sbv(2)/grad;
coeff_h             = 1/(1-rho*phi_h);
grad_coeff_h        = abs(rho*(1/(1-rho*phi_h)^2));
se_coeff_h          = se_phi_h*grad_coeff_h;

% Estimate one-year and full-horizon subjective decompositions
sub_decomp_main     = subjective_decomposition(michiganData.hret1(:,2)./100,michiganData.income(109:end,2)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);
sub_decomp_main1     = subjective_decomposition(michiganData.hret1(:,2)./100,michiganData.owner_inc(:,2)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);

% Estimate decay function and phi_h parameter for income-weighted returns
decay_regression    = nwRegress(sdaData.hret5_income(351:3:528,1),sdaData.hret1_income(351:3:528,1),1,6);
phi_h               = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h^3;
se_phi_h            = decay_regression.sbv(2)/grad;
coeff_h             = 1/(1-rho*phi_h);
grad_coeff_h        = abs(rho*(1/(1-rho*phi_h)^2));
se_coeff_h          = se_phi_h*grad_coeff_h;

% Estimate one-year and full-horizon subjective decompositions
sub_decomp_main2    = subjective_decomposition(sdaData.hret1_income(351:3:528,1)./100,sdaData.income_income(351:3:528,1)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);
sub_decomp_main3    = subjective_decomposition(sdaData.hret1_income(351:3:528,1)./100,sdaData.income_income1(351:3:528,1)./100,log(housData.py(109:end,1)),kappa,rho,phi_h,coeff_h,se_coeff_h);

% Creating table
fid = fopen('../output/table5_owners_income.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','Sample','CF$_{1}$','DR$_{1}$','LT','CF','DR');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','All','2007:Q1 to 2021:Q4',sub_decomp_main.CF1(1),sub_decomp_main.DR1(1),sub_decomp_main.LT(1),sub_decomp_main.CF(1),sub_decomp_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main.CF1(2),sub_decomp_main.DR1(2),sub_decomp_main.LT(2),sub_decomp_main.CF(2),sub_decomp_main.DR(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Homeowners','2007:Q1 to 2021:Q4',sub_decomp_main1.CF1(1),sub_decomp_main1.DR1(1),sub_decomp_main1.LT(1),sub_decomp_main1.CF(1),sub_decomp_main1.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main1.CF1(2),sub_decomp_main1.DR1(2),sub_decomp_main1.LT(2),sub_decomp_main1.CF(2),sub_decomp_main1.DR(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Income-weighted','2007:Q1 to 2021:Q4',sub_decomp_main2.CF1(1),sub_decomp_main2.DR1(1),sub_decomp_main2.LT(1),sub_decomp_main2.CF(1),sub_decomp_main2.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main2.CF1(2),sub_decomp_main2.DR1(2),sub_decomp_main2.LT(2),sub_decomp_main2.CF(2),sub_decomp_main2.DR(2));
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Income-weighted (owners)','2007:Q1 to 2021:Q4',sub_decomp_main3.CF1(1),sub_decomp_main3.DR1(1),sub_decomp_main3.LT(1),sub_decomp_main3.CF(1),sub_decomp_main3.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',sub_decomp_main3.CF1(2),sub_decomp_main3.DR1(2),sub_decomp_main3.LT(2),sub_decomp_main3.CF(2),sub_decomp_main3.DR(2));
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')