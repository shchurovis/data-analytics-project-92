/*считаем общее количество покупателей*/
select 
	COUNT(distinct customer_id) as customers_count 
from customers;

/*отчет с продавцами у которых наибольшая выручка*/
select
    e.first_name || ' ' || e.last_name as seller,
    SUM(s.quantity) as operations,
    FLOOR(SUM(s.quantity * p.price)) as income
from employees as e
left join sales as s
    on e.employee_id = s.sales_person_id
left join products as p
    on s.product_id = p.product_id
where s.quantity is not NULL
group by seller
order by income desc;




