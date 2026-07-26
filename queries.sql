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

/*количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+*/
with tab1 as (
    select
        case
            when age >= 16 AND age <= 25 then '16-25'
            when age >= 26 AND age <= 40 then '26-40'
            when age > 40 THEN '40+'
        end as age_category
    from customers
)
select
    age_category,
    COUNT(age_category) as age_count
from tab1
group by age_category
order by age_category;

/*выводим данные по количеству уникальных покупателей и выручке, которую они принесли*/
select
    TO_CHAR(s.sale_date, 'YYYY-MM') as selling_month,
    COUNT(distinct s.customer_id) as total_customers,
    FLOOR(SUM(p.price * s.quantity))
from sales as s
left join products as p
    on s.product_id = p.product_id
group by selling_month
order by selling_month asc;





