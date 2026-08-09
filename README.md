# OfficePulse Growth Analytics Pipeline

## Project Overview

This project is an end-to-end Growth Analytics project designed to demonstrate how marketing, CRM, and product usage data can be integrated to evaluate performance across the customer journey.

The objective is to establish a scalable analytical foundation for understanding **marketing acquisition, funnel conversion, revenue performance, lead cohort performance, and product engagement** using three fictional business datasets.

The project combines **dbt, DuckDB, SQL, and Python** to transform raw operational data into analysis-ready data models, define meaningful growth metrics, identify performance drivers and bottlenecks, and translate analytical findings into actionable business recommendations.

---

## Tech Stack

**dbt • DuckDB • SQL • Python • Pandas • Plotly • Jupyter Notebook**

---

## Repository Structure

```text
.
├── data/
│   ├── source/
│   │   ├── paid_ads.csv
│   │   ├── crm_pipeline.csv
│   │   └── product_usage_events.csv
│   │
│   └── officepulse.duckdb
│
├── scripts/
│   ├── run_pipeline.py
│   └── load_data.py
│
├── dbt_project/
│   └── officepulse_growth/
│       ├── dbt_project.yml
│       │
│       └── models/
│           ├── staging/
│           │   ├── sources.yml
│           │   ├── schema.yml
│           │   ├── stg_paid_ads.sql
│           │   ├── stg_crm_pipeline.sql
│           │   └── stg_product_usage_events.sql
│           │
│           └── marts/
│               ├── schema.yml
│               ├── mart_campaign_performance.sql
│               ├── mart_lead_cohort_progression.sql
│               └── mart_product_adoption.sql
│
├── notebooks/
│   └── officepulse_growth_analysis.ipynb
│
├── slides/
│   └── officepulse_growth_analytics_deck.pdf
│
├── README.md
├── requirements.txt
└── .gitignore
```

---

## Data Sources

The project combines three operational datasets covering the customer journey from marketing acquisition through product engagement.

| Dataset                  | Description                                                                |
| ------------------------ | -------------------------------------------------------------------------- |
| **Paid Ads**             | Campaign performance including advertising spend, impressions, and clicks. |
| **CRM Pipeline**         | Lead, opportunity, trial, and revenue data across the sales funnel.        |
| **Product Usage Events** | User interaction events generated after product onboarding.                |

---

## Analytics Architecture

The project follows a reproducible and automated analytics engineering workflow.

```text
CSV Files
      │
      ▼
run_pipeline.py
      │
      ▼
Python Data Ingestion
      │
      ▼
DuckDB Raw Tables
      │
      ▼
dbt Build
      │
      ▼
Automated Jupyter Notebook
      │
      ▼
Executive Presentation
```

---

## Data Models

| Model                               | Purpose                                                                               |
| ----------------------------------- | ------------------------------------------------------------------------------------- |
| **stg_paid_ads**                    | Cleans and standardizes paid advertising data.                                        |
| **stg_crm_pipeline**                | Cleans and standardizes CRM pipeline data.                                            |
| **stg_product_usage_events**        | Cleans and standardizes product usage events.                                         |
| **mart_campaign_performance**       | Measures campaign acquisition efficiency and attributed downstream performance.       |
| **mart_lead_cohort_progression**    | Tracks monthly lead cohorts throughout the sales funnel.                              |
| **mart_product_adoption**           | Measures customer product engagement across users, companies, and subscription plans. |

---

## Data Quality

Basic dbt tests were implemented to validate model integrity before downstream analysis.

**Implemented tests**

- `not_null`
- `unique`

Critical identifiers and analytical fields are validated prior to reporting and analysis.

---

## dbt Documentation

Interactive dbt documentation:

[https://growth-analytics-dbt-docs.netlify.app/#!/overview](https://growth-analytics-dbt-docs.netlify.app/#!/overview)

---

## Running the Project

### 1. Clone or download the project

Clone the repository or download the project files to your preferred working directory.

### 2. Create and activate a virtual environment

Create a virtual environment:

```bash
python -m venv .venv
```

Activate the environment.

**Windows (PowerShell)**

```powershell
.\.venv\Scripts\Activate
```

**macOS / Linux**

```bash
source .venv/bin/activate
```

### 3. Install dependencies

Install all required packages using:

```bash
pip install -r requirements.txt
```

Alternatively, install the required packages manually:

```bash
pip install dbt-core dbt-duckdb duckdb==1.5.5 numpy pandas plotly ipython jupyter
```

### 4. Execute the analytics pipeline

Run the complete analytics workflow with a single command:

```bash
python scripts/run_pipeline.py
```

The pipeline automatically:

- Loads the raw CSV files into DuckDB
- Builds the dbt project (`dbt build`)
- Executes dbt data quality tests
- Executes the Jupyter Notebook and refreshes all analytical outputs

After successful execution, the notebook contains the latest analysis, visualizations, and recommendations generated from the source data.

---

## Analytical Approach

The project follows five analytical stages.

1. **Define the analytical framework**

   - Review the business context and available datasets.
   - Identify the primary growth metrics.

2. **Build scalable data models**

   - Transform raw datasets into analysis-ready marts using dbt.
   - Validate model quality through automated testing.

3. **Perform exploratory analysis**

   - Evaluate acquisition efficiency, funnel conversion, revenue performance, lead cohorts, and product engagement.
   - Identify trends, bottlenecks, and growth opportunities.

4. **Summarize findings and recommendations**

   - Consolidate analytical insights into actionable business recommendations.

5. **Document limitations and future enhancements**

   - Highlight analytical limitations and identify opportunities enabled by additional business data.

---

## Notebook Structure

The analysis notebook is organized into the following sections:

1. Data Validation and Inspection
2. Executive KPI Overview
3. Performance Trends
4. Acquisition Performance
5. Acquisition Conversion Performance
6. Lead Cohort Quality
7. Customer Product Engagement
8. Summary of Findings and Recommendations
9. Limitations and Future Enhancements

---

## Assumptions

The analysis is based on the following assumptions.

- Closed-won opportunities represent successfully acquired customers.
- Advertising spend is fully attributable to the recorded campaigns.
- Product events represent genuine user engagement.
- CRM outcomes are attributed using the lead creation date and campaign identifier because the source data does not include an ad-click or attribution timestamp.
- Each dataset is internally consistent and uniquely identifiable using the provided keys.

---

## Limitations

The available datasets support analysis of **marketing performance, lead progression, and product engagement**, but do not capture the complete customer lifecycle or attribution required for more advanced commercial analytics.

| Limitation                | Business Impact                                                                                       | Additional Data Required                                                                             |
| ------------------------- | ----------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Marketing Attribution** | Recent campaign performance may be underestimated because attribution is based on lead creation date. | Ad-click timestamps, attribution history, click identifiers, multi-touch attribution.                |
| **Product Activation**    | Trial completion is used as a proxy for activation.                                                   | Defined activation events and onboarding milestones.                                                 |
| **Customer Lifecycle**    | Long-term customer value and retention cannot be measured.                                            | Subscription history, recurring revenue, renewals, cancellations, expansion and contraction revenue. |
| **Customer Segmentation** | Performance cannot be analyzed across customer groups.                                                | Industry, company size, geography, and customer segment.                                             |
| **Seat Utilization**      | Workspace utilization cannot be measured reliably.                                                    | Licensed seat capacity and active seat allocation.                                                   |

---

## Future Enhancements

With additional business data, the analytics layer could be extended to support:

- Multi-touch marketing attribution
- Product activation metrics
- Customer lifecycle analytics (MRR, ARR, NRR, GRR, Expansion Revenue, and LTV)
- Customer segmentation
- Seat utilization and workspace adoption analytics

