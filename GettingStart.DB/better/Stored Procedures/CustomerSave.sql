--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, parameter validation, default values, no return values, no duplicate index handling
    --&Author=Author
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerSave]
(
	--+Input
	--+Default=0
	--+Required
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

	--+MaxLength=64
	--+Required
    @LastName nvarchar(64),

	--+MaxLength=64
	--+Required
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Email
    @Email varchar(64)
)
AS
BEGIN
 
    SET NOCOUNT ON;

	IF @CustomerId = 0
	BEGIN
		
		INSERT INTO [dbo].[Customer]
		(
			[LastName],
			[FirstName],
			[Email]
		)
		VALUES
		(
			@LastName,
			@FirstName,
			@Email
		);
 
		SET @CustomerId = SCOPE_IDENTITY();

	END
	ELSE
	BEGIN

		UPDATE [dbo].[Customer] SET
			[LastName] = @LastName,
			[FirstName] = @FirstName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId;

	END;

END;