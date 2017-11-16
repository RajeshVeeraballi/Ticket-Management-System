
CREATE TABLE  issues (
  issue_id int NOT NULL identity(1,1),
  uid varchar(7) NOT NULL,
  issue_type_id int NOT NULL,
  dept_id int NOT NULL,
  user_id int NOT NULL,
  description text NOT NULL,
  status_id int NOT NULL,
  date datetime NOT NULL,
  PRIMARY KEY (issue_id), 
  foreign key ( issue_type_id ) references [dbo].[issue_types] ([issue_type_id]),
  foreign key ( dept_id ) references [dbo].[departments] ([dept_id]),
  foreign key ( user_id ) references [dbo].[user_info] ([user_id]),
  foreign key ( status_id ) references [dbo].[status_types] ([status_id])
  )

  CREATE TABLE  user_info (
  user_id int NOT NULL Identity(1,1),
  ur_id varchar(8) NOT NULL,
  password char(41) NOT NULL,
  firstname varchar(45) NOT NULL,
  lastname varchar(45) NOT NULL,
  email varchar(60) NOT NULL,
  phone_number varchar(10) NOT NULL,
  date datetime NOT NULL,
  PRIMARY KEY (user_id))
  
   
CREATE TABLE  issue_activity_tracking_logs (
  issue_tracking_id int identity(1,1),
  dept_id int NOT NULL,
  status_id int NOT NULL,
  issue_id int NOT NULL,
  date_time datetime NOT NULL,
  PRIMARY KEY (issue_tracking_id),
  foreign key ( dept_id ) references [dbo].[departments] ([dept_id]),
  foreign key ( status_id ) references [dbo].[status_types] ([status_id]),
  foreign key ( issue_id ) references [dbo].[issues] (issue_id)
) 


CREATE TABLE Department_Personnel
(
    DepartmentId int not null,
    UserId int not null,
    foreign key ( UserId ) references [dbo].[user_info] ([user_id])
)


CREATE TABLE issue_type (
  issue_type_id int identity(1,1),
  issue_type varchar(30) NOT NULL,
  PRIMARY KEY (issue_type_id)
) 

CREATE TABLE status_types (
  status_id  int identity(1,1),
  status_type varchar(30) NOT NULL,
  PRIMARY KEY (status_id)
) 

CREATE TABLE departments (
  dept_id int identity(1,1),
  dept_name varchar(45) NOT NULL,
  dept_incharge varchar(45) NOT NULL,
  PRIMARY KEY (dept_id)
)


-- Created Non-Clustered Index on dept_id in issues table

CREATE INDEX INDX_Issue_DeptId ON Issues (dept_Id)


INSERT INTO [status_types] VALUES ('Open'),('Closed')


INSERT INTO departments (dept_name, dept_incharge) VALUES
('technical', 'paul'),
('electrical', 'john'),
('Interior/Furniture', 'rajesh'),
('Gardening/Playground', 'ram')


INSERT INTO Department_Personnel values (1,1),(2,2),(3,3),(4,4)

INSERT INTO issue_types values ('computer'),('internet'),('interior'),('lawn'),('other')


--STORED PROCEDURES

/* this SP is used to check if the user exists and returns the user id, 
if user does not exists then it returns 0 */
USE [Ticketing]
go
CREATE PROCEDURE [dbo].[uspCheckIfUserExists] @Name VARCHAR(8), @Password CHAR(41)
AS
DECLARE @Exists INT
    IF EXISTS (SELECT * FROM [dbo].[user_info] WHERE ur_id= @Name and [password]=@Password)
    set @Exists= (SELECT [user_id] FROM [dbo].[user_info] WHERE ur_id= @Name and [password]=@Password)
	else
	set @Exists= 0
	RETURN @Exists
GO

/* this SP will insert into user info and return userid*/
USE [Ticketing]
GO

CREATE PROCEDURE [dbo].uspCreateUser @UserName VARCHAR(8), @FirstName VARCHAR(45), @LastName VARCHAR(45), @Password CHAR(41), @Email VARCHAR(60), @Phone varchar(10)
AS
DECLARE @UserId INT
	INSERT INTO user_info VALUES
	(
      @UserName
      ,@Password
      ,@FirstName
      ,@LastName
      ,@Email
      ,@Phone
      ,GETDATE()
	  )

	  set @UserId=( select SCOPE_IDENTITY())

	  return @UserId
GO

/* this SP is used insert an new issue into issues table*/
USE [Ticketing]
GO
create PROCEDURE [dbo].uspCreateTicket @IssueType int, @DeptId int, @UserId int, @Description text 
AS
	INSERT INTO [dbo].[issues] VALUES
	(
      ''
      ,@IssueType
      ,@DeptId
      ,@UserId
      ,@Description
      ,1
      ,GETDATE()
	  )
	  update [issues] set uid='issue'+( select CAST( SCOPE_IDENTITY() as VARCHAR)) where [issue_id]= ( select SCOPE_IDENTITY()) --bascically I am getting issueid and appending into issue and storing it uid column--

GO

USE [Ticketing]
GO


-- STORED PROCEDURE by using JOINS

/* this SP is done using joins and gets all the issues for a user depending on the department he belongs to*/
USE [Ticketing]
GO
CREATE PROCEDURE [dbo].uspGetIssues @UserId int
AS
	
	SELECT issue_id,[issue_type],[description],[status_type],[issues].[date], [firstname]+' '+ [lastname] as CreatedBy 
	FROM [dbo].[user_info]
	JOIN [dbo].[Department_Personnel] ON [dbo].[Department_Personnel].UserId=[user_info].[user_id]
	JOIN [dbo].[Departments] ON [Department_Personnel].DepartmentId=[dbo].[Departments].[dept_id]
	JOIN [dbo].[issues] ON [dbo].[issues].[dept_id]=[dbo].[Departments].[dept_id]
	JOIN [issue_types] ON [issues].[issue_type_id]=[issue_types].[issue_type_id]
	JOIN [dbo].[status_types] ON [issues].[status_id]=[dbo].[status_types].[status_id]

	where [user_info].[user_id]=@UserId

GO


/* this will get all the activity for the issue */

	USE [Ticketing]
GO

CREATE PROCEDURE [dbo].[uspGetIssueActivity] @IssueId int
AS

SELECT
	*
FROM V_IssueActivity_Details

WHERE issue_id = @IssueId

GO



-- STORED PROCEDURE with Transaction protection and Exception Handling to reassign tickets

/* this will reassign the ticket*/
USE [Ticketing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspReassignTicket] @IssueId int,@deptId int
AS
BEGIN	
  BEGIN TRY
    BEGIN TRANSACTION
	   UPDATE [dbo].[issues] SET [dept_id]= @deptId,date =GETDATE() WHERE  [issue_id]=@IssueId
	COMMIT TRANSACTION	/* If update statement is successfull then commits transaction */
  END TRY 

  BEGIN CATCH
  IF @@TRANCOUNT > 0          /* If update statement fails then the transaction will be rolled back */
    ROLLBACK TRANSACTION;

    DECLARE @ErrorNumber INT = ERROR_NUMBER(); /* This will display the error where it occured */
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

    PRINT 'Error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Error line number: ' + CAST(@ErrorLine AS VARCHAR(10));

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END



-- STORED PROCEDURE with Transaction protection and Exception Handling to close ticket


/* this will close the ticket*/
USE [Ticketing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspCloseTicket] @IssueId int
AS
BEGIN	
  BEGIN TRY
    BEGIN TRANSACTION
	  UPDATE [dbo].[issues] SET [status_id]= 2, date=GETDATE() WHERE  [issue_id]=@IssueId
	COMMIT TRANSACTION	-- If update statement is successfull then commits transaction 
  END TRY 

  BEGIN CATCH
  IF @@TRANCOUNT > 0          -- If update statement fails then the transaction will be rolled back 
    ROLLBACK TRANSACTION;

    DECLARE @ErrorNumber INT = ERROR_NUMBER(); --This will display the error where it occured 
    DECLARE @ErrorLine INT = ERROR_LINE();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();

    PRINT 'Error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
    PRINT 'Error line number: ' + CAST(@ErrorLine AS VARCHAR(10));

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END




--TRIGGERS

/* this trigger will insert an issue into an issue log whenever new issue is created*/
CREATE TRIGGER [dbo].[Issue_INSERT]
       ON [dbo].[issues]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @DeptId INT
	   DECLARE @StatusId INT
       DECLARE @IssueId INT
	   DECLARE @Date DATETIME

 
       SELECT @DeptId = INSERTED.dept_id, @StatusId=INSERTED.status_id, @IssueId=INSERTED.issue_id, @Date=INSERTED.date      
       FROM INSERTED
 
       INSERT INTO issue_activity_tracking_logs
       VALUES(@DeptId, @StatusId,@IssueId,@Date)
END


/* this trigger will insert issue into issue log whenever issue is updated */
CREATE TRIGGER [dbo].[Issue_UPDATE]
       ON [dbo].[issues]
AFTER UPDATE
AS
BEGIN
       SET NOCOUNT ON;
 
       DECLARE @DeptId INT
	   DECLARE @StatusId INT
       DECLARE @IssueId INT
	   DECLARE @Date DATETIME

 
       SELECT @DeptId = INSERTED.dept_id, @StatusId=INSERTED.status_id, @IssueId=INSERTED.issue_id,  @Date=INSERTED.date       
       FROM INSERTED
 iF ( UPDATE( dept_id) OR UPDATE(status_id))
       INSERT INTO issue_activity_tracking_logs
       VALUES(@DeptId, @StatusId,@IssueId,@Date)
END



-- VIEWS

/* this view has issue activity info*/

CREATE VIEW V_IssueActivity_Details
AS SELECT
	issue_id,
	[status_type],
	[dept_name],
	date_time
FROM [dbo].[issue_activity_tracking_logs]
JOIN [dbo].[Department_Personnel]
	ON [dbo].[Department_Personnel].[DepartmentId] = [issue_activity_tracking_logs].[dept_id]
JOIN [dbo].[Departments]
	ON [Department_Personnel].DepartmentId = [dbo].[Departments].[dept_id]
JOIN [dbo].[status_types]
	ON [issue_activity_tracking_logs].[status_id] = [dbo].[status_types].[status_id]



-- FUNCTIONS

/* Calls the function to check the existance of the user before logging in into the portal */

	CREATE FUNCTION dbo.udfCheckIfUserExists(@Name varchar, @Password varchar)
  RETURNS int
  AS
  BEGIN
  DECLARE @Exists INT
    IF EXISTS (SELECT * FROM [dbo].[user_info] WHERE ur_id= @Name and [password]=@Password)
    set @Exists= (SELECT [user_id] FROM [dbo].[user_info] WHERE ur_id= @Name and [password]=@Password)
	else
	set @Exists= 0
	RETURN @Exists
  END