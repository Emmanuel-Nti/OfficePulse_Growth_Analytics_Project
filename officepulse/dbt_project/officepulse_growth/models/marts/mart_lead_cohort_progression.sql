with lead_cohorts as (

    select
        date_trunc(
            'month',
            cast(lead_created_at as date)
        ) as lead_created_month,

        count(distinct lead_id) as total_leads,

        count(
            distinct case
                when opportunity_id is not null
                    then opportunity_id
            end
        ) as total_opportunities,

        count(
            distinct case
                when trial_start_at is not null
                    then company_id
            end
        ) as trials_started_companies,

        count(
            distinct case
                when trial_end_at is not null
                    then company_id
            end
        ) as activated_trials_companies,

        count(
            distinct case
                when close_status = 'Won'
                    then opportunity_id
            end
        ) as total_customers,

        sum(
            case
                when opportunity_id is not null
                    then coalesce(opportunity_amount, 0)
                else 0
            end
        ) as pipeline_value,

        sum(
            case
                when close_status = 'Won'
                    then coalesce(opportunity_amount, 0)
                else 0
            end
        ) as won_revenue,

        avg(
            case
                when close_status = 'Won'
                    and opportunity_amount is not null
                    then opportunity_amount
            end
        ) as average_deal_size,

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

    group by
        date_trunc(
            'month',
            cast(lead_created_at as date)
        )

),

final as (

    select
        lead_created_month,

        total_leads,
        total_opportunities,
        trials_started_companies,
        activated_trials_companies,
        total_customers,

        pipeline_value,
        won_revenue,
        average_deal_size,
        average_sales_cycle_days,

        total_opportunities * 1.0
            / nullif(total_leads, 0)
            as lead_to_opportunity_rate,

        total_customers * 1.0
            / nullif(total_opportunities, 0)
            as opportunity_to_customer_rate,

        activated_trials_companies * 1.0
            / nullif(trials_started_companies, 0)
            as trial_activation_rate

    from lead_cohorts

)

select *
from final