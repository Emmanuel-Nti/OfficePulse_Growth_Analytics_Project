
# dbt Data Transformation & Growth Analytics Project
 
End-to-end Growth Analytics project using Python, DuckDB and dbt to load and transform raw data into analytical marts, define key growth metrics, and generate insights across acquisition, conversion, revenue, lead cohorts and product engagement.

<p align ="center">
   <img src = "docs/images/01_porject_overview.png">
 </p>

 ## [Detailed Project Notebook Link](https://nbviewer.org/github/Emmanuel-Nti/OfficePulse_Growth_Analytics_Project/blob/master/officepulse/notebooks/officepulse_growth_analysis.ipynb) 
 
  - **Interactive dbt documentation:** [https://growth-analytics-dbt-docs.netlify.app/#!/overview](https://growth-analytics-dbt-docs.netlify.app/#!/overview)

## 5 Key Growth Metrics (Based on the Data)
 - Paid Roas (Cohort Roas), Cost per Won Opportunity, Lead-to-Opportunity Rate, Opportunity Win Rate, Won Revenue

## Insights
  <p align ="center">
   <img src = "docs/images/cohort_performance.PNG">
 </p>
 
💡 Marketing investment remained relatively stable across acquisition cohorts, providing a stable baseline for evaluating differences in downstream performance. Despite this, won revenue and Paid ROAS varied considerably across cohorts.

<p align ="center">
   <img src = "docs/images/cohort conversion.PNG">
 </p>
 
💡 Opportunity Win Rate exhibited a similar pattern, suggesting that cohorts with stronger opportunity conversion generally generated higher won revenue and marketing efficiency.

<p align ="center">
   <img src = "docs/images/channel efficiency.PNG">
 </p>
 
 💡 Display consistently achieved the strongest acquisition efficiency, outperforming Paid Search and Paid Social.

<p align ="center">
   <img src = "docs/images/campaign efficiency.PNG">
 </p>
 
 💡 Display's strong channel performance was supported by consistently high-performing campaigns.

<p align ="center">
   <img src = "docs/images/Channel conversion.PNG">
 </p>
 
 💡 Lead-to-Opportunity conversion emerged as the primary bottleneck across acquisition channels.

<p align ="center">
   <img src = "docs/images/active users.PNG">

 💡 Monthly active users increased overall, while active companies remained relatively stable throughout the reporting period.

## Summary of Findings, Recommendations, and Limitations
<p align ="center">
   <img src = "docs/images/summary.png">

 <p align ="center">
   <img src = "docs/images/recommendation.png">

  <p align ="center">
   <img src = "docs/images/Appendix.png">

#### Software and Tools

![](https://img.shields.io/badge/Python-SQL-informational?style=flat&color=2bbc8a) ![](https://img.shields.io/badge/dbt-DuckDB-informational?style=flat&color=2bbc8a) ![](https://img.shields.io/badge/Pandas-Plotly-informational?style=flat&color=2bbc8a) ![](https://img.shields.io/badge/Jupyter-Notebook-informational?style=flat&color=2bbc8a)
