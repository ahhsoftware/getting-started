USE [GettingStarted]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerTypeId] [tinyint] NOT NULL,
	[FirstName] [nvarchar](64) NOT NULL,
	[LastName] [nvarchar](64) NOT NULL,
	[Email] [varchar](256) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerType]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerType](
	[CustomerTypeId] [tinyint] NOT NULL,
	[Name] [varchar](32) NOT NULL,
	[Description] [varchar](256) NOT NULL,
 CONSTRAINT [PK_CustomerType] PRIMARY KEY CLUSTERED 
(
	[CustomerTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 4/3/2023 8:35:07 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_CustomerType] FOREIGN KEY([CustomerTypeId])
REFERENCES [dbo].[CustomerType] ([CustomerTypeId])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_CustomerType]
GO
/****** Object:  StoredProcedure [dbo].[CustomerDelete]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
	--&SelectType=NonQuery
    --&Author=alan@sqlplus.net
    --&Comment=Deletes customer for the given CustomerId, parameter validation, return values.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerDelete]
(
	--+Required
	--+Comment=The customer id for the record to delete.
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.Customer
    WHERE
        [CustomerId] = @CustomerId;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NotFound,No record was deleted
		RETURN 101;
	END
 
	--+Return=OK,Customer was deleted
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [dbo].[CustomerQuery]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
	--&SelectType=MultiRow
    --&Author=alan@sqlplus.net
    --&Comment=Gets all customers.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerQuery]
(
	--+Required
	--+Range=10,50
	--+Default=10
	--+Comment=Supply a value in the range of 10-50
	@PageSize int,

	--+Required
	--+Default=1
	--+Comment=The page to return, default is 1
	@PageNumber int,
	
	--+Comment=Returns the number of pages available
	@PageCount int out
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
	DECLARE
		@RowCount int,
		@PageOffset int;
		
	SET @PageNumber -= 1;
	
	SELECT @RowCount = COUNT(1) FROM [dbo].[Customer];
	
	SET @PageCount = @RowCount/@PageSize;
	
	IF (@PageSize * @PageCount) < @RowCount
	BEGIN
		SET @PageCount += 1;
	END;
	
	SET @PageOffset = (@PageSize * @PageNumber);

    SELECT
        [CustomerId],
		[CustomerTypeId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
	ORDER BY
		[Email]
	OFFSET
		@PageOffset ROWS FETCH NEXT @PageSize ROWS ONLY;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NoRecords
		RETURN 101;
	END;
	
	--+Return=Ok
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [dbo].[CustomerSave]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
	--&SelectType=NonQuery
	--&Author=alan@sqlplus.net
    --&Comment=Inserts or updates the customer based on the value of the customer id.
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
	--+Comment=Customers primary email address
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
GO
/****** Object:  StoredProcedure [dbo].[CustomerSave_V1]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
	--&SelectType=NonQuery
	--&Author=alan@sqlplus.net
    --&Comment=Inserts or updates the customer based on the value of the customer id.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerSave_V1]
(
	--+InOut
    @CustomerId int out,

	@CustomerTypeId tinyint,

    @FirstName nvarchar(64),

    @LastName nvarchar(64),

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
GO
/****** Object:  StoredProcedure [dbo].[CustomerSave_V2]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [dbo].[CustomerSelect]    Script Date: 4/3/2023 8:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
	--&SelectType=SingleRow
    --&Author=alan@sqlplus.net
    --&Comment=Selects customer for the given CustomerId.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerSelect]
(
	--+Required
	@CustomerId int
)
AS
BEGIN

	SELECT
		[CustomerId],
		[CustomerTypeId],
		[FirstName],
		[LastName], 
		[Email]
	FROM
		[dbo].[Customer]
	WHERE
		[CustomerId] = @CustomerId;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NotFound,No customer found for the given id
		RETURN 101;
	END;

	--+Return=Ok,Customer retrieved
	RETURN 1;

END;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
DECLARE @CustomerTypeValues As TABLE 
(
	[CustomerTypeId] TINYINT, 
	[Name] NVARCHAR(64), 
	[Description] NVARCHAR(64)
)

INSERT INTO @CustomerTypeValues
VALUES
(1,'Residential', 'Residential Customers'),
(2,'Commercial', 'Commercial Customers')

MERGE INTO [dbo].[CustomerType] t
USING @CustomerTypeValues s on t.CustomerTypeId = s.CustomerTypeId
WHEN NOT MATCHED THEN
	INSERT
	(
		[CustomerTypeId],
		[Name],
		[Description]
	)
	VALUES
	(
		s.[CustomerTypeId],
		s.[Name],
		s.[Description]
	)
WHEN MATCHED THEN
	UPDATE SET
		t.[Name] = s.[Name],
		t.[Description] = s.[Description];
		
