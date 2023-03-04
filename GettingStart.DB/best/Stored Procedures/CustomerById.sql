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