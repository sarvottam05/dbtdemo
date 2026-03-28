{{ config(materialized='view') }}
select 
    o.orderid,
    c.custid,
    c.customer_name,
    p.pid,
    p.pname,
    o.qty,
    o.orderdate
from
    dbt_sbankapur.orders o
join
    {{ref("stg_customers")}} c ON o.custid = c.custid
join
    dbt_sbankapur.products p on o.productid = p.pid

