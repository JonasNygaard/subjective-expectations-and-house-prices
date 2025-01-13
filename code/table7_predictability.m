%% Replicating Table 7

% Housekeeping
clear
clc

% Loading data
load ../data/mat/housingData.mat

% Collecting subjective expectations
survey_expectations     = [
    [NaN(108,1); michiganData.hret1(:,2)] ... 
    michiganData.lsynth(:,2) ...
    michiganData.income(:,2) ...
]./100;

% Running predictability regressions in the main sample
pred.main1      = nwRegress(survey_expectations(109:end,:),log(housData.py(108:end-1,1)),1,6);
pred.main2      = nwRegress(survey_expectations(110:end,:),log(housData.py(108:end-2,1)),1,6);
pred.main3      = nwRegress(survey_expectations(111:end,:),log(housData.py(108:end-3,1)),1,6);
pred.main4      = nwRegress(survey_expectations(112:end,:),log(housData.py(108:end-4,1)),1,6);
pred.main5      = nwRegress(survey_expectations(113:end,:),log(housData.py(108:end-5,1)),1,6);
pred.main6      = nwRegress(survey_expectations(114:end,:),log(housData.py(108:end-6,1)),1,6);

% Running predictability regressions in the full sample
pred.long1      = nwRegress(survey_expectations(2:end,:),log(housData.py(1:end-1,1)),1,6);
pred.long2      = nwRegress(survey_expectations(3:end,:),log(housData.py(1:end-2,1)),1,6);
pred.long3      = nwRegress(survey_expectations(4:end,:),log(housData.py(1:end-3,1)),1,6);
pred.long4      = nwRegress(survey_expectations(5:end,:),log(housData.py(1:end-4,1)),1,6);
pred.long5      = nwRegress(survey_expectations(6:end,:),log(housData.py(1:end-5,1)),1,6);
pred.long6      = nwRegress(survey_expectations(7:end,:),log(housData.py(1:end-6,1)),1,6);

% Running predictability regressions in the early sample
pred.early1     = nwRegress(survey_expectations(2:108,:),log(housData.py(1:108-1,1)),1,6);
pred.early2     = nwRegress(survey_expectations(3:108,:),log(housData.py(1:108-2,1)),1,6);
pred.early3     = nwRegress(survey_expectations(4:108,:),log(housData.py(1:108-3,1)),1,6);
pred.early4     = nwRegress(survey_expectations(5:108,:),log(housData.py(1:108-4,1)),1,6);
pred.early5     = nwRegress(survey_expectations(6:108,:),log(housData.py(1:108-5,1)),1,6);
pred.early6     = nwRegress(survey_expectations(7:108,:),log(housData.py(1:108-6,1)),1,6);

% Creating table with results
fid = fopen('../output/table7_predictability.tex','w');
fprintf(fid, '%s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Expectations','$q = 1$','$q = 2$','$q = 3$','$q = 4$','$q = 5$','$q = 6$');
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Main sample: 2007:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective returns',pred.main1.bv(2,1),pred.main2.bv(2,1),pred.main3.bv(2,1),pred.main4.bv(2,1),pred.main5.bv(2,1),pred.main6.bv(2,1));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.main1.sbv(2,1),pred.main2.sbv(2,1),pred.main3.sbv(2,1),pred.main4.sbv(2,1),pred.main5.sbv(2,1),pred.main6.sbv(2,1));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',pred.main1.R2v(1),pred.main2.R2v(1),pred.main3.R2v(1),pred.main4.R2v(1),pred.main5.R2v(1),pred.main6.R2v(1));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',pred.main1.bv(2,2),pred.main2.bv(2,2),pred.main3.bv(2,2),pred.main4.bv(2,2),pred.main5.bv(2,2),pred.main6.bv(2,2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.main1.sbv(2,2),pred.main2.sbv(2,2),pred.main3.sbv(2,2),pred.main4.sbv(2,2),pred.main5.sbv(2,2),pred.main6.sbv(2,2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',pred.main1.R2v(2),pred.main2.R2v(2),pred.main3.R2v(2),pred.main4.R2v(2),pred.main5.R2v(2),pred.main6.R2v(2));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',pred.main1.bv(2,3),pred.main2.bv(2,3),pred.main3.bv(2,3),pred.main4.bv(2,3),pred.main5.bv(2,3),pred.main6.bv(2,3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.main1.sbv(2,3),pred.main2.sbv(2,3),pred.main3.sbv(2,3),pred.main4.sbv(2,3),pred.main5.sbv(2,3),pred.main6.sbv(2,3));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\cmidrule(lr){2-7}\n','',pred.main1.R2v(3),pred.main2.R2v(3),pred.main3.R2v(3),pred.main4.R2v(3),pred.main5.R2v(3),pred.main6.R2v(3));
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Long sample: 1980:Q1 to 2021:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',pred.long1.bv(2,2),pred.long2.bv(2,2),pred.long3.bv(2,2),pred.long4.bv(2,2),pred.long5.bv(2,2),pred.long6.bv(2,2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.long1.sbv(2,2),pred.long2.sbv(2,2),pred.long3.sbv(2,2),pred.long4.sbv(2,2),pred.long5.sbv(2,2),pred.long6.sbv(2,2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',pred.long1.R2v(2),pred.long2.R2v(2),pred.long3.R2v(2),pred.long4.R2v(2),pred.long5.R2v(2),pred.long6.R2v(2));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',pred.long1.bv(2,3),pred.long2.bv(2,3),pred.long3.bv(2,3),pred.long4.bv(2,3),pred.long5.bv(2,3),pred.long6.bv(2,3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.long1.sbv(2,3),pred.long2.sbv(2,3),pred.long3.sbv(2,3),pred.long4.sbv(2,3),pred.long5.sbv(2,3),pred.long6.sbv(2,3));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\cmidrule(lr){2-7}\n','',pred.long1.R2v(3),pred.long2.R2v(3),pred.long3.R2v(3),pred.long4.R2v(3),pred.long5.R2v(3),pred.long6.R2v(3));
fprintf(fid, '%s & %s \\\\\\cmidrule(lr){2-7}\n','','\multicolumn{6}{c}{Early sample: 1980:Q1 to 2006:Q4}');
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Synthetic returns',pred.early1.bv(2,2),pred.early2.bv(2,2),pred.early3.bv(2,2),pred.early4.bv(2,2),pred.early5.bv(2,2),pred.early6.bv(2,2));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.early1.sbv(2,2),pred.early2.sbv(2,2),pred.early3.sbv(2,2),pred.early4.sbv(2,2),pred.early5.sbv(2,2),pred.early6.sbv(2,2));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',pred.early1.R2v(2),pred.early2.R2v(2),pred.early3.R2v(2),pred.early4.R2v(2),pred.early5.R2v(2),pred.early6.R2v(2));
fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Subjective income',pred.early1.bv(2,3),pred.early2.bv(2,3),pred.early3.bv(2,3),pred.early4.bv(2,3),pred.early5.bv(2,3),pred.early6.bv(2,3));
fprintf(fid, '%s & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) & (%.2f) \\\\\n','',pred.early1.sbv(2,3),pred.early2.sbv(2,3),pred.early3.sbv(2,3),pred.early4.sbv(2,3),pred.early5.sbv(2,3),pred.early6.sbv(2,3));
fprintf(fid, '%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',pred.early1.R2v(3),pred.early2.R2v(3),pred.early3.R2v(3),pred.early4.R2v(3),pred.early5.R2v(3),pred.early6.R2v(3));
fprintf(fid,'\\bottomrule');
fclose(fid);

disp('Done')