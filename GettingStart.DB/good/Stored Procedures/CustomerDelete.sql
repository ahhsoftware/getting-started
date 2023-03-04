--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Deletes customer for the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerDelete]
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