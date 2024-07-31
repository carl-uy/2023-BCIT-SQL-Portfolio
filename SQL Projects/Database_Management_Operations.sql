/* Drop and Recreate the Database */
USE [master];
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name='A01341011_6';
GO
IF EXISTS(select * from sys.databases where name='A01341011_6')
	ALTER DATABASE [A01341011_6] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE IF EXISTS [A01341011_6];
GO
CREATE DATABASE [A01341011_6];
GO
USE [A01341011_6];
GO
USE A01341011_6;
GO
/*Create user-defined data type*/
--#1
DROP TYPE IF EXISTS
	[Id_DataType] 
GO
CREATE TYPE 
	[Id_DataType] 
	FROM CHAR(5) NULL;
GO
--#2
DROP TYPE IF EXISTS 
	[ISBN] 
GO
CREATE TYPE 
	[ISBN] 
	FROM CHAR(13) NULL;
GO
DROP RULE IF EXISTS [ISBN]
GO
CREATE RULE [ISBN]
AS
@value like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]-[0-9]'
GO
--#3
DROP TABLE IF EXISTS 
	[Author]
GO
CREATE TABLE Author(
	[Id]		[Id_DataType] NOT NULL PRIMARY KEY,
	[LastName]		NVARCHAR(255),
	[FirstName]		NVARCHAR(255),
	[MiddleName]	NVARCHAR(255),
)
GO
DROP TABLE IF EXISTS
	Publisher
GO
CREATE TABLE Publisher(
	[Id]		[Id_DataType] NOT NULL PRIMARY KEY,
	[Name]				NVARCHAR(255),
	[Address]			NVARCHAR(255),
	[City]				NVARCHAR(255),
	[Province]			CHAR(2),
	[PostalCode]		CHAR(6),
)
GO
DROP TABLE IF EXISTS
	Branch
GO
CREATE TABLE Branch(
	[Id]		[Id_DataType] NOT NULL PRIMARY KEY,
	[Name]		NVARCHAR(255),
	[Location]	NVARCHAR(255),
	[Staff]		int,
)
Go
DROP TABLE IF EXISTS
	BookType
GO
CREATE TABLE BookType(
	[Id]				CHAR(3)	NOT NULL PRIMARY KEY,
	[Description]		NVARCHAR(255),
)
Go
DROP TABLE IF EXISTS
	BOOK
GO
CREATE TABLE BOOK(
	[Id]			[Id_DataType] NOT NULL PRIMARY KEY,
	[TITLE]				NVARCHAR(255),
	[PRICE]				MONEY,
	[PAPERBACK]			CHAR(1),
	[PublicationDate]	datetime,
	[ISBN]				[ISBN],
	[PublisherId]		[Id_DataType] NOT NULL,
	[AuthorId]				[Id_DataType] NOT NULL,
	[TypeId]			CHAR(3)	NOT NULL,
FOREIGN KEY (PublisherId) REFERENCES Publisher(Id),
FOREIGN KEY (AuthorId) REFERENCES Author(Id),
FOREIGN KEY (TypeId) REFERENCES BookType(Id),
)
GO
DROP TABLE IF EXISTS
	INVENTORY
CREATE TABLE INVENTORY(
	[BookId]		[Id_DataType]  NOT NULL,
	[BranchId]		[Id_DataType]  NOT NULL,
	[InventoryCode]	[INT] NOT NULL
Primary KEY([BookId],[BranchId])
FOREIGN KEY (BookId) REFERENCES BOOK(Id),
FOREIGN KEY (BranchId) REFERENCES Branch(Id),
)
GO
--#5
/*Set defaults*/
ALTER TABLE [BOOK] 
ADD CONSTRAINT [Default_Paperback] DEFAULT ('N') FOR [PAPERBACK];
GO
ALTER TAble [BOOK]
ADD CONSTRAINT [Default_PublicationDate] DEFAULT GETDATE() FOR [PublicationDate];
GO
ALTER TAble [Publisher]
ADD CONSTRAINT [Default_Province] DEFAULT ('BC') FOR [Province];
GO
--#6
/*Add check constraints*/
ALTER TABLE [BOOK] ADD CONSTRAINT [Check_TypeId]
CHECK ([TypeId] LIKE ('[A-Z][A-Z][A-Z]'));
GO
ALTER TABLE [Branch] ADD CONSTRAINT [Check_Branch_Id]
CHECK ([Id] BETWEEN '10000 ' AND '99999');
GO
ALTER TABLE [BookType] ADD CONSTRAINT [Check_BookType]
CHECK ([Id] IN ('FIC','NON','REF'));
GO
--#7
/*Add unique key constraints*/
ALTER TABLE [dbo].[Publisher] ADD CONSTRAINT [Unique_PublisherName] UNIQUE([Name]);
GO
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [Unique_BranchName] UNIQUE([Name]);
GO
--#8
/*Insert data*/
INSERT INTO [Author] (Id, LastName, FirstName, MiddleName)
VALUES ('12345', 'Brown', 'Dan', 'Gerhard');
GO
INSERT INTO [Publisher] (Id, Name, Address, City, Province, PostalCode)
VALUES ('67890','Doubleday','1745 Broadway','New York','NY','10019');
GO
INSERT INTO [Branch](Id, Name, Location, Staff)
VALUES ('11111','Joseph Joestar','Lunen','2');
GO
INSERT INTO [BookType](Id, Description)
VALUES ('FIC','The Da Vinci Code follows symbologist Robert Langdon');
GO
INSERT INTO [BOOK](Id, TITLE, PRICE, PAPERBACK, PublicationDate, ISBN, PublisherId, AuthorId, TypeId)
VALUES ('22222','The Da Vinci Code','13','Y','2003-03-19','9780307474278','67890','12345','FIC');
GO
INSERT INTO [INVENTORY](BookId, BranchId, InventoryCode)
VALUES('22222','11111','2');
GO