--+SqlPlusRoutine
    --&SelectType=NonQuery
    --&Comment=Clears the customer table. Do not use this in production environment.
    --&Author=Author
--+SqlPlusRoutine
CREATE PROCEDURE [admin].[PrepareForTests]
AS
BEGIN
	
	SET NOCOUNT ON;

    TRUNCATE TABLE [dbo].[Customer];

END