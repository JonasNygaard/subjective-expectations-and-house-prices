%% makeData.m
% ########################################################################### % 
% This script loads and processes the raw data and stores in a matfile        %
%                                                                             %
% Written by:                                                                 %
% Jeppe Bro, ATP                                                              %
% Jonas N. Eriksen, Aarhus University                                         %
%                                                                             %
% Encoding: UTF8                                                              %
% Last modified: January 2025                                                 %
% ########################################################################### %

clear; clc; tStart = tic; close all; 
disp('| ################################################################## |');
disp('| Running the main_banz.m script                                      ');
fprintf('| Code initiated: %s \n',datetime("now")                            );
disp('| ################################################################## |');
rng(77)

%% Reading in and storing OECD house price data
% ########################################################################### % 
%{
    We collect US aggregrate housing data from the OECD housing database. 
    Data is available at: 
    https://www.oecd.org/en/data/indicators/housing-prices.html
%}
% ########################################################################### % 

disp('+ Reading in and storing OECD house price data');

% Loading OECD house price data
oecdData            = readtable('raw/oecd/oecdHousingData.csv');

% Picking out US variables for the analysis
housData.rprice     = table2array(oecdData((oecdData.LOCATION == "USA" & oecdData.FREQUENCY == "Q" & oecdData.SUBJECT == "REAL"),7));
housData.price      = table2array(oecdData((oecdData.LOCATION == "USA" & oecdData.FREQUENCY == "Q" & oecdData.SUBJECT == "NOMINAL"),7));
housData.pr         = table2array(oecdData((oecdData.LOCATION == "USA" & oecdData.FREQUENCY == "Q" & oecdData.SUBJECT == "PRICERENT"),7));
housData.py         = table2array(oecdData((oecdData.LOCATION == "USA" & oecdData.FREQUENCY == "Q" & oecdData.SUBJECT == "PRICEINCOME"),7));

% Backing out implied rent and income series
housData.rent       = housData.price./housData.pr;
housData.income     = housData.price./housData.py;

% Creating rent and income growth series 
rentGrowth          = housData.rent(2:end,1)./housData.rent(1:end-1,1);
incomeGrowth        = housData.income(2:end,1)./housData.income(1:end-1,1);

% Computing new rent and income series
newRent             = NaN(208,1);
newIncome           = NaN(208,1);
newRent(184,1)      = housData.price(184,1).*(1/((10.55+8.73)/2)); % Fixed to Numbeo data for 2015:Q4
newIncome(184,1)    = housData.price(184,1).*(1/(3.95)); % Fixed to Numbeo data for 2015:Q4

% Constructing series using 2015:Q4 as reference point
for iObs = 184:208

    newRent(iObs+1,1)    = newRent(iObs,:).*rentGrowth(iObs,:);
    newIncome(iObs+1,1)  = newIncome(iObs,1).*incomeGrowth(iObs,1);

end

for iObs = 184:-1:2

    newRent(iObs-1,1)    = newRent(iObs,:)./rentGrowth(iObs-1,:);
    newIncome(iObs-1,1)  = newIncome(iObs,1)./incomeGrowth(iObs-1,1);

end

% Storing the new series for analysis
housData.pr         = housData.price./newRent;
housData.py         = housData.price./newIncome;
housData.rent       = newRent;
housData.income     = newIncome;

% Computing annual house price changes
housData.changes    = [NaN(4,1); log(housData.price(5:end,1)./housData.price(1:end-4,1))].*100;

% Computing annual rent growth 
housData.rgrowth    = [NaN(4,1); log(housData.rent(5:end,1)./housData.rent(1:end-4,1))].*100;

% Computing annual income growth
housData.igrowth    = [NaN(4,1); log(housData.income(5:end,1)./housData.income(1:end-4,1))].*100;

% Adapting sample size 
names = fieldnames(housData);
for iStruct = 1:length(names)
    housData.(names{iStruct}) = housData.(names{iStruct})(41:end-1,:);
end


%% Reading in and storing subjective expectations
% ########################################################################### % 
%{
    We collect aggregrate survey expectations from the Michigan Survey of 
    Consumers (MSC) avaiable at: https://data.sca.isr.umich.edu/ 
%}
% ########################################################################### % 

disp('+ Reading in and storing subjective expectations');

% Loading Michican survey data
table13             = readmatrix('raw/msc/redbk13.xls');
table42             = readmatrix('raw/msc/redbk42.xls');
table46             = readmatrix('raw/msc/redbk46.xls');
table47             = readmatrix('raw/msc/redbk47.xls');

% Computing one- and five-year rent growth
rent_1year = [NaN(4,1); housData.rent(5:end,1)-housData.rent(1:end-4,1)];
rent_5year = [NaN(20,1); housData.rent(21:end,1)-housData.rent(1:end-20,1)];

% Storing Michigan survey data
michiganData.income     = table13(17:3:end-5,[2 14]);
michiganData.reason     = table42(86:end-6,[2 3:13]);
michiganData.mret       = table46(4:end-6,[2 12]);
michiganData.hret1      = table46(6:3:end-6,[2 12]);
michiganData.hret5      = table47(4:3:end-5,[2 12]);
michiganData.hret1_alt  = [table46(4:3:end-6,2) table46(4:3:end-6,12) + rent_1year(108:end-1,1)./housData.price(108:end-1,1)];
michiganData.hret5_alt  = [table47(4:3:end-5,2) table47(4:3:end-5,12) + rent_5year(108:end-1,1)./housData.price(108:end-1,1)];

% Creating synthetic housing return expectations
[coef,fitInfo]          = lasso(michiganData.reason(359:end,2:end),michiganData.mret(37:end,2),'CV',10,'Alpha',0.5);
varIdx                  = find(coef(:,fitInfo.Index1SE) ~= 0);
parms                   = [ones(144,1) michiganData.reason(359:end,1+varIdx)]\michiganData.mret(37:end,2);
michiganData.lsynth     = [michiganData.income(:,1) michiganData.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
michiganData.ssynth     = [michiganData.hret1(:,1) michiganData.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];

% Creating synthetic housing return expectations
[coef,fitInfo]          = lasso(michiganData.reason(361:3:end,2:end),michiganData.hret1_alt(13:end,2),'CV',10,'Alpha',0.5);
varIdx                  = find(coef(:,fitInfo.Index1SE) ~= 0);
parms                   = [ones(48,1) michiganData.reason(361:3:end,1+varIdx)]\michiganData.hret1_alt(13:end,2);
michiganData.lsynth_alt = [michiganData.income(:,1) michiganData.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
michiganData.ssynth_alt = [michiganData.hret1(:,1) michiganData.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];

% Loading data from MSC on owners (we thank the MSC for providing these data)
owner_data              = readmatrix('raw/msc/DemoHome_IncomeExpectations.xlsx','Sheet','All');
michiganData.owner_inc  = owner_data(187:3:364,33:34);

%% Reading in and storing survey data for regions
% ########################################################################### % 
%{
    We collect regioanl survey expectations from the Michigan Survey of 
    Consumers (MSC) avaiable at: https://data.sca.isr.umich.edu/ 
    Regional house prices are from FRED. 
%}
% ########################################################################### % 

disp('+ Reading in and storing survey data for regions');

% Loading regional house price indices
regionData.py           = readmatrix("raw/fred/four_regions_py_median.xlsx","Range","b29:e70");

% Loading Michigan for West region
table13we               = readmatrix('raw/msc/tbmw13.xls');
table42we               = readmatrix('raw/msc/tbmw42.xls');
table46we               = readmatrix('raw/msc/tbmw46.xls');
table47we               = readmatrix('raw/msc/tbmw47.xls');

regionData.we.reason    = table42we(6:end-6,[2 3:13]);
regionData.we.income    = table13we(3:3:end-5,[2 14]);
regionData.we.mret      = table46we(4:end-6,[2 12]);
regionData.we.hret1     = table46we(7:3:end-6,[2 12]);
regionData.we.hret5     = table47we(5:3:end-6,[2 12]);

% Loading Michigan for Midwest region
table13nc               = readmatrix('raw/msc/tbmnc13.xls');
table42nc               = readmatrix('raw/msc/tbmnc42.xls');
table46nc               = readmatrix('raw/msc/tbmnc46.xls');
table47nc               = readmatrix('raw/msc/tbmnc47.xls');

regionData.nc.reason    = table42nc(6:end-6,[2 3:13]);
regionData.nc.income    = table13nc(3:3:end-5,[2 14]);
regionData.nc.mret      = table46nc(4:end-6,[2 12]);
regionData.nc.hret1     = table46nc(7:3:end-6,[2 12]);
regionData.nc.hret5     = table47nc(5:3:end-6,[2 12]);

% Loading Michigan for Northeast region
table13ne               = readmatrix('raw/msc/tbmne13.xls');
table42ne               = readmatrix('raw/msc/tbmne42.xls');
table46ne               = readmatrix('raw/msc/tbmne46.xls');
table47ne               = readmatrix('raw/msc/tbmne47.xls');

regionData.ne.reason    = table42ne(6:end-6,[2 3:13]);
regionData.ne.income    = table13ne(3:3:end-5,[2 14]);
regionData.ne.mret      = table46ne(4:end-6,[2 12]);
regionData.ne.hret1     = table46ne(7:3:end-6,[2 12]);
regionData.ne.hret5     = table47ne(5:3:end-6,[2 12]);

% Loading Michigan for South region
table13so               = readmatrix('raw/msc/tbms13.xls');
table42so               = readmatrix('raw/msc/tbms42.xls');
table46so               = readmatrix('raw/msc/tbms46.xls');
table47so               = readmatrix('raw/msc/tbms47.xls');

regionData.so.reason    = table42so(6:end-6,[2 3:13]);
regionData.so.income    = table13so(3:3:end-5,[2 14]);
regionData.so.mret      = table46so(4:end-6,[2 12]);
regionData.so.hret1     = table46so(7:3:end-6,[2 12]);
regionData.so.hret5     = table47so(5:3:end-6,[2 12]);

% Creating synthetic housing return expectations for West region
[coef,fitInfo]      = lasso(regionData.we.reason(357:end,2:end),regionData.we.mret(36:end,2),'CV',10,'Alpha',0.5);
varIdx              = find(coef(:,fitInfo.Index1SE) ~= 0);
parms               = [ones(143,1) regionData.we.reason(357:end,1+varIdx)]\regionData.we.mret(36:end,2);
regionData.we.lsynth = [regionData.we.income(:,1) regionData.we.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
regionData.we.ssynth = [regionData.we.hret1(:,1) regionData.we.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];

% Creating synthetic housing return expectations for Midwest region
[coef,fitInfo]      = lasso(regionData.nc.reason(357:end,2:end),regionData.nc.mret(36:end,2),'CV',10,'Alpha',0.5);
varIdx              = find(coef(:,fitInfo.Index1SE) ~= 0);
parms               = [ones(143,1) regionData.nc.reason(357:end,1+varIdx)]\regionData.nc.mret(36:end,2);
regionData.nc.lsynth = [regionData.nc.income(:,1) regionData.nc.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
regionData.nc.ssynth = [regionData.nc.hret1(:,1) regionData.nc.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];

% Creating synthetic housing return expectations for Northeast region
[coef,fitInfo]      = lasso(regionData.ne.reason(357:end,2:end),regionData.ne.mret(36:end,2),'CV',10,'Alpha',0.5);
varIdx              = find(coef(:,fitInfo.Index1SE) ~= 0);
parms               = [ones(143,1) regionData.ne.reason(357:end,1+varIdx)]\regionData.ne.mret(36:end,2);
regionData.ne.lsynth = [regionData.ne.income(:,1) regionData.ne.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
regionData.ne.ssynth = [regionData.ne.hret1(:,1) regionData.ne.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];

% Creating synthetic housing return expectations for South region
[coef,fitInfo]      = lasso(regionData.so.reason(357:end,2:end),regionData.so.mret(36:end,2),'CV',10,'Alpha',0.5);
varIdx              = find(coef(:,fitInfo.Index1SE) ~= 0);
parms               = [ones(143,1) regionData.so.reason(357:end,1+varIdx)]\regionData.so.mret(36:end,2);
regionData.so.lsynth = [regionData.so.income(:,1) regionData.so.reason(1:3:end,1+varIdx)*parms(2:end)+parms(1)];
regionData.so.ssynth = [regionData.so.hret1(:,1) regionData.so.reason(325:3:end,1+varIdx)*parms(2:end)+parms(1)];


%% Reading in and storing MSC micro data
% ########################################################################### % 
%{
    We collect micro-level data from the MSC: https://sda.umsurvey.org/ 
%}
% ########################################################################### % 

disp('+ Reading in and storing MSC micro data');

% Load data
data        = readtable('raw/msc/survey_micro.csv');

% Determining unique dates
vDates      = unique(data.YYYYMM);
vID         = unique(data.ID);

% Preallocations prior to loop
owner       = NaN(size(vDates,1),size(vID,1));
income      = NaN(size(vDates,1),size(vID,1));
inex        = NaN(size(vDates,1),size(vID,1));
homepx1     = NaN(size(vDates,1),size(vID,1));
homepx5     = NaN(size(vDates,1),size(vID,1));

% Setting up waitbar for progress tracking
wbar        = waitbar(0,'Unstacking data ...');

% Initiating counter
count = 0;

% Looping over stocks to build matrices
for iID = vID'

    % Iterating counter
    count = count + 1;
        
    % Updating the waitbar to keep track on progress
    waitbar(count/length(vID),wbar);

    % Getting data for each ticker
    tmp1                = data(ismember(data.ID,vID(count)),:);

    % Determining available data points for PERMNO
    [~,~,tmp2]          = intersect(tmp1.YYYYMM,vDates);

    % Make matrices
    owner(tmp2,count)       = tmp1.HOMEOWN;
    income(tmp2,count)      = tmp1.INCOME;
    inex(tmp2,count)        = tmp1.INEX;
    homepx1(tmp2,count)     = tmp1.HOMPX1;
    homepx5(tmp2,count)     = tmp1.HOMPX5;

end

% Cloing the waitbar
close(wbar);

% Building income-weighted house price expectations
homepx1(homepx1 == 996 |homepx1 == -997 |homepx1 == 998 | homepx1 == 999) = NaN;
weight_home1 = income;
weight_home1(isnan(homepx1)) = NaN;
weight_home1 = weight_home1./sum(weight_home1,2,'omitnan');
home1 = homepx1.*weight_home1;
sdaData.hret1_income = sum(home1,2,'omitmissing');

% Building income-weighted house price expectations
homepx5(homepx5 == 996 |homepx5 == -997 |homepx5 == 998 | homepx5 == 999) = NaN;
weight_home5 = income;
weight_home5(isnan(homepx5)) = NaN;
weight_home5 = weight_home5./sum(weight_home5,2,'omitnan');
home5 = homepx5.*weight_home5;
sdaData.hret5_income = sum(home5,2,'omitmissing');

% Building income-weighted income expectations
inex(inex == 96 | inex == -97 | inex == 98 | inex == 99 ) = NaN;
weight_income = income;
weight_income(isnan(inex)) = NaN;
weight_income = weight_income./sum(weight_income,2,'omitnan');
inex1 = inex.*weight_income;
sdaData.income_income = sum(inex1,2,'omitmissing');

% Building income-weighted income expectations for homeowners
weight_income = income;
weight_income(isnan(inex) & owner ~= 1) = NaN;
weight_income = weight_income./sum(weight_income,2,'omitnan');
inex2 = inex.*weight_income;
sdaData.income_income1 = sum(inex2,2,'omitmissing');

%% Reading in and storing SLOOS data
% ########################################################################### % 
%{
    We collect SLOOS data from https://www.federalreserve.gov/data/sloos.htm
%}
% ########################################################################### % 

disp('+ Reading in and storing SLOOS data');

% Laoding data
sloos_d                 = readmatrix('raw/sloos/SLOOS_loan_demand.xlsx','Sheet','processed_data','Range','L2:L126');
sloos_s                 = -readmatrix('raw/sloos/SLOOS_loan_supply.xlsx','Sheet','processed_data','Range','L2:L126');

% Preparing data
sloosData.sloos(:,1)    = [NaN(43,1); zscore(sloos_d)];
sloosData.sloos(:,2)    = [NaN(43,1); zscore(sloos_s)];

% Saving data to matfile
save('mat/housingData.mat','housData','michiganData','regionData','sdaData','sloosData');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('+ Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('+ Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %