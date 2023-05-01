--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts a new customer record
    --&Author=Alan Hyneman
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerInsert]
(
	@CustomerId int out,
	@CustomerTypeId tinyint,
	@FirstName nvarchar(64),
	@LastName nvarchar(64),
    @Email varchar(256)
)
AS
BEGIN

	INSERT INTO [dbo].[Customer]
    (
		[CustomerTypeId],
        [FirstName],
        [LastName],
        [Email]
	)
    VALUES
    (
		@CustomerTypeId,
        @FirstName,
        @LastName,
        @Email
	);

	SET @CustomerId = SCOPE_IDENTITY();

END;