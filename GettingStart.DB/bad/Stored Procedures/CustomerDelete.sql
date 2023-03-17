--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId, no parameter validation, no return values.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [bad].[CustomerDelete]
(
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;