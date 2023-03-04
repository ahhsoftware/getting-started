--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Inserts a new customer.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerInsert]
(
    @CustomerId int out,
    @FirstName varchar(64),
    @LastName varchar(64),
    @Email varchar(64)
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    INSERT INTO [dbo].[Customer]
    (
        [FirstName],
        [LastName],
        [Email]
    )
    VALUES
    (
        @FirstName,
        @LastName,
        @Email
    );
 
    SET @CustomerId = SCOPE_IDENTITY();
 
END;