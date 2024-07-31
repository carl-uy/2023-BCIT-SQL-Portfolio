USE Ch07_SaleCo
GO
--19
SELECT	SUM(NumberOfInvoices) AS 'Total Invoices',
		FORMAT(SUM(TotalPurchases), '0.00') AS 'Total Sales',
		FORMAT(MIN(TotalPurchases),'0.00') AS 'Minimum Customer Purchase',
		FORMAT(MAX(TotalPurchases),'0.00') AS 'Maximum Customer Purchase',
		FORMAT(AVG(TotalPurchases),'0.00') AS 'Average Customer Purchase'
	
FROM(	
	SELECT	C.CUS_CODE, 
		COUNT(DISTINCT I.INV_NUMBER) AS NumberOfInvoices, 
		SUM(L.LINE_UNITS * L.LINE_PRICE) AS TotalPurchases
		
FROM Ch07_SaleCo.dbo.CUSTOMER AS C
JOIN Ch07_SaleCo.dbo.INVOICE AS I
ON C.CUS_CODE = I.CUS_CODE
JOIN Ch07_SaleCo.dbo.LINE AS L
ON I.INV_NUMBER = L.INV_NUMBER
WHERE C.CUS_CODE IN (10011, 10012, 10014, 10015, 10018)
GROUP BY C.CUS_CODE
)AS Subquery 
GO
--23
SELECT C.CUS_CODE, C.CUS_BALANCE
FROM Ch07_SaleCo.dbo.CUSTOMER AS C
WHERE C.CUS_CODE NOT IN (
    SELECT I.CUS_CODE
    FROM Ch07_SaleCo.dbo.INVOICE AS I
)
Go
--24
SELECT	SUM(C.CUS_BALANCE) AS 'Total Balance',
		MIN(C.CUS_BALANCE) AS 'Minimum Balance',
		MAX(C.CUS_BALANCE) AS 'Maximum Balance',
		FORMAT(AVG(C.CUS_BALANCE),'0.00') AS 'Average Balance'

FROM Ch07_SaleCo.dbo.CUSTOMER AS C
WHERE C.CUS_CODE NOT IN (
    SELECT I.CUS_CODE
    FROM Ch07_SaleCo.dbo.INVOICE AS I
)
Go

USE [Ch07_LargeCo ]
GO
--45
SELECT FORMAT(MAX(AveragePrice),'0.00') as 'LARGEST AVERAGE'
	FROM(
		SELECT	 B.brand_id, AVG(p.prod_price) AS AveragePrice

FROM [Ch07_LargeCo ].[dbo].[lgbrand] AS B
JOIN [Ch07_LargeCo ].[dbo].[lgproduct] AS P
ON P.brand_id = B.brand_id
GROUP BY B.brand_id 
)AS Subquery
GO
--46
SELECT	B.brand_id,
		B.brand_name,
		B.brand_type,
		FORMAT((Subquery.AveragePrice),'0.00') AS AVGPRICE
FROM [Ch07_LargeCo ].[dbo].[lgbrand] AS B
JOIN (
	SELECT	brand_id, 
			AVG(prod_price) as AveragePrice
	FROM [Ch07_LargeCo ].[dbo].[lgproduct]
	GROUP BY brand_id
)AS Subquery
ON B.brand_id = Subquery.brand_id
WHERE Subquery.AveragePrice =(
		SELECT MAX(AveragePrice)
		FROM(
			SELECT	brand_id,
				AVG(prod_price) as AveragePrice
				
			FROM [Ch07_LargeCo ].[dbo].[lgproduct]
			GROUP BY brand_id
	)AS Subquery2
)
GO
--49
SELECT	E.emp_num,
		E.emp_lname,
		E.emp_fname,
		S.sal_amount
	
FROM [Ch07_LargeCo ].[dbo].[lgemployee] AS E
	JOIN [Ch07_LargeCo ].[dbo].[lgsalary_history] AS S
	ON E.emp_num = S.emp_num
	WHERE S.sal_from = e.emp_hiredate 
GO
--51
SELECT	e.emp_num as Emp_Num,
		count(distinct l.line_num) as total
FROM [Ch07_LargeCo ].[dbo].[lgemployee] as e
JOIN [Ch07_LargeCo ].[dbo].[lginvoice] as i
ON e.emp_num = i.employee_id
JOIN [Ch07_LargeCo ].[dbo].[lgline] as l
ON i.inv_num = l.inv_num
WHERE i.inv_date BETWEEN '2017-11-01' AND '2017-12-05'
GROUP BY e.emp_num
ORDER BY e.emp_num asc
/*Please help me I am so lost, I can't seem to get same result set :(*/

--54
SELECT	b.brand_id,
	(SELECT AVG(p.prod_price)
	FROM [Ch07_LargeCo ].[dbo].[lgproduct] p
	WHERE b.brand_id = p.brand_id
)as avgprice		
FROM [Ch07_LargeCo ].[dbo].[lgbrand] b
GO
SELECT b.brand_id,
	(SELECT  SUM(p.prod_price * (p.prod_qoh - p.prod_min))
	FROM [Ch07_LargeCo ].[dbo].[lgproduct] p
	WHERE b.brand_id = p.brand_id
)as UNSOLD
FROM [Ch07_LargeCo ].[dbo].[lgbrand] b
/*having a hard time solving for unsold*/

--55
SELECT	B.brand_name,
		b.brand_type,
		p.prod_sku,
		p.prod_descript,
		(SELECT MAX(p.prod_price)
		FROM [Ch07_LargeCo ].[dbo].[lgproduct] p 
		JOIN [Ch07_LargeCo ].[dbo].[lgbrand] b
		ON p.brand_id = b.brand_id
)as Prod_Pirce		
FROM [Ch07_LargeCo ].[dbo].[lgbrand] b
JOIN [Ch07_LargeCo ].[dbo].[lgproduct] p 
ON p.brand_id = b.brand_id
WHERE p.prod_type not in  ('PREMIUM')
	



