--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Gets all customers.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[Customers]
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer];
END;