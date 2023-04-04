--+SqlPlusRoutine
	--&SelectType=NonQuery
	--&Author=alan@sqlplus.net
    --&Comment=Inserts or updates the customer based on the value of the customer id.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerSave_V2]
(
	--+InOut
	--+Default=0
	--+Required
    @CustomerId int out,

	--+Required
	@CustomerTypeId tinyint,

	--+MaxLength=64
	--+Required
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
    @LastName nvarchar(64),

	--+MaxLength=256
	--+Required
	--+Email
    @Email varchar(256)
)
AS
BEGIN
 
	SET NOCOUNT ON;
	IF @CustomerId = 0
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

	END
	ELSE
	BEGIN

		UPDATE [dbo].[Customer] SET
			[CustomerTypeId] = @CustomerTypeId,
			[FirstName] = @FirstName,
			[LastName] = @LastName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId;

	END;
END;