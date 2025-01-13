# Subjective expectations and house prices

This folder contains replicating data and code files for *Subjective expectations and house prices* published in the Journal of Banking and Finance, Vol. 172, 107377, 2025. 

## Data

The data is sourced from different providers and is structured as follows: 
```
Data
|–—oecd: aggregate US house price data
|––mcs: Survey data on aggregate and regional responses
|––fred: regional house price data
|––sloos: Fed data on loan officer survey data
```

## Codes

The replication files are provided in Matlab. Each of the below files replicates a Figure or a Table it its entirety. 

```
Code
|–—figure1_synthetic_expectations.m:
|–—figure2_subjective_expectations.m: 
|–—figure3_expectational_errors.m: 
|––table1_descriptive_statistics.m: 
|––table2_var_model.m: 
|––table3_4_decompositions.m: 
|––table5_homeowners_income.m: 
|––table6_regions.m: 
|––table7_predictability.m: 
|––table8_errors_housing.m: 
|––table9_errors_sloos.m: 
|––table10_alternative_returns.m: 
```

There are also a series of functions that serves as input to the replicating scripts. 

```
Functions
|––colorBrewer.m: Provides color references for plots
|––nwRegress.m: OLS regressions with Newey-West standard errors
|––rational_decomposition.m: Performs a VAR-based variance decomposition
|––subjective_decomposition.m: Performs a survey-based variance decomposition
```

## Output

This folder contains the output from running the replicating Matlab files. 
