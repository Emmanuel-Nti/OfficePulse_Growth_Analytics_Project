with paid_ads_by_campaign_date as (

    select
        campaign_date,
        campaign_id,
        campaign_name,
        channel,
        utm_source,
        utm_medium,
        utm_campaign,

        sum(impressions) as impressions,
        sum(clicks) as clicks,
        sum(ad_spend) as total_ad_spend

    from {{ ref('stg_paid_ads') }}

    group by
        campaign_date,
        campaign_id,
        campaign_name,
        channel,
        utm_source,
        utm_medium,
        utm_campaign

),

crm_by_campaign_date as (

    select
        cast(lead_created_at as date) as lead_created_date,
        campaign_id,

        count(distinct lead_id) as total_leads,

        count(
            distinct case
                when opportunity_id is not null
                    then opportunity_id
            end
        ) as total_opportunities,

        count(
            distinct case
                when close_status = 'Won'
                    then opportunity_id
            end
        ) as won_opportunities,

        count(
            distinct case
                when close_status = 'Lost'
                    then opportunity_id
            end
        ) as lost_opportunities,

        sum(
            case
                when opportunity_id is not null
                    then coalesce(opportunity_amount, 0)
                else 0
            end
        ) as total_pipeline_value,

        sum(
            case
                when close_status = 'Won'
                    then coalesce(opportunity_amount, 0)
                else 0
            end
        ) as total_won_revenue,

        avg(
            case
                when close_status = 'Won'
                    and opportunity_amount is not null
                    then opportunity_amount
            end
        ) as average_won_deal_value,

        avg(
            case
                when close_status = 'Won'
                    and opportunity_created_at is not null
                    and opportunity_close_date is not null
                    and opportunity_close_date
                        >= cast(opportunity_created_at as date)
                then datediff(
                    'day',
                    cast(opportunity_created_at as date),
                    opportunity_close_date
                )
            end
        ) as average_sales_cycle_days

    from {{ ref('stg_crm_pipeline') }}

    where campaign_id is not null

    group by
        cast(lead_created_at as date),
        campaign_id

),

campaign_performance as (

    select
        ads.campaign_date,
        ads.campaign_id,
        ads.campaign_name,
        ads.channel,
        ads.utm_source,
        ads.utm_medium,
        ads.utm_campaign,

        ads.impressions,
        ads.clicks,
        ads.total_ad_spend,

        coalesce(crm.total_leads, 0) as total_leads,
        coalesce(crm.total_opportunities, 0) as total_opportunities,
        coalesce(crm.won_opportunities, 0) as won_opportunities,
        coalesce(crm.lost_opportunities, 0) as lost_opportunities,

        coalesce(crm.total_pipeline_value, 0) as total_pipeline_value,
        coalesce(crm.total_won_revenue, 0) as total_won_revenue,

        crm.average_won_deal_value,
        crm.average_sales_cycle_days,

        ads.clicks * 1.0
            / nullif(ads.impressions, 0)
            as click_through_rate,

        ads.total_ad_spend
            / nullif(ads.clicks, 0)
            as cost_per_click,

        ads.total_ad_spend
            / nullif(crm.total_leads, 0)
            as cost_per_lead,

        ads.total_ad_spend
            / nullif(crm.won_opportunities, 0)
            as customer_acquisition_cost,

        crm.total_won_revenue
            / nullif(ads.total_ad_spend, 0)
            as paid_roas,

        crm.total_opportunities * 1.0
            / nullif(crm.total_leads, 0)
            as lead_to_opportunity_rate,

        crm.won_opportunities * 1.0
            / nullif(crm.total_opportunities, 0)
            as opportunity_win_rate

    from paid_ads_by_campaign_date as ads

    left join crm_by_campaign_date as crm
        on ads.campaign_id = crm.campaign_id
        and ads.campaign_date = crm.lead_created_date

)

select *
from campaign_performance