%% Replicating Figure 3

% Housekeeping
close all
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Create datetime vectors for graphs
dates           = (datetime(1980,3,31) + calmonths(0:3:167*3))';

% Computing forecast errors
forecast_errors     = -[
    [NaN(4,1); housData.changes(5:end,1) - [NaN(108,1); michiganData.hret1(1:end-4,2)]] ... 
    [NaN(4,1); housData.changes(5:end,1) - michiganData.lsynth(1:end-4,2)] ...
    [NaN(4,1); housData.igrowth(5:end,1) - michiganData.income(1:end-4,2)] ...
];

% Computing belief distortions for main sample
z               = [housData.igrowth./100 housData.changes./100 log(housData.py)];
res_var_main    = nwRegress(z(109+4:end,:),z(109:end-4,:),1,6);
B               = res_var_main.bv(1,:)';
A               = res_var_main.bv(2:end,:)';
z_hat_main      = (B + A*z(1:end,:)')';

% Computing belief distortions for full sample
res_var_long    = nwRegress(z(5:end,:),z(1:end-4,:),1,6);
B               = res_var_long.bv(1,:)';
A               = res_var_long.bv(2:end,:)';
z_hat_long      = (B + A*z(1:end,:)')';

% Collecting belief distortions
belief_distortions = -[
    z_hat_main(:,2).*100 - [NaN(108,1); michiganData.hret1(1:end,2)] ... 
    z_hat_long(:,2).*100 - michiganData.lsynth(1:end,2) ...
    z_hat_long(:,1).*100 - michiganData.income(1:end,2) ...
];

% Creating figure
figure;
t = tiledlayout(2,1);
nexttile(t)
p1 = plot(dates(5:end,1),forecast_errors(5:end,:));
p1(1).Color = colorBrewer(1);
p1(2).Color = colorBrewer(2);
p1(3).Color = colorBrewer(3);
p1(1).LineWidth = 1.6;
p1(2).LineWidth = 1.6;
p1(3).LineWidth = 1.6;
p1(2).LineStyle = '--';
recessionplot()
xtickformat('yyyy');
ylabel('Differences');
title('Forecast errors','FontWeight','Normal');
nexttile(t)
p1 = plot(dates(5:end,1),belief_distortions(5:end,:));
p1(1).Color = colorBrewer(1);
p1(2).Color = colorBrewer(2);
p1(3).Color = colorBrewer(3);
p1(1).LineWidth = 1.6;
p1(2).LineWidth = 1.6;
p1(3).LineWidth = 1.6;
p1(2).LineStyle = '--';
recessionplot()
xtickformat('yyyy');
ylabel('Differences');
title('Belief distortions','FontWeight','Normal');
leg = legend('Housing returns (actual)','Housing returns (synthetic)','Income growth');
set(leg,'Box','Off','Location','NorthWest');
exportgraphics(gcf,'../output/figure3_expectational_errors.pdf','ContentType','vector');

disp('Done');