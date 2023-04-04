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