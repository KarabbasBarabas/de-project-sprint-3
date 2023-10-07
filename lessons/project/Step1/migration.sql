alter table mart.f_sales add column status text;
alter table staging.user_order_log add column status text;


update mart.f_sales
set "status" = 'shipped';
update stage.user_order_log
set "status" = 'shipped';

-- откат
alter table mart.f_sales drop column "status";
alter table stage.user_order_log drop column "status;