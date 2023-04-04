DECLARE @CustomerTypeValues As TABLE 
(
	[CustomerTypeId] TINYINT, 
	[Name] VARCHAR(32), 
	[Description] VARCHAR(256)
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

--SELECT * FROM [dbo].[CustomerType]