%% Replicating Table 6

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Compute constants for the log-linearization
pr_mean             = mean(log(regionData.py(:,2)));      % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter for West region
decay_regression    = nwRegress(regionData.we.hret5(:,2),regionData.we.hret1(:,2),1,6);
phi_h1              = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h1^3;
se_phi_h1           = decay_regression.sbv(2)/grad;
coeff_h1            = 1/(1-rho*phi_h1);
grad_coeff_h1       = abs(rho*(1/(1-rho*phi_h1)^2));
se_coeff_h1         = se_phi_h1*grad_coeff_h1;

% Estimating subjective decomposition for West region
decomp_we_main     = subjective_decomposition(regionData.we.hret1(3:4:end,2)./100,regionData.we.income(111:4:end,2)./100,log(regionData.py(28:end,2)),kappa,rho,phi_h1,coeff_h1,se_coeff_h1);
decomp_we_main_s   = subjective_decomposition(regionData.we.ssynth(3:4:end,2)./100,regionData.we.income(111:4:end,2)./100,log(regionData.py(28:end,2)),kappa,rho,phi_h1,coeff_h1,se_coeff_h1);
decomp_we_long     = subjective_decomposition(regionData.we.lsynth(3:4:end,2)./100,regionData.we.income(3:4:end,2)./100,log(regionData.py(1:end,2)),kappa,rho,phi_h1,coeff_h1,se_coeff_h1);
decomp_we_early    = subjective_decomposition(regionData.we.lsynth(3:4:107,2)./100,regionData.we.income(3:4:107,2)./100,log(regionData.py(1:27,2)),kappa,rho,phi_h1,coeff_h1,se_coeff_h1);

% Compute constants for the log-linearization
pr_mean             = mean(log(regionData.py(:,4)));      % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter for Midwest region
decay_regression            = nwRegress(regionData.nc.hret5(:,2),regionData.nc.hret1(:,2),1,6);
phi_h2              = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h2^3;
se_phi_h2           = decay_regression.sbv(2)/grad;
coeff_h2            = 1/(1-rho*phi_h2);
grad_coeff_h2       = abs(rho*(1/(1-rho*phi_h2)^2));
se_coeff_h2         = se_phi_h2*grad_coeff_h2;

% Estimating subjective decomposition for Midwest region
decomp_nc_main     = subjective_decomposition(regionData.nc.hret1(3:4:end,2)./100,regionData.nc.income(111:4:end,2)./100,log(regionData.py(28:end,4)),kappa,rho,phi_h2,coeff_h2,se_coeff_h2);
decomp_nc_main_s   = subjective_decomposition(regionData.nc.ssynth(3:4:end,2)./100,regionData.nc.income(111:4:end,2)./100,log(regionData.py(28:end,4)),kappa,rho,phi_h2,coeff_h2,se_coeff_h2);
decomp_nc_long     = subjective_decomposition(regionData.nc.lsynth(3:4:end,2)./100,regionData.nc.income(3:4:end,2)./100,log(regionData.py(1:end,4)),kappa,rho,phi_h2,coeff_h2,se_coeff_h2);
decomp_nc_early    = subjective_decomposition(regionData.nc.lsynth(3:4:107,2)./100,regionData.nc.income(3:4:107,2)./100,log(regionData.py(1:27,4)),kappa,rho,phi_h2,coeff_h2,se_coeff_h2);

% Compute constants for the log-linearization
pr_mean             = mean(log(regionData.py(:,3)));      % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter for Northeast region
decay_regression    = nwRegress(regionData.ne.hret5(:,2),regionData.ne.hret1(:,2),1,6);
phi_h3              = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h3^3;
se_phi_h3           = decay_regression.sbv(2)/grad;
coeff_h3            = 1/(1-rho*phi_h3);
grad_coeff_h3       = abs(rho*(1/(1-rho*phi_h3)^2));
se_coeff_h3         = se_phi_h3*grad_coeff_h3;

% Estimating subjective decomposition for Northeast region
decomp_ne_main     = subjective_decomposition(regionData.ne.hret1(3:4:end,2)./100,regionData.ne.income(111:4:end,2)./100,log(regionData.py(28:end,3)),kappa,rho,phi_h3,coeff_h3,se_coeff_h3);
decomp_ne_main_s   = subjective_decomposition(regionData.ne.ssynth(3:4:end,2)./100,regionData.ne.income(111:4:end,2)./100,log(regionData.py(28:end,3)),kappa,rho,phi_h3,coeff_h3,se_coeff_h3);
decomp_ne_long     = subjective_decomposition(regionData.ne.lsynth(3:4:end,2)./100,regionData.ne.income(3:4:end,2)./100,log(regionData.py(1:end,3)),kappa,rho,phi_h3,coeff_h3,se_coeff_h3);
decomp_ne_early    = subjective_decomposition(regionData.ne.lsynth(3:4:107,2)./100,regionData.ne.income(3:4:107,2)./100,log(regionData.py(1:27,3)),kappa,rho,phi_h3,coeff_h3,se_coeff_h3);

% Compute constants for the log-linearization
pr_mean             = mean(log(regionData.py(:,1)));      % Mean log price-rent ratio
rho                 = exp(pr_mean)/(1+exp(pr_mean));      % rho
kappa               = log(1+exp(pr_mean))-rho*pr_mean;    % kappa

% Estimate decay function and phi_h parameter for South region
decay_regression    = nwRegress(regionData.so.hret5(:,2),regionData.so.hret1(:,2),1,6);
phi_h4              = decay_regression.bv(2)^(1/4);
grad                = 4*phi_h4^3;
se_phi_h4           = decay_regression.sbv(2)/grad;
coeff_h4            = 1/(1-rho*phi_h4);
grad_coeff_h4       = abs(rho*(1/(1-rho*phi_h4)^2));
se_coeff_h4         = se_phi_h4*grad_coeff_h4;

% Estimating subjective decomposition for South region
decomp_so_main     = subjective_decomposition(regionData.so.hret1(3:4:end,2)./100,regionData.so.income(111:4:end,2)./100,log(regionData.py(28:end,1)),kappa,rho,phi_h4,coeff_h4,se_coeff_h4);
decomp_so_main_s   = subjective_decomposition(regionData.so.ssynth(3:4:end,2)./100,regionData.so.income(111:4:end,2)./100,log(regionData.py(28:end,1)),kappa,rho,phi_h4,coeff_h4,se_coeff_h4);
decomp_so_long     = subjective_decomposition(regionData.so.lsynth(3:4:end,2)./100,regionData.so.income(3:4:end,2)./100,log(regionData.py(1:end,1)),kappa,rho,phi_h4,coeff_h4,se_coeff_h4);
decomp_so_early    = subjective_decomposition(regionData.so.lsynth(3:4:107,2)./100,regionData.so.income(3:4:107,2)./100,log(regionData.py(1:27,1)),kappa,rho,phi_h4,coeff_h4,se_coeff_h4);

% Writing age group results to LaTeX table
fid = fopen('../output/table6_regional_decomposition.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','Sample','$\phi_{h}$','CF','DR');
fprintf(fid, '%s \\\\\\midrule\n','\multicolumn{5}{c}{Panel A: Northeast}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007 to 2021',phi_h3,decomp_ne_main.CF(1),decomp_ne_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',se_phi_h3,decomp_ne_main.CF(2),decomp_ne_main.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','2007 to 2021','',decomp_ne_main_s.CF(1),decomp_ne_main_s.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_ne_main_s.CF(2),decomp_ne_main_s.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2021','',decomp_ne_long.CF(1),decomp_ne_long.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_ne_long.CF(2),decomp_ne_long.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2006','',decomp_ne_early.CF(1),decomp_ne_early.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\\midrule\n','','','',decomp_ne_early.CF(2),decomp_ne_early.DR(2));
fprintf(fid, '%s \\\\\\midrule\n','\multicolumn{5}{c}{Panel B: Midwest}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007 to 2021',phi_h2,decomp_nc_main.CF(1),decomp_nc_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',se_phi_h2,decomp_nc_main.CF(2),decomp_nc_main.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','2007 to 2021','',decomp_nc_main_s.CF(1),decomp_nc_main_s.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_nc_main_s.CF(2),decomp_nc_main_s.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2021','',decomp_nc_long.CF(1),decomp_nc_long.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_nc_long.CF(2),decomp_nc_long.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2006','',decomp_nc_early.CF(1),decomp_nc_early.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\\midrule\n','','','',decomp_nc_early.CF(2),decomp_nc_early.DR(2));
fprintf(fid, '%s \\\\\\midrule\n','\multicolumn{5}{c}{Panel C: South}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007 to 2021',phi_h4,decomp_so_main.CF(1),decomp_so_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',se_phi_h4,decomp_so_main.CF(2),decomp_so_main.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','2007 to 2021','',decomp_so_main_s.CF(1),decomp_so_main_s.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_so_main_s.CF(2),decomp_so_main_s.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2021','',decomp_so_long.CF(1),decomp_so_long.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_so_long.CF(2),decomp_so_long.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2006','',decomp_so_early.CF(1),decomp_so_early.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\\midrule\n','','','',decomp_so_early.CF(2),decomp_so_early.DR(2));
fprintf(fid, '%s \\\\\\midrule\n','\multicolumn{5}{c}{Panel D: West}');
fprintf(fid, '%s & %s & %.2f & %.2f & %.2f \\\\\n','Subjective','2007 to 2021',phi_h1,decomp_we_main.CF(1),decomp_we_main.DR(1));
fprintf(fid, '%s & %s & (%.2f) & (%.2f) & (%.2f) \\\\\n','','',se_phi_h1,decomp_we_main.CF(2),decomp_we_main.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','2007 to 2021','',decomp_we_main_s.CF(1),decomp_we_main_s.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_we_main_s.CF(2),decomp_we_main_s.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2021','',decomp_we_long.CF(1),decomp_we_long.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_we_long.CF(2),decomp_we_long.DR(2));
fprintf(fid, '%s & %s & %s & %.2f & %.2f \\\\\n','Synthetic','1980 to 2006','',decomp_we_early.CF(1),decomp_we_early.DR(1));
fprintf(fid, '%s & %s & %s & (%.2f) & (%.2f) \\\\\n','','','',decomp_we_early.CF(2),decomp_we_early.DR(2));
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')