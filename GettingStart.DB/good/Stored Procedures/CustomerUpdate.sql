--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Modified existing customer the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [good].[CustomerUpdate]
(
    @CustomerId int,
    @FirstName varchar(64),
    @LastName varchar(64),
    @Email varchar(64)
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    UPDATE [dbo].[Customer] SET
        [FirstName] = @FirstName,
        [LastName] = @LastName,
        [Email] = @Email
    WHERE
        [CustomerId] = @CustomerId;

END;