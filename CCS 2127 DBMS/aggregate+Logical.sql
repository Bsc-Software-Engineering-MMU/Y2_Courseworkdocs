select * from sales.customers where customer_id = 259
select * from sales.orders where store_id = 1 

--AGGREGATE FUNCTIONS
SELECT COUNT(*) AS [CustCount] FROM sales.customers



/*
Keyed-in-order
SELECT
FROM
WHERE 
GROUP BY
HAVING
ORDER BY
*/

SELECT customer_id, count(*) AS [NoOfOrders] 
from sales.orders
where store_id = 1 
GROUP BY customer_id
HAVING COUNT(*) > 1
order by NoOfOrders desc, customer_id desc 

/*
Logical processing order
FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
*/

select * from sales.orders where store_id = 1 

