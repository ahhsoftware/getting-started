
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