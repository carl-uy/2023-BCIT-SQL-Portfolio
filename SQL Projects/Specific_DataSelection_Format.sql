/*1*/
USE Medical
GO
SELECT 
	P.Name as 'Patient Name', P.Phone as 'Patient Phone', 
	PH.Name AS 'Physician Name', PH.Phone AS 'Physician Phone'
From 
	Patients AS P
INNER JOIN 
	Physicians AS PH
ON	
	p.Id = ph.id
Order by 
	p.Name asc;

/*2*/
USE Medical
GO
SELECT 
	P.Name as 'Physician Name', 
	P.Phone as 'Physician Phone', 
	H.Name as 'Hospital Name', 
	H.Address as 'Hospital Address', 
	H.Phone as 'Hospital Phone'
FROM 
	Physicians as P
INNER JOIN 
	Hospitals AS H
ON 
	P.Id = H.Id
Order by 
	P.Name asc;

/*3*/
USE 
	Medical
GO
SELECT 
	P.Name as 'Patient Name',
	M.Name as 'Medical Plan',
	M.Phone as 'Medical Phone'
FROM
	Patients AS P
INNER JOIN
	MedicalPlans AS M
ON
	P.Id = M.Id
Order by
	P.Name asc;

/*4*/
USE
	Medical
GO
SELECT 
	P.Name as 'Patient Name',
	M.Name as 'Medical Plan',
	PH.Name as 'Physician Name',
	P.KinName as 'Patient Kin',
	P.KinPhone AS 'Patient Kin Phone'
FROM
	Patients as P
JOIN
	MedicalPlans as M
ON
	P.Id = M.Id
JOIN
	Physicians as PH
ON
	P.Id = PH.Id
Order by
	P.Name ASC;

/*5*/
USE
	Medical
GO
SELECT
	O.Id AS 'Operation ID',
	MP.name AS 'Procedure',
	P.Name AS 'Patient',
	PH.Name AS 'Physician',
	H.Name AS 'Hospital'	
FROM
	Operations AS O
JOIN
	MedicalProcedures AS MP
ON
	O.Id = MP.Id
JOIN
	Patients AS P
ON
	O.Id = P.Id
JOIN
	Physicians AS PH
ON
	O.Id = PH.ID
JOIN
	Hospitals AS H
ON
	O.Id = H.Id
Order by
	O.Id ASC;

/*6*/
USE
	Ch07_Fact
GO
SELECT
	AU.AU_LNAME,
	AU.AU_FNAME,
	W.BOOK_NUM
FROM
	AUTHOR AS AU
Join
	WRITES AS W
ON
	AU.AU_ID = W.AU_ID
Order by
	AU.AU_LNAME,
	AU.AU_FNAME,
	W.BOOK_NUM;
/*7*/
USE
	Ch07_Fact
GO
SELECT
	AU.AU_ID,
	W.BOOK_NUM,
	B.BOOK_TITLE,
	B.BOOK_SUBJECT
FROM
	AUTHOR AS AU
JOIN
	WRITES AS W
ON
	AU.AU_ID = W.AU_ID
JOIN
	BOOK AS B
ON
	W.BOOK_NUM = B.BOOK_NUM
Order by
	B.BOOK_COST,
	AU.AU_ID;
/*8*/
USE
	Ch07_Fact
GO
SELECT
	A.AU_LNAME,
	A.AU_FNAME,
	B.BOOK_TITLE,
	B.BOOK_COST
FROM	
	AUTHOR AS A
JOIN
	WRITES AS W
ON
	A.AU_ID = W.AU_ID
JOIN
	BOOK AS B
ON
	W.BOOK_NUM = B.BOOK_NUM
ORDER BY
	B.BOOK_NUM, 
	A.AU_ID;
/*9*/
USE
	Ch07_Fact
GO
SELECT
	P.PAT_ID,
	B.BOOK_NUM,
	P.PAT_FNAME,
	P.PAT_LNAME,
	B.BOOK_TITLE
FROM 
	PATRON	AS	P
JOIN
	BOOK	AS	B
ON
	P.PAT_ID	=	B.PAT_ID
ORDER BY
	P.PAT_LNAME,
	B.BOOK_TITLE;
/*10*/
USE
	Ch07_Fact
GO
SELECT
	A.AU_ID,
	A.AU_FNAME,
	A.AU_LNAME,
	B.BOOK_NUM,
	B.BOOK_TITLE
FROM
	AUTHOR		AS		A
JOIN
	WRITES		AS		W
ON
	A.AU_ID		=		W.AU_ID
JOIN
	BOOK		AS		B
ON
	W.BOOK_NUM	=	B.BOOK_NUM
WHERE
	B.BOOK_SUBJECT LIKE '%CLOUD'
ORDER BY
	B.BOOK_TITLE,
	A.AU_LNAME;
/*11*/
USE
	Ch07_Fact
GO
SELECT
	B.BOOK_NUM,
	B.BOOK_TITLE,
	A.AU_LNAME,
	A.AU_FNAME,
	P.PAT_ID,
	P.PAT_LNAME,
	P.PAT_TYPE
FROM
	BOOK	AS	B
JOIN
	WRITES	AS	W
ON
	B.BOOK_NUM	=	W.BOOK_NUM
JOIN
	AUTHOR	AS	A
ON
	W.AU_ID		=	A.AU_ID
JOIN
	PATRON	AS	P
ON
	P.PAT_ID	=	B.PAT_ID
	
ORDER BY
	B.BOOK_TITLE;
/*12*/
USE
	Ch07_Fact
GO
SELECT
	p.PAT_ID,
	P.PAT_FNAME,
	P.PAT_LNAME
FROM
	PATRON	as P
LEFT JOIN
	CHECKOUT	AS	C
ON
	C.PAT_ID	=	P.PAT_ID
WHERE
	C.CHECK_NUM IS NULL
ORDER BY
	P.PAT_LNAME,
	P.PAT_FNAME







 




