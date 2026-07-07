/*считаем общее количество покупателей*/
select 
	COUNT(distinct customer_id) as customers_count 
from customers;


