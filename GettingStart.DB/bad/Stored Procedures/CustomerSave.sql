--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, no parameter validation, no default values, no return values, no duplicate index handling
    --&Author=alan@sqlplus.net
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[CustomerSave]
(
	--+InOut
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

    @LastName nvarchar(64),

    @FirstName nvarchar(64),

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