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

/*отчет по продавцам, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам*/
select
    e.first_name || ' ' || e.last_name as seller,
    FLOOR(AVG(s.quantity * p.price)) as average_income
from employees as e
left join sales as s
    on e.employee_id = s.sales_person_id
left join products as p
    on s.product_id = p.product_id
where s.quantity is not NULL
group by seller
order by average_income asc;

/*отчет, содержащий информацию о выручке по дням недели*/
with table1 as (
    select
        e.first_name || ' ' || e.last_name as seller,
        TO_CHAR(s.sale_date, TRIM('Day')) as day_of_week,
        FLOOR(SUM(s.quantity * p.price)) as income,
        EXTRACT(isodow from s.sale_date) as day_number
    from employees as e
    inner join sales as s
        on e.employee_id = s.sales_person_id
    inner join products as p
        on s.product_id = p.product_id
    where s.quantity is not NULL
    group by seller, day_of_week, day_number
)

select
    seller,
    day_of_week,
    income
from table1
order by day_number asc;





