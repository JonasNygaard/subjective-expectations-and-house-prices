%% Replicating Figure 2

% Housekeeping
close all
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Create datetime vectors for graphs
dates               = (datetime(1980,3,31) + calmonths(0:3:167*3))';

% Creating figure for subjective expectations
t = tiledlayout(2,1);
nexttile(t)
p1 = plot(dates,[housData.changes [NaN(108,1); michiganData.hret1(:,2)] michiganData.lsynth(:,2)]);
p1(1).Color = colorBrewer(1);
p1(2).Color = colorBrewer(2);
p1(3).Color = colorBrewer(3);
p1(1).LineWidth = 1.6;
p1(2).LineWidth = 1.6;
p1(3).LineWidth = 1.6;
recessionplot()
xtickformat('yyyy');
ylabel('Housing returns');
title('Expected and realized housing returns','FontWeight','Normal');
leg = legend('Realized','Subjective','Synthetic');
set(leg,'Box','Off','Location','NorthEast');
nexttile(t)
p1 = plot(dates,[housData.igrowth michiganData.income(:,2)]);
p1(1).Color = colorBrewer(1);
p1(2).Color = colorBrewer(2);
p1(1).LineWidth = 1.6;
p1(2).LineWidth = 1.6;
recessionplot()
xtickformat('yyyy');
ylabel('Income growth');
title('Expected and realized income growth','FontWeight','Normal');
leg = legend('Realized','Subjective');
set(leg,'Box','Off','Location','NorthEast');
exportgraphics(gcf,'../output/figure2_subjective_expectations.pdf','ContentType','vector');

disp('Done');