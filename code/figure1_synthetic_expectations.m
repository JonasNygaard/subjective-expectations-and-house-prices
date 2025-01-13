%% Replicating Figure 1

% Housekeeping
close all
clear
clc
rng(77)

% Loading data
load ../data/mat/housingData.mat

% Estimating synthetic expectations
[coef,fitInfo]      = lasso(michiganData.reason(359:end,2:end),michiganData.mret(37:end,2),'CV',10,'Alpha',0.5);
varIdx              = find(coef(:,fitInfo.Index1SE) ~= 0);
parms               = [ones(144,1) michiganData.reason(359:end,1+varIdx)]\michiganData.mret(37:end,2);
synth               = michiganData.reason(:,1+varIdx)*parms(2:end)+parms(1);

% Computing R-squared and correlation for training and test sample
resTrain            = nwRegress(michiganData.mret(37:end,2),synth(359:end,1),1,6);
resTest             = nwRegress(michiganData.mret(1:36,2),synth(323:358,1),1,6);
corrTrain           = corr(michiganData.mret(37:end,2),synth(359:end,1));
corrTest            = corr(michiganData.mret(1:36,2),synth(323:358,1));

% Create datetime vectors for graphs
dates               = (datetime(1980,3,31) + calmonths(0:167*3))';

% Creating figure
figure;
t = tiledlayout(2,1);
nexttile(t)
p1 = plot(dates(323:end,1),[michiganData.mret(:,2) [NaN(36,1); synth(359:end,1)] [synth(323:359,1); NaN(143,1)]]);
p1(1).Color = colorBrewer(7);
p1(2).Color = colorBrewer(1);
p1(3).Color = colorBrewer(2);
p1(1).LineWidth = 1.8;
p1(2).LineWidth = 1.4;
p1(3).LineWidth = 1.4;
recessionplot()
xtickformat('yyyy');
title('Survey-based and synthetic expectations: 2007:M01 to 2021:M12','FontWeight','Normal');
leg = legend('Survey','Train','Test');
set(leg,'Box','Off','Location','Best');
text(1000,5,strcat('R$^{2}_{\mathrm{Train}}$=',num2str(round(resTrain.R2v,2)),'$\%$'),'interpreter','latex');
text(1000,3,strcat('R$^{2}_{\mathrm{Test}}$=',num2str(round(resTest.R2v,2)),'$\%$'),'interpreter','latex');
text(1000,4.5,strcat('$\rho_{\mathrm{Train}}$=',num2str(round(corrTrain,2))),'interpreter','latex');
text(1000,2.5,strcat('$\rho_{\mathrm{Test}}$=',num2str(round(corrTest,2))),'interpreter','latex');
nexttile(t)
p1 = plot(dates,[[NaN(322,1); michiganData.mret(:,2)] [NaN(358,1); synth(359:end,1)] [NaN(322,1); synth(323:358,1); NaN(144,1)] [synth(1:323,1); NaN(179,1)]]);
p1(1).Color = colorBrewer(7);
p1(2).Color = colorBrewer(1);
p1(3).Color = colorBrewer(2);
p1(4).Color = colorBrewer(3);
p1(1).LineWidth = 1.8;
p1(2).LineWidth = 1.4;
p1(3).LineWidth = 1.4;
p1(4).LineWidth = 1.4;
recessionplot()
xtickformat('yyyy');
title('Survey-based and synthetic expectations: 2007:M1 to 2021:M12','FontWeight','Normal');
leg = legend('Survey','Train','Test','Backfill');
set(leg,'Box','Off','Location','SouthEast');
title('Survey-based and synthetic expectations: 1980:M3 to 2021:M12','FontWeight','Normal');
ylabel(t,'One-year expected housing returns');
exportgraphics(gcf,'../output/figure1_synthetic_expectations.pdf','ContentType','vector');

disp('Done');