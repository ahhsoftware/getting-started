--+SqlPlusRoutine
	--&SelectType=NonQuery
    --&Author=alan@sqlplus.net
    --&Comment=Deletes customer for the given CustomerId, parameter validation, return values.
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[CustomerDelete]
(
	--+Required
	--+Comment=The customer id for the record to delete.
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
		RETURN 101;
	END
 
	--+Return=OK,Customer was deleted
	RETURN 1;

END;