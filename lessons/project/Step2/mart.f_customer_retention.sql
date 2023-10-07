delete from mart.f_customer_retention r
where r.period_id in(
    select
        dc.first_day_of_week
    from mart.d_calendar dc
    where dc.date_actual::date = '{{ds}}'
);

insert into mart.f_customer_retention(
    period_name 
    ,period_id 
    ,item_id 
    ,new_customers_count 
    ,returning_customers_count
    ,refunded_customer_count 
    ,new_customers_revenue 
    ,returning_customers_revenue 
    ,customers_refunded  
)

select
    'weekly' as period_name 
    ,t.period_id 
    ,t.item_id 
    ,t.new_customers_count 
    ,t.returning_customers_count
    ,t.refunded_customer_count 
    ,t.new_customers_revenue 
    ,t.returning_customers_revenue 
    ,t.customers_refunded 
from(
    select
        --'weekly' as period_name
        q.period_id
        ,q.item_id
        ,sum(case when cnt_sales = 1 then 1 else 0 end) as new_customers_count
        ,sum(case when cnt_sales > 1 then 1 else 0 end) as returning_customers_count
        ,sum(case when cnt_rej >= 1 then 1 else 0 end) as refunded_customer_count
        ,sum(case when cnt_sales = 1 then payment_amount else 0 end ) as new_customers_revenue
        ,sum(case when cnt_sales > 1 then payment_amount else 0 end ) as returning_customers_revenue
        ,sum(cnt_rej) as customers_refunded
    from(
        select
            dc.first_day_of_week as period_id
            ,fs.item_id
            ,fs.customer_id
            ,count(*) as cnt_sales
            ,sum(
                case
                    when fs.status = 'refunded' then 1
                    else 0
                end
            ) as cnt_rej
            ,sum(payment_amount) as payment_amount
        from mart.f_sales fs  
        inner join mart.d_calendar dc on fs.date_id = dc.date_id
        where dc.date_actual::date = '{{ds}}' 
        group by dc.first_day_of_week
                ,fs.item_id
                ,fs.customer_id
    ) q
    group by q.period_id
            ,q.item_id
) t 