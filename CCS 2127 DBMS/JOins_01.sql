/*
customer(first_name, last_name {concatenated CustName}, email,street)
staff(first_name, last_name)
Orders(order_id, order_date, required_date, shipped_date)
Store(store_name, phone)
*/
select top 10 * from sales.customers
select top 10 * from sales.staffs
select top 10 * from sales.orders
select top 10 * from sales.stores

SELECT o.order_id, o.order_date, o.required_date, o.shipped_date, 
c.first_name + ' ' + c.last_name AS [CustName], c.email as [CustEMail], c.street AS [CustStreet],
s.first_name + ' ' + s.last_name AS [StaffName],
st.store_name, st.phone [StorePhoneNo],
od.quantity, od.list_price, od.discount, p.list_price AS [ProductListPrice]
FROM sales.orders AS o
	INNER JOIN sales.customers AS c ON c.customer_id = o.customer_id
	INNER JOIN sales.staffs AS s ON s.staff_id = o.staff_id
	INNER JOIN sales.stores AS st ON st.store_id = o.store_id
	INNER JOIN sales.order_items AS od ON od.order_id = o.order_id
	INNER JOIN production.products AS p ON p.product_id = od.product_id
where o.shipped_date IS NULL

--Find out the cheapest product
select * from production.products 
where list_price = (select min(list_price) from production.products)

--Compute the no of orders a cstomer has placed

SELECT c.first_name + ' ' + c.last_name AS [CustName], c.email as [CustEMail], c.street AS [CustStreet],o.order_id,
YEAR(o.order_date) [Year],
count(*) AS [NoOfItems], 
FORMAT(SUM(od.quantity * od.list_price),'#,0.00') AS [TotalAmount],
FORMAT(SUM(od.quantity * od.list_price * (1-od.discount)),'#,0.00') AS [DiscountedAmount],
SUM(od.quantity * od.list_price)-SUM(od.quantity * od.list_price * (1-od.discount)) AS [Discount]
FROM sales.orders AS o
	INNER JOIN sales.customers AS c ON c.customer_id = o.customer_id
	INNER JOIN sales.order_items AS od ON od.order_id = o.order_id
--where o.order_id = 1
GROUP BY c.first_name + ' ' + c.last_name,c.email,c.street,o.order_id,o.order_date
--HAVING count(o.order_id) > 1


select *, list_price*(1-discount) as [DiscountedPrice] from sales.order_items where order_id = 1

--CTE
;With TotalAMount AS
(
	SELECT c.first_name + ' ' + c.last_name AS [CustName], c.email as [CustEMail], c.street AS [CustStreet],o.order_id,
	YEAR(o.[order_date]) AS [Year],
count(*) AS [NoOfItems], 
SUM(od.quantity * od.list_price) AS [TotalAmount],
SUM(od.quantity * od.list_price * (1-od.discount))AS [DiscountedAmount],
SUM(od.quantity * od.list_price)-SUM(od.quantity * od.list_price * (1-od.discount)) AS [Discount]
FROM sales.orders AS o
	INNER JOIN sales.customers AS c ON c.customer_id = o.customer_id
	INNER JOIN sales.order_items AS od ON od.order_id = o.order_id
--where o.order_id = 1
GROUP BY c.first_name + ' ' + c.last_name,c.email,c.street,o.order_id, YEAR(o.[order_date])
)
select [Year], FORMAT(SUM([TotalAmount]),'#,0.00') AS [TotalAmount], 
FORMAT(SUM([DiscountedAmount]),'#,0.00') AS [DiscountedAmount], 
FORMAT(SUM([Discount]),'#,0.00') AS [Discount]
from TotalAMount
GROUP BY [Year];


select* from  Sales.orders where store_id = 1 and shipped_date is null
select* from  Sales.stores

DROP TABLE IF EXISTS #Orders;
select * into #Orders from  Sales.orders

--
select* from  #Orders where store_id = 1 and shipped_date = '1900-01-01'

--Update with a join
UPDATE [Ord] SET [Ord].[shipped_Date] = '1900-01-01'
FROM #Orders AS [Ord]
INNER JOIN Sales.stores AS [st] ON [st].[store_id] = [ord].[store_id]
WHERE [st].[store_id] = (select store_id from  Sales.stores where store_name = 'Santa Cruz Bikes');
