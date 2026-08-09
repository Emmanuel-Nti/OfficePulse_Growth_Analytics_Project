with product_usage as (

    select
        date_trunc('month', event_date) as event_month,
        plan_tier,
        user_id,
        company_id

    from {{ ref('stg_product_usage_events') }}

),

monthly_overall as (

    select
        event_month,

        'overall' as aggregation_level,
        'all_plans' as plan_tier,

        count(distinct user_id) as active_users,
        count(distinct company_id) as active_companies

    from product_usage

    group by
        event_month

),

monthly_by_plan_tier as (

    select
        event_month,

        'plan_tier' as aggregation_level,
        plan_tier,

        count(distinct user_id) as active_users,
        count(distinct company_id) as active_companies

    from product_usage

    group by
        event_month,
        plan_tier

)

select
    event_month,
    aggregation_level,
    plan_tier,
    active_users,
    active_companies

from monthly_overall

union all

select
    event_month,
    aggregation_level,
    plan_tier,
    active_users,
    active_companies

from monthly_by_plan_tier

order by
    event_month,
    aggregation_level,
    plan_tier