{{ config(materialized='view') }}

select
    custid,
    customer_name
    email_Address,
    billing_address
from {{ref('stg_customers')}}
