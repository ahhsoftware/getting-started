--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers, no parameter validation, no default values, no return values.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[Customers]
(
	@PageSize int,

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

END;