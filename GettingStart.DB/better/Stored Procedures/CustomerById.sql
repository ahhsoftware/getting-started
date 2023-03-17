--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Selects customer for the given CustomerId, parameter validation, no return values.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerById]
(
	--+Required
    @CustomerId int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        [CustomerId],
        [FirstName],
        [LastName],
        [Email]
    FROM
        [dbo].[Customer]
    WHERE
        [CustomerId] = @CustomerId;
 
END;