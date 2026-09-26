/*считаем общее количество покупателей*/
select 
	COUNT(distinct customer_id) as customers_count 
from customers;

/*отчет с продавцами у которых наибольшая выручка*/
select
    e.first_name || ' ' || e.last_name as seller,
    COUNT(s.sales_id) as operations,
    FLOOR(SUM(s.quantity * p.price)) as income
from employees as e
left join sales as s
    on e.employee_id = s.sales_person_id
left join products as p
    on s.product_id = p.product_id
where s.quantity is not NULL
group by seller
order by income desc
limit 10;

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
order by day_number, seller;

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

/*выводим покупателей, первая покупка которых пришлась на время проведения специальных акций*/
WITH tab1 AS (
    SELECT
        c.customer_id AS id,
        s.sale_date,
        p.price AS pr,
        c.first_name || ' ' || c.last_name AS customer,
        e.first_name || ' ' || e.last_name AS seller,
        row_number()
            OVER (
                PARTITION BY (c.first_name || ' ' || c.last_name)
                ORDER BY s.sale_date
            )
            AS number
    FROM customers AS c
    LEFT JOIN sales AS s
        ON c.customer_id = s.customer_id
    LEFT JOIN employees AS e
        ON s.sales_person_id = e.employee_id
    LEFT JOIN products AS p
        ON s.product_id = p.product_id
    WHERE s.sale_date IS NOT NULL
)

SELECT
    customer,
    sale_date,
    seller
FROM tab1
WHERE number = 1 AND pr = 0
ORDER BY id;







