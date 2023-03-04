--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Inserts a new customer.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerInsert]
(
    @CustomerId int out,

	--+Required
	--+MaxLength=64
    @FirstName varchar(64),

	--+Required
	--+MaxLength=64
    @LastName varchar(64),

	--+Required
	--+MaxLength=64
	--+Email
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