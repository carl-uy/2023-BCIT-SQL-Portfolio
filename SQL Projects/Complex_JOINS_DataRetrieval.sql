USE test;
Go

SELECT *
FROM AdventureWorks2019.Person.Person
JOIN AdventureWorks2019.HumanResources.Employee
ON	AdventureWorks2019.Person.Person.BusinessEntityID = AdventureWorks2019.HumanResources.Employee.BusinessEntityID
GO
/*10 built-in functions*/
--Gender count
DROP FUNCTION IF EXISTS A01341011_GenderCount;
GO
CREATE FUNCTION A01341011_GenderCount (@gender CHAR(1))
RETURNS INT
AS
BEGIN
	RETURN
		(SELECT COUNT(*) FROM [AdventureWorks2019].[HumanResources].[Employee]
		WHERE [GENDER] = @gender);
END
GO
SELECT dbo.A01341011_GenderCount('M') AS MALE, dbo.A01341011_GenderCount('F') 
		AS 'Gender count using A01341011_GenderCount user-defined Function'
GO



--MaritalStatus Count
DROP FUNCTION IF EXISTS A01341011_MaritalStatusCount;
GO
CREATE FUNCTION A01341011_MaritalStatusCount (@MaritalStatus NCHAR(1))
RETURNS INT
AS
BEGIN
	RETURN
	(SELECT COUNT(*) FROM [AdventureWorks2019].[HumanResources].[Employee] 
		WHERE [MaritalStatus] = @MaritalStatus)
END
GO
SELECT dbo.A01341011_MaritalStatusCount('M') AS MARRIED, dbo.A01341011_MaritalStatusCount('S') AS SINGLE
GO
--Total VacationHours Sum
DROP FUNCTION IF EXISTS A01341011_TotalVacationHours
GO
CREATE FUNCTION A01341011_TotalVacationHours() 
RETURNS INT
AS
BEGIN
	RETURN
	(SELECT SUM(VacationHours) FROM [AdventureWorks2019].[HumanResources].[Employee])
END
GO
SELECT dbo.A01341011_TotalVacationHours() 
		AS 'TotalVacationHours using A01341011_TotalVacationHours user-defined Function'
GO
-- Vacation Hours Less than 50 Count
DROP FUNCTION IF EXISTS A01341011_VacationHoursLess
GO
CREATE FUNCTION A01341011_VacationHoursLess (@VacationHoursLess smallint)
RETURNS INT
AS
BEGIN
	RETURN(
	SELECT COUNT(*)
	FROM [AdventureWorks2019].[HumanResources].[Employee]
	WHERE VacationHours < 50
)
END
GO
SELECT dbo.A01341011_VacationHoursLess(50)
	AS 'Vacation Hours less than 50 count using A01341011_VacationHoursLessuser-defined Function'
GO
--Count Null MiddleNames
DROP FUNCTION IF EXISTS A01341011_MiddleNameCount;
GO
CREATE FUNCTION A01341011_MiddleNameCount (@MiddleName CHAR(1))
RETURNS INT
AS
BEGIN
	RETURN
		(SELECT COUNT(*) FROM [AdventureWorks2019].[Person].[Person]
		WHERE [MiddleName] = @MiddleName)
END
GO
SELECT dbo.A01341011_MiddleNameCount('A')	
		AS 'Count Null MiddleNames A01341011_MiddleNameCount user-defined Function'
GO

--COUNT Email Promotion
DROP FUNCTION IF EXISTS A01341011_EmailPromotion;
GO
CREATE FUNCTION A01341011_EmailPromotion (@EmailPromotion INT)
RETURNS INT
AS
BEGIN
	RETURN(
	SELECT COUNT(*) FROM [AdventureWorks2019].[Person].[Person]
	WHERE [EmailPromotion] = @EmailPromotion
)
END
GO
SELECT dbo.A01341011_EmailPromotion('1') AS '1 Email Promotion', dbo.A01341011_EmailPromotion('2') AS '2 Email Promotion', 
		dbo.A01341011_EmailPromotion('0') AS '0 Email Promotion';
GO

--Salaried Flag
DROP FUNCTION IF EXISTS A01341011_SalariedFlag
GO
CREATE FUNCTION A01341011_SalariedFlag (@SalariedFlag INT)
RETURNS INT
AS
BEGIN
	RETURN(
	SELECT COUNT(*) FROM [AdventureWorks2019].[HumanResources].[Employee]
	WHERE [SalariedFlag] = @SalariedFlag
)
END
GO
SELECT dbo.A01341011_SalariedFlag('1') as 'Has Salary Flag', 
		dbo.A01341011_SalariedFlag('0') as 'No Salary Flag';
GO
SELECT P.FirstName , P.LastName , E.SalariedFlag as 'Salary Flag'
FROM [AdventureWorks2019].[HumanResources].[Employee] AS E
JOIN [AdventureWorks2019].[Person].[Person] AS P
ON P.BusinessEntityID = E.BusinessEntityID
WHERE [SalariedFlag] = 1
GO
--IsNewHire
DROP FUNCTION IF EXISTS A01341011_IsNewHire;
GO
CREATE FUNCTION A01341011_IsNewHire (@BusinessEntityID INT)
RETURNS INT 
AS
BEGIN
    DECLARE @hiredate DATE;
    DECLARE @modifieddate DATE;
    DECLARE @isnewhire INT;

    SELECT @hiredate = HireDate, @modifieddate = ModifiedDate
    FROM AdventureWorks2019.HumanResources.Employee
    WHERE BusinessEntityID = @BusinessEntityID;

    SET @isnewhire = CASE
        WHEN DATEDIFF(MONTH, @modifieddate, @hiredate) <= 6 THEN 1 --NEW HIRE
        ELSE 0 -- NOT NEW HIRE
    END;

    RETURN @isnewhire;
END;
GO

SELECT p.*, dbo.A01341011_IsNewHire(p.BusinessEntityID) AS IsNewHire
FROM AdventureWorks2019.Person.Person AS p
GO
--TenureinYears
DROP FUNCTION IF EXISTS A01341011_TenureinYears;
GO
CREATE FUNCTION A01341011_TenureinYears (@BusinessEntityID INT)
RETURNS INT
AS
BEGIN	
	DECLARE @hiredate DATE;
    DECLARE @modifieddate DATE;
    DECLARE @TenureinYears INT;
	
	SELECT @hiredate = HireDate, @modifieddate = ModifiedDate
    FROM AdventureWorks2019.HumanResources.Employee
    WHERE BusinessEntityID = @BusinessEntityID;

	SET @TenureinYears = DATEDIFF(YEAR, @hiredate, @modifieddate);

	RETURN @TenureinYears;
END;
GO

SELECT p.LastName, p.FirstName , dbo.A01341011_TenureinYears(p.BusinessEntityID) AS TenureinYears
FROM AdventureWorks2019.Person.Person AS p
WHERE dbo.A01341011_TenureinYears(p.BusinessEntityID) IS NOT NULL 
ORDER BY TenureinYears asc
GO
--Age When Hired
DROP FUNCTION IF EXISTS A01341011_AgeEmployed
GO
CREATE FUNCTION A01341011_AgeEmployed (@BusinessEntityID INT)
RETURNS INT
AS
BEGIN
	DECLARE @BirthDate Date;
	DECLARE @HireDate Date;
	Declare @AgeEmployed INT;
		SELECT 
			@HireDate = HireDate,
			@BirthDate = BirthDate
		FROM [AdventureWorks2019].[HumanResources].[Employee]
		WHERE BusinessEntityID = @BusinessEntityID;
			SET @AgeEmployed = DATEDIFF(YEAR, @BirthDate, @HireDate);

			RETURN @AgeEmployed;
END;
GO
SELECT P.FirstName, P.LastName, dbo.A01341011_AgeEmployed(p.BusinessEntityID) AS 'Age Employed'
FROM AdventureWorks2019.HumanResources.Employee AS E
JOIN AdventureWorks2019.Person.Person AS P
ON E.BusinessEntityID = P.BusinessEntityID
ORDER BY [Age Employed] ASC
GO
/*5 GROUP BY*/
--1
SELECT [Gender], 
		COUNT(*) AS 'TOTAL COUNT'
FROM 
	[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY 
	[GENDER]
GO

--2 
SELECT 
	[MaritalStatus],
	COUNT(*) AS 'TOTAL COUNT'
FROM 
	[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY
	[MaritalStatus]
GO

--3
SELECT 
	[Gender],
	[MaritalStatus],
	COUNT(*) AS 'TOTAL COUNT'
FROM 
	[AdventureWorks2019].[HumanResources].[Employee]
GROUP BY
	[MaritalStatus],
	[GENDER]
GO
--4
SELECT
	[GENDER],
	[MARITALSTATUS],
	[EmailPromotion],
	COUNT (*) AS 'TOTAL COUNT'
FROM 
	[AdventureWorks2019].[HumanResources].[Employee] AS E
JOIN 
	[AdventureWorks2019].[Person].[Person] AS P
ON 
	E.BusinessEntityID = P.BusinessEntityID
GROUP BY
	[EmailPromotion],
	[Gender],
	[MaritalStatus]
GO
--5
SELECT
	[Gender],
	COUNT(*) AS [Total Count],
	MIN(DATEDIFF(yyyy, [BirthDate], GETDATE())) AS [Youngest],
	AVG(DATEDIFF(yyyy, [BirthDate], GETDATE())) AS [Average Age],
	MAX(DATEDIFF(yyyy, [BirthDate], GETDATE())) AS [Oldest]
FROM     [AdventureWorks2019].[HumanResources].[Employee]
WHERE    
	[MaritalStatus] = 'S' AND
	[GENDER] = 'F'
GROUP BY [Gender]