select

    cast(event_time as timestamp) as event_timestamp,
    cast(event_time as date) as event_date,

    company_id,
    user_id,
    event_type,
    plan_tier,

    cast(seats_used as integer) as seats_used

from {{ source('officepulse', 'raw_product_usage_events') }}