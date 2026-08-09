select

    lead_id,
    cast(created_at as timestamp) as lead_created_at,
    email_domain,

    company_id,
    company_name,
    campaign_id,

    lifecycle_stage,

    opportunity_id,
    cast(opportunity_created_at as timestamp) as opportunity_created_at,
    cast(amount as decimal(18, 2)) as opportunity_amount,
    cast(close_date as date) as opportunity_close_date,
    close_status,

    cast(trial_start_at as timestamp) as trial_start_at,
    cast(trial_end_at as timestamp) as trial_end_at

from {{ source('officepulse', 'raw_crm_pipeline') }}