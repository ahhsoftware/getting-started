--+SqlPlusRoutine
	--&SelectType=MultiRow
    --&Author=alan@sqlplus.net
    --&Comment=Gets all customers, parameter validation, default values, return values.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[Customers]
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