select

    cast(date as date) as campaign_date,

    campaign_id,
    campaign_name,
    channel,
    utm_source,
    utm_medium,
    utm_campaign,

    cast(impressions as integer) as impressions,
    cast(clicks as integer) as clicks,
    cast(cost as decimal(18, 2)) as ad_spend

from {{ source('officepulse', 'raw_paid_ads') }}