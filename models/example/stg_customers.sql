with stg_customers as (
   select custid,
    concat(fname, ' ', lname) as customer_name,
    email as email_Address,
    address as billing_address
   from dbt_sbankapur.customer

) 

select * from stg_customers