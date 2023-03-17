--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId, parameter validation, return values.
    --&SelectType=SingleRow
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