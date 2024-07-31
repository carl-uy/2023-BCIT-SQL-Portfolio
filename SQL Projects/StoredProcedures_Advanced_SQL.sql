USE publications;
GO
--1
/*Design Time For Store Procedure A01341011_authors_by_state*/
DROP PROCEDURE IF EXISTS #A01341011_authors_by_state
GO
CREATE PROCEDURE #A01341011_authors_by_state
	@state NVARCHAR(255)
AS
BEGIN
	SELECT	au_fname + ' ' + au_lname AS Name,
			address,
			city
	FROM publications.dbo.authors
	WHERE	state = @state;
END
GO
--2
/* RUN TIME */
EXEC #A01341011_authors_by_state 'CA';

--3
/*Design Time for Stored Procedure A01341011_titles_by_type*/
DROP PROCEDURE IF EXISTS #A01341011_titles_by_type
GO
CREATE PROCEDURE #A01341011_titles_by_type
	@type NVARCHAR(50)
AS
BEGIN
	SELECT	title, 
			price, 
			notes, 
			pubdate as 'publication date'
	FROM publications.dbo.titles
	WHERE type =
		CASE UPPER(@type)
			WHEN 1 then 'cooking' 
			WHEN 2 then 'psychology' 
			WHEN 3 then 'business' 
			WHEN 4 then 'computers' 
			ELSE NULL
		END;
END
GO
--4
/* RUN TIME */
EXEC #A01341011_titles_by_type 2;	
--5
/*/Design time for stored procedure #A01341011_employee_information*/
DROP PROCEDURE IF EXISTS #A01341011_employee_information
GO
CREATE PROCEDURE #A01341011_employee_information
	@startDate  DATE,
	@endDate	DATE
AS
BEGIN
	SELECT	emp_id as 'employee ID',
			lname + ',' + ' '+ fname as 'name',
			lname as 'last name',
			FORMAT(hire_date, 'MMMM dd, yyyy') as 'hire date',
			job_desc as 'job description'
			
	FROM publications.dbo.employee e
	JOIN publications.dbo.jobs j
	ON  e.job_id = j.job_id
	WHERE hire_date >= @startDate and hire_date <= @endDate;
END
GO
--6
/* RUN TIME */
EXEC #A01341011_employee_information 'January 1, 1989', 'December 31,1990';
--7
/*Design time for stored procedure #A01341011_author_information*/
DROP PROCEDURE IF EXISTS  #A01341011_author_information
GO
CREATE PROCEDURE #A01341011_author_information
	@authorId VARCHAR(11),
	@titleId VARCHAR(6),
	@lastname NVARCHAR (255) OUTPUT,
	@firstname NVARCHAR (255) OUTPUT,
	@royaltyPercentage INT OUTPUT
AS
BEGIN
	SELECT	@lastname = au_lname,
			@firstname = au_fname,
			@royaltyPercentage = royaltyper
	FROM publications.dbo.authors a
	JOIN publications.dbo.titleauthor t
	ON a.au_id = t.au_id
	WHERE	a.au_id = @authorId and 
			t.title_id = @titleId;
END
GO
--8
/*RUN TIME*/
DECLARE	@lastname NVARCHAR (255),
		@firstname NVARCHAR (255),
		@royaltyPercentage INT 
EXEC	#A01341011_author_information '672-71-3249',  'TC7777' , @lastname OUTPUT, @firstname OUTPUT, @royaltyPercentage OUTPUT;
SELECT	@lastname as 'Last Name',
		@firstname as 'First Name',
		@royaltyPercentage as 'Royalty Percentage';
--9
/*Design time for stored procedure #A01341011_store_information*/
DROP PROCEDURE IF EXISTS #A01341011_store_information
GO
CREATE PROCEDURE #A01341011_store_information
	@price money
AS
BEGIN 
	SELECT	s.stor_id as 'store ID',
			FORMAT(s.ord_date, 'Mmmm, dd, yyyy') as 'order date',
			st.stor_name as 'store name',
			t.title_id as 'title id',
			FORMAT(t.price, 'C','en-CA') as  'price',
			FORMAT(t.advance,'C', 'en-CA') as 'advance'
	FROM publications.dbo.sales s
	JOIN publications.dbo.stores st
	ON s.stor_id = st.stor_id
	JOIN publications.dbo.titles t
	ON t.title_id = s.title_id
	WHERE  t.price >= @price
	ORDER BY s.stor_id
END
GO 
--10
/*RUN TIME*/
EXEC #A01341011_store_information 20;

/*I am not sure if I did this assignment well but I just wanted to say I really enjoyed doing it 
and I really appreciate the effort you have given teaching us begginers PS assignment 8 was very
challenging*/ 
