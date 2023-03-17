--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id, parameter validation, default values, return values, duplicate index handling
    --&Author=alan@sqlplus.net
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerSave]
(
	--+Input
	--+Default=0
	--+Required
	--+Comment=Set to 0 for an insert, otherwise provide the customer id
    @CustomerId int out,

	--+MaxLength=64
	--+Required
	--+Display=Last Name,Description
    @LastName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Display=First Name,Description
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Email
    @Email varchar(64)
)
AS
BEGIN
 
	SET NOCOUNT ON;

    BEGIN TRY

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
 
			--+Return=Inserted,Customer record was inserted
			RETURN 1;

		END;

		UPDATE [dbo].[Customer] SET
			[LastName] = @LastName,
			[FirstName] = @FirstName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId
 
		IF @@ROWCOUNT = 0
		BEGIN
			--+Return=NotFound,No customer found for the given id
			RETURN 2;
		END;
 
		--+Return=Modified,Customer record was modified
		RETURN 3;

	END TRY
	BEGIN CATCH
		
		IF ERROR_NUMBER() = 2601
		BEGIN
			--+Return=Duplicate,Cannot insert duplicate email
			RETURN 0;
		END;

		THROW;

	END CATCH
END;