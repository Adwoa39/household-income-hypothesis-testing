# Canadian Household Income — Hypothesis Testing

## Overview
This project applies inferential statistical analysis to Statistics Canada's Household Economic Accounts dataset, examining Canadian household disposable income, final consumption expenditure, and net savings from 1999 to 2025.

## Objective
To test specific hypotheses about Canadian household income trends, compare pre- and post-2008 economic periods, and quantify the relationship between income and consumption using formal statistical methods.

## Tools Used
- R (tidyverse, ggplot2)

## Dataset
`household.csv` — Statistics Canada Household Economic Accounts (Table 36-10-0588-01), covering annual measures of disposable income, consumption, and savings across Canadian households from 1999 to 2025.

**Source:** [Statistics Canada Open Government Portal](https://open.canada.ca/data/dataset/89941e0b-cc2c-43fc-a616-6e44f92d3a88)

## Methodology
- **Data Filtering:** Extracted three key measures (disposable income, final consumption, net saving) at the national "All households" level
- **Period Segmentation:** Split data into pre-2008 and post-2008 periods to capture structural economic differences
- **Hypothesis Testing:** Applied five formal statistical tests to answer specific research questions
- **Visualization:** Built time series, boxplots, histograms, QQ plots, and scatterplots to support findings

## Hypothesis Tests Conducted

| Test | Research Question | Decision |
|---|---|---|
| One-sample t-test | Is mean disposable income significantly different from $900,000M? | Reject H₀ |
| Two-sample t-test | Is income significantly different pre- vs post-2008? | Reject H₀ |
| Matched pairs t-test | Is there a significant difference between income and consumption? | Fail to reject H₀ |
| Correlation test | Is there a significant linear relationship between income and consumption? | Reject H₀ |
| F-test | Is income variance significantly different between periods? | Reject H₀ |

## Key Insights
- Canadian household disposable income has grown **significantly beyond the $900,000M benchmark**, with a mean of $1,044,950M across the study period
- Post-2008 income ($1,252,750M average) is **nearly double** pre-2008 income ($691,690M average), driven by economic growth, inflation, and government spending
- **Canadian households spend almost everything they earn** — the matched pairs test found no significant difference between income and consumption, suggesting minimal savings behavior
- Income and consumption have a **near-perfect correlation (r = 0.994)** — spending rises almost lockstep with income
- Income became **significantly more volatile after 2008**, driven by the financial crisis, rising inflation, and COVID-19 pandemic relief payments

## Business Relevance
These findings are relevant to financial institutions and policy analysts:
- The near-perfect income-consumption correlation suggests **limited household financial buffer** — relevant for consumer lending risk assessment
- Increased post-2008 income volatility signals **higher financial uncertainty** for lenders evaluating repayment capacity
- The lack of meaningful savings growth despite rising income highlights opportunities for **financial planning and savings products**

## Files
| File | Description |
|---|---|
| `household_analysis.R` | Full R analysis script |
| `household.csv` | Statistics Canada Household Economic Accounts dataset |
| `Household Income Analysis Report.pdf` | Written analysis report with hypothesis test results |

## Future Work
- Extend analysis to provincial-level income and consumption patterns
- Incorporate inflation-adjusted values for more accurate period comparisons
- Analyze net saving trends to explore household financial resilience over time
