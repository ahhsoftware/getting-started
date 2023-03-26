--+SqlPlusRoutine
	--&SelectType=NonQuery
	--&Author=alan@sqlplus.net
    --&Comment=Inserts or updates the customer based on the value of the customer id. Includes parameter validation, default values, return values, duplicate index handling, foreign key handling.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerSave]
(
	--+InOut
	--+Default=0
	--+Required
	--+Comment=Set to 0 for an insert, existing customer id for an update
    @CustomerId int out,

	--+Required
	--+Comment=Set to one of the CustomerTypes, foreign key check
	--+Display=Customer Type,Description
	@CustomerTypeId tinyint,

	--+MaxLength=64
	--+Required
	--+Display=First Name,Description
	--+Comment=Customers first (given) name
    @FirstName nvarchar(64),

	--+MaxLength=64
	--+Required
	--+Display=Last Name,Description
	--+Comment=Customers last (family) name
    @LastName nvarchar(64),

	--+MaxLength=256
	--+Required
	--+Email
	--+Comment=Customers email address
    @Email varchar(256)
)
AS
BEGIN
 
	SET NOCOUNT ON;

    BEGIN TRY

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
 
			--+Return=Inserted,New customer added
			RETURN 1;

		END;

		UPDATE [dbo].[Customer] SET
			[CustomerTypeId] = @CustomerTypeId,
			[FirstName] = @FirstName,
			[LastName] = @LastName,
			[Email] = @Email
		WHERE
			[CustomerId] = @CustomerId;
 
		IF @@ROWCOUNT = 0
		BEGIN
			--+Return=NotFound,No customer found for the given id
			RETURN 101;
		END;
 
		--+Return=Modified,Customer record was modified
		RETURN 2;

	END TRY
	BEGIN CATCH
		
		IF ERROR_NUMBER() = 2601
		BEGIN
			--+Return=Duplicate,Cannot insert duplicate email
			RETURN 102;
		END;

		IF ERROR_NUMBER() = 547
		BEGIN
			--+Return=ForeignKeyViolation,Not a valid Customer Type
			RETURN 103;
		END;

		THROW;

	END CATCH;

END;