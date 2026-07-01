
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ 
    config(
        materialized='incremental',
        partition_by=[{'field': 'datepartition', 'data_type': 'string'}],
        incremental_strategy='insert_overwrite',
        pre_hook=["{{ in_dbt_utils.make_columns_nullable(column_name='datepartition) }}"],
        on_schema_change='append_new_columns',
        alias='careers_eng_guardrails___job_view_metrics',
        retention_period='5d',
        spark_conf={
            "spark.driver.memory": "2g",
            "spark.executor.memory": "3g",
            "spark.executor.cores": ""
        },
    ) }}

with jobViews as (
    (select * 
    from {{ in_dbt_utils.in_source_with_range_filter('job_view_source_u_metrics', 'career_metrics_pst_prime___job_view_metrics')}}),
      final_select_statement as
      (select member_id as member_id,
              ump_date_partition_timestamp_pst as timestamp,
              member_job_view_count as job_views,
              channel as channel,
              cast(if(job_ranking_slot_type is not null, lower(job_ranking_slot_type), 'unknown') as STRING) as job_type,
              lower(os_group) as osGroup,
              lower(platform_toplevel) as platform,
              INITCAP(portal) as portal,
              user_interface as user_interface
              from jobViews jv)
select *,
       concat(date_format(from_utc_timestamp(from_unixtime(timestamp / 1000), 'America/Los_Angeles'), 'yyyy-MM-dd'), '-00') as datepartition
from final_select_statement
where concat(date_format(from_utc_timestamp(from_unixtime(timestamp / 1000), 'America/Los_Angeles'), 'yyyy-MM-dd'), '-00') between '{{ in_dbt_utils.start_date_with_frequency(delay=0, range=1) | trim }}' and '{{ in_dbt_utils.end_date_with_frequency(delay=0) | trim }}'

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
