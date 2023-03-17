
CREATE FUNCTION dbo.GetFilterCriteria
(
	@ComparisonTypeId int,
	@ColumnName varchar(64),
	@Criteria varchar(64)
)
RETURNS varchar(256)
AS
BEGIN

--1.Equals,
--2.StartsWith
--3.Contains
--4.EndsWith
--5.GreaterThan
--6.GreatThanOrEqual
--7.LessThan
--8.LessThanOrEqual


	IF @ComparisonTypeId = 1
	BEGIN
		RETURN CONCAT(@ColumnName,' = ''', @Criteria, '''');
	END;

	IF @ComparisonTypeId = 2
	BEGIN
		RETURN CONCAT(@ColumnName,' LIKE ''', @Criteria, '%''');
	END;

	IF @ComparisonTypeId = 3
	BEGIN
		RETURN CONCAT(@ColumnName,' LIKE ''%', @Criteria, '%''');
	END;

	IF @ComparisonTypeId = 4
	BEGIN
		RETURN CONCAT(@ColumnName,' LIKE ''%', @Criteria, '''');
	END;

	IF @ComparisonTypeId = 5
	BEGIN
		RETURN CONCAT(@ColumnName,' > ''', @Criteria, '''');
	END;

	IF @ComparisonTypeId = 6
	BEGIN
		RETURN CONCAT(@ColumnName,' >= ''', @Criteria, '''');
	END;

	IF @ComparisonTypeId = 7
	BEGIN
		RETURN CONCAT(@ColumnName,' < ''', @Criteria, '''');
	END;

	IF @ComparisonTypeId = 8
	BEGIN
		RETURN CONCAT(@ColumnName,' <= ''', @Criteria, '''');
	END;

	RETURN NULL;
END