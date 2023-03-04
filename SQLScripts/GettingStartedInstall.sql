USE [GettingStarted]
GO
/****** Object:  Schema [admin]    Script Date: 3/4/2023 1:04:03 PM ******/
CREATE SCHEMA [admin]
GO
/****** Object:  Schema [best]    Script Date: 3/4/2023 1:04:03 PM ******/
CREATE SCHEMA [best]
GO
/****** Object:  Schema [better]    Script Date: 3/4/2023 1:04:03 PM ******/
CREATE SCHEMA [better]
GO
/****** Object:  Schema [good]    Script Date: 3/4/2023 1:04:03 PM ******/
CREATE SCHEMA [good]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](64) NOT NULL,
	[LastName] [varchar](64) NOT NULL,
	[Email] [varchar](64) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 3/4/2023 1:04:03 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [admin].[GenerateCustomers]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [admin].[GenerateCustomers]
AS
BEGIN
	
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[Customer]
	DECLARE @IDX int = 0;
	WHILE @IDX < 1000
	BEGIN
		BEGIN TRY
			INSERT INTO [dbo].[Customer]
			(
				[FirstName],
				[LastName],
				[Email]
			)
			VALUES
			(
				CONCAT('First_Name_', @IDX),
				CONCAT('Last_Name_', @IDX),
				CONCAT('Email_', @IDX, '@youhoo.new')
			)
		END TRY
		BEGIN CATCH
			PRINT @IDX;
		END CATCH;
		SET @IDX += 1
	END
END
GO
/****** Object:  StoredProcedure [admin].[PrepareForTests]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Clears the customer table. Do not use this in production environment.
    --&Author=Author
--+SqlPlusRoutine
CREATE PROCEDURE [admin].[PrepareForTests]
AS
BEGIN
	
	SET NOCOUNT ON;

    TRUNCATE TABLE [dbo].[Customer];

END
GO
/****** Object:  StoredProcedure [best].[CustomerById]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=SingleRow
    --&Comment=Selects customer by given CustomerId
    --&Author=Alan@SQLPlus.net
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerById]
(
	--+Required
	@CustomerId int
)
AS
BEGIN

	SELECT
		[CustomerId], [FirstName], [LastName], [Email]
	FROM
		[dbo].[Customer]
	WHERE
		[CustomerId] = @CustomerId;

	IF @@ROWCOUNT = 0
	BEGIN
		--+Return=NotFound,No customer found for the given id
		RETURN 0;
	END;

	--+Return=Ok,Customer retrieved
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [best].[CustomerDelete]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@sqlplus.net
    --&Comment=Deletes customer by id.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [best].[CustomerDelete]
(
	--+Required
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
		RETURN 0;
	END
 
	--+Return=OK,Customer was deleted
	RETURN 1;

END;
GO
/****** Object:  StoredProcedure [best].[Customers]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [best].[Customers]
(
	--+Required
	--+Range=10,50
	@PageSize int,

	--+Required
	--+Default=10
	@PageNumber int,
	
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
		RETURN 0;
	END;
	
	--+Return=Ok
	RETURN 1;


END;
GO
/****** Object:  StoredProcedure [best].[CustomerSave]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Inserts or updates the customer based on the value of the customer id.
    --&Author=Author
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

	IF EXISTS (SELECT 1 FROM [dbo].[Customer] WHERE [Email] = @Email AND [CustomerId] != @CustomerId)
	BEGIN
		--+Return=Duplicate,Cannot insert duplicate email
		RETURN 0;
	END;

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

	SET NOCOUNT ON;
 
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
 
END;
GO
/****** Object:  StoredProcedure [better].[CustomerById]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerById]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [better].[CustomerDelete]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerDelete]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [better].[CustomerInsert]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [better].[Customers]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[Customers]
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer];
END;
GO
/****** Object:  StoredProcedure [better].[CustomerUpdate]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Modified existing customer the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerUpdate]
(
	--+Required
    @CustomerId int,

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
 
    UPDATE [dbo].[Customer] SET
        [FirstName] = @FirstName,
        [LastName] = @LastName,
        [Email] = @Email
    WHERE
        [CustomerId] = @CustomerId;

END;
GO
/****** Object:  StoredProcedure [dbo].[BasicCRUDProcedures]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BasicCRUDProcedures] 
( 
	@SourceSchema varchar(64),
	@SourceTable varchar(64),
	@DestinationSchema varchar(64),
	@AuthorName varchar(256),

/* JBK 01-25-2020 - If true, ALTER stored procedure if it already exists */
	@AllowAlter bit = 1
)
AS
BEGIN

	SET NOCOUNT ON;

	/* JBK 01-25-2020 - Declare three columns tables for different parts of the BUILD process, add an identity seed */

	/* JBK 01-25-2020 - Query columns table has all the columns in the table */
	DECLARE @QueryColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	/* JBK 01-25-2020 - Standard columns table has all columns except timestamp which cannot be inserted or updated */
	DECLARE @StandardColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	/* JBK 01-25-2020 - Where columns table exclude ['image', 'ntext', 'timestamp', 'text', 'xml'] which are not practical in a WHERE condition  */
	DECLARE @WhereColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	DECLARE
		@Idx int,
		/* JBK 01-25-2020 - Declare a @Max for each of the column tables */
		@QueryMax int,
		@StandardMax int,
		@WhereMax int,
		@RequiredAttribute varchar(32),
		@MaxLengthAttribute varchar(32),
		@ParameterType varchar(32),
		@ColumnName varchar(64),
		@IdColumn bit,
		@Out char(4)

	INSERT INTO @QueryColumnsTable

	SELECT
		ORDINAL_POSITION,
		CASE
			WHEN IS_NULLABLE = 'NO' THEN 
				'--+Required' 
			ELSE NULL 
		END RequiredAttribute,
		CASE
			WHEN DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary', 'varbinary') AND CHARACTER_MAXIMUM_LENGTH > 0 THEN
				CONCAT('--+MaxLength=',CHARACTER_MAXIMUM_LENGTH)
			ELSE NULL
		END MaxLengthAttribute,
		/* JBK 01-25-2020 - Allow of MAX length */
		CASE 
			WHEN DATA_TYPE IN ('char', 'nchar', 'binary') THEN
				CONCAT(DATA_TYPE,'(',CHARACTER_MAXIMUM_LENGTH,')')
			WHEN DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary','varbinary') THEN
				CASE WHEN CHARACTER_MAXIMUM_LENGTH > 0 THEN
					CONCAT(DATA_TYPE,'(',CHARACTER_MAXIMUM_LENGTH,')')
				ELSE
					CONCAT(DATA_TYPE,'(MAX)')
				END
			WHEN DATA_TYPE IN ('decimal', 'numeric') THEN
				CONCAT(DATA_TYPE,'(',NUMERIC_PRECISION,',',NUMERIC_SCALE,')')
			WHEN DATA_TYPE IN ('datetime2') THEN
				CONCAT(DATA_TYPE,'(',DATETIME_PRECISION,')')
			ELSE
				DATA_TYPE
		END ParameterType,
		COLUMN_NAME ColumnName,
		CASE 
			WHEN COLUMNPROPERTY(object_id(TABLE_SCHEMA + '.' + TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 THEN
				1
			ELSE
				0
			END IdColumm
	FROM
		INFORMATION_SCHEMA.COLUMNS
	WHERE
		TABLE_SCHEMA = @SourceSchema AND
		TABLE_NAME = @SourceTable
	ORDER BY
		ORDINAL_POSITION;

	/* JBK 01-25-2020 - Fill the Standard Columns table - easy to add a new excluded datatype w/o changing other code */
	INSERT INTO @StandardColumnsTable
		SELECT OrdinalPostion, RequiredAttribute, MaxLengthAttribute, ParameterType, ColumnName, IdColumn 
		FROM @QueryColumnsTable WHERE ParameterType <> 'timestamp'
		ORDER BY OrdinalPostion;

	/* JBK 01-25-2020 - Fill the Where columns table - easy to add a new excluded datatype w/o changing other code */
	INSERT INTO @WhereColumnsTable
		SELECT OrdinalPostion, RequiredAttribute, MaxLengthAttribute, ParameterType, ColumnName, IdColumn 
		FROM @QueryColumnsTable WHERE ParameterType not in ('image', 'ntext', 'timestamp', 'text', 'xml')
		ORDER BY OrdinalPostion;

	/* JBK 01-25-2020 - Set the @Max for the three column tables */
	SELECT @QueryMax = Max(Id) FROM @QueryColumnsTable;
	SELECT @StandardMax = Max(Id) FROM @StandardColumnsTable;
	SELECT @WhereMax = Max(Id) FROM @WhereColumnsTable;

	SET @Idx = 1; 
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Inserts a new record into the ' + @SourceSchema + '.' +@SourceTable + ' table.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';

	/* JBK 01-25-2020 - Output ALTER PROCEDURE if @AllowAlter is true and procedure exists */
	IF @AllowAlter=1 AND object_id(N'[' + @DestinationSchema + N'].[' + @SourceTable + N'Insert]',N'P') IS NOT NULL
	BEGIN
		PRINT 'ALTER PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Insert]'
	END ELSE BEGIN
		PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Insert]'
	END	PRINT '('
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @RequiredAttribute = RequiredAttribute, @MaxLengthAttribute = MaxLengthAttribute, @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn 
		From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'true' SET @Out = ' out' ELSE SET @Out = null;
		IF @IdColumn = 'false'
		BEGIN
			IF @RequiredAttribute IS NOT NULL PRINT Concat('    ', @RequiredAttribute);
			IF @MaxLengthAttribute IS NOT NULL PRINT Concat('    ', @MaxLengthAttribute);
			PRINT '    --+Comment=' + @ColumnName
		END
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType,  @Out, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		PRINT '';
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    INSERT INTO [' + @SourceSchema + '].[' + @SourceTable +']'
	PRINT '    ('
	SET @Idx = 1;
	WHILE @Idx <= @StandardMax
	BEGIN
		/* JBK 01-25-2020 - Exlude data types not valid for INSERT - timestamp */
		Select @ColumnName = ColumnName, @IdColumn = IdColumn From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false' 
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    )'
	PRINT '    VALUES'
	PRINT '    ('
	SET @Idx = 1;
	WHILE @Idx <= @StandardMax
	BEGIN
		/* JBK 01-25-2020 - Exlude data types not valid for INSERT - timestamp */
		Select @ColumnName = ColumnName, @IdColumn = IdColumn From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false'
		BEGIN
			PRINT Concat('        @', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    );'
	PRINT ''
	Select @ColumnName = ColumnName FROM @StandardColumnsTable WHERE IdColumn = 'True';
	IF @ColumnName IS NOT NULL
	BEGIN
		PRINT '    SET @' + @ColumnName + ' = scope_identity();'
		PRINT ''
	END;
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - GO required between stored procedure CREATEs in order to execute in a single transaction */
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Updates record for the ' + @SourceSchema +'.'+@SourceTable + ' table.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';
	/* JBK 01-25-2020 - Output ALTER PROCEDURE if @AllowAlter is true and procedure exists */
	IF @AllowAlter=1 AND object_id(N'[' + @DestinationSchema + N'].[' + @SourceTable + N'Update]',N'P') IS NOT NULL
	BEGIN
		PRINT 'ALTER PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Update]'
	END ELSE BEGIN
		PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Update]'
	END	
	PRINT '('
	SET @Idx = 1; 
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @RequiredAttribute = RequiredAttribute, @MaxLengthAttribute = MaxLengthAttribute, @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn 
		From @StandardColumnsTable WHERE Id = @Idx;
		IF @RequiredAttribute IS NOT NULL PRINT Concat('    ', @RequiredAttribute);
		IF @MaxLengthAttribute IS NOT NULL PRINT Concat('    ', @MaxLengthAttribute);
		PRINT '    --+Comment=' + @ColumnName
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType,  @Out, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		PRINT '';
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    UPDATE [' + @SourceSchema + '].[' + @SourceTable +'] SET'
	SET @Idx = 1; 
	WHILE @Idx <= @StandardMax
	BEGIN
		/* JBK 01-25-2020 - Exclude data types not valid for UPDATE - timestamp */
		Select @ColumnName = ColumnName, @IdColumn = IdColumn, @ParameterType = ParameterType From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'False' AND @ParameterType not in ('timestamp')
		BEGIN
			PRINT Concat('        ', @ColumnName, ' = @', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	SELECT @ColumnName = ColumnName FROM @StandardColumnsTable WHERE IdColumn = 'TRUE'
	PRINT '    WHERE'
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName)
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - GO required between stored procedure CREATEs in order to execute in a single transaction */
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Selects single row from ' + @SourceSchema +'.'+@SourceTable + ' table by identity column.';
	PRINT '    --&SelectType=SingleRow';
	PRINT '--+SqlPlus'+'Routine';

	/* JBK 01-25-2020 - Output ALTER PROCEDURE if @AllowAlter is true and procedure exists */
	IF @AllowAlter=1 AND object_id(N'[' + @DestinationSchema + N'].[' + @SourceTable + N'ById]',N'P') IS NOT NULL
	BEGIN
		PRINT 'ALTER PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'ById]'
	END ELSE BEGIN
		PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'ById]'
	END	

	PRINT '('
	Select @ColumnName = ColumnName, @ParameterType = ParameterType From @WhereColumnsTable WHERE IdColumn = 'True';
	PRINT '    --+Required';
	PRINT '    --+Comment=' + @ColumnName;
	PRINT CONCAT('    @', @ColumnName,' ', @ParameterType);
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    SELECT'
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ColumnName = ColumnName From @QueryColumnsTable WHERE Id = @Idx;
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	SELECT @ColumnName = ColumnName From @WhereColumnsTable WHERE IdColumn = 'True';
	PRINT '    FROM';
	PRINT CONCAT('        ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName, ';');
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - GO required between stored procedure CREATEs in order to execute in a single transaction */
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Deletes single row from ' + @SourceSchema +'.'+@SourceTable + ' table by identity column.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';

	/* JBK 01-25-2020 - Output ALTER PROCEDURE if @AllowAlter is true and procedure exists */
	IF @AllowAlter=1 AND object_id(N'[' + @DestinationSchema + N'].[' + @SourceTable + N'Delete]',N'P') IS NOT NULL
	BEGIN
		PRINT 'ALTER PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Delete]'
	END ELSE BEGIN
		PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Delete]'
	END	

	PRINT '('
	Select @ColumnName = ColumnName, @ParameterType = ParameterType From @StandardColumnsTable WHERE IdColumn = 'True';
	PRINT '    --+Required';
	PRINT '    --+Comment=' + @ColumnName;
	PRINT CONCAT('    @', @ColumnName,' ', @ParameterType);
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	SELECT @ColumnName = ColumnName From @StandardColumnsTable WHERE IdColumn = 'True';
	PRINT CONCAT('    DELETE FROM ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName, ';');
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - GO required between stored procedure CREATEs in order to execute in a single transaction */
	PRINT 'GO'
	PRINT '';
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Queries ' + @SourceSchema +'.'+@SourceTable + ' table.';
	PRINT '    --&SelectType=MultiRow';
	PRINT '--+SqlPlus'+'Routine';

	/* JBK 01-25-2020 - Output ALTER PROCEDURE if @AllowAlter is true and procedure exists */
	IF @AllowAlter=1 AND object_id(N'[' + @DestinationSchema + N'].[' + @SourceTable + N'Query]',N'P') IS NOT NULL
	BEGIN
		PRINT 'ALTER PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Query]'
	END ELSE BEGIN
		PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Query]'
	END	

	PRINT '('
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn From @QueryColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'False'
		BEGIN
		PRINT '    --+Comment=' + @ColumnName
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		PRINT '';
		END;
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    SELECT'
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ColumnName = ColumnName From @QueryColumnsTable WHERE Id = @Idx;
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    FROM';
	PRINT CONCAT('        ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	SET @Idx = 1; 
	WHILE @Idx <= @WhereMax
	BEGIN

			/* JBK 01-25-2020 - Exclude data types not practical for equality comparison */
		Select @ColumnName = ColumnName, @IdColumn = IdColumn, @ParameterType = ParameterType From @WhereColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false' 
		BEGIN
			/* JBK 01-25-2020 - Use STEquals for geometry and geography comparison */
			IF @ParameterType in ('geometry','geography') BEGIN
				PRINT Concat('        (@', @ColumnName, ' IS NULL OR ', @ColumnName, '.STEquals(@', @ColumnName , ') = 1)', (CASE WHEN @Idx < @WhereMax THEN ' AND' ELSE NULL END));
			END ELSE BEGIN
				PRINT Concat('        (@', @ColumnName, ' IS NULL OR ', @ColumnName, ' = @', @ColumnName , ')', (CASE WHEN @Idx < @WhereMax THEN ' AND' ELSE NULL END));
			END
		END;
		SET @Idx += 1;
	END;
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - Finish with a GO as SQL Standard practice */
	PRINT 'GO';
END
GO
/****** Object:  StoredProcedure [good].[CustomerById]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerById]
(
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [good].[CustomerDelete]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerDelete]
(
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;
GO
/****** Object:  StoredProcedure [good].[CustomerInsert]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
/****** Object:  StoredProcedure [good].[Customers]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [good].[Customers]
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer];
END;
GO
/****** Object:  StoredProcedure [good].[CustomerUpdate]    Script Date: 3/4/2023 1:04:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Modified existing customer the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerUpdate]
(
    @CustomerId int,
    @FirstName varchar(64),
    @LastName varchar(64),
    @Email varchar(64)
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    UPDATE [dbo].[Customer] SET
        [FirstName] = @FirstName,
        [LastName] = @LastName,
        [Email] = @Email
    WHERE
        [CustomerId] = @CustomerId;

END;
GO
