--+SqlPlusRoutine
    --&Author=Alan@SQLPlus.net
    --&Comment=Modified existing customer the given CustomerId.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [better].[CustomerUpdate]
(
	--+Required
    @CustomerId int,

    --+Required
	--+MaxLength=64
    @FirstName varchar(64),

	--+Required
	--+MaxLength=64
    @LastName varchar(64),

	--+Required
	--+MaxLength=64
	--+Email
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