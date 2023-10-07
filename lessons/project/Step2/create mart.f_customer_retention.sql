drop table if exists mart.f_customer_retention;
create table mart.f_customer_retention(
new_customers_count int4,
returning_customers_count int4,
refunded_customer_count int4,
period_name text,
period_id date,
item_id int4,
new_customers_revenue int8,
returning_customers_revenue int8,
customers_refunded int4 
);