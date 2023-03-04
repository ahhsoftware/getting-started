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