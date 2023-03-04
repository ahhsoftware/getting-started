CREATE PROCEDURE [admin].[GenerateCustomers]
AS
BEGIN
	
	SET NOCOUNT ON;

	TRUNCATE TABLE [dbo].[Customer]
	DECLARE @IDX int = 0;
	WHILE @IDX < 1000
	BEGIN
		BEGIN TRY
			INSERT INTO [dbo].[Customer]
			(
				[FirstName],
				[LastName],
				[Email]
			)
			VALUES
			(
				CONCAT('First_Name_', @IDX),
				CONCAT('Last_Name_', @IDX),
				CONCAT('Email_', @IDX, '@youhoo.new')
			)
		END TRY
		BEGIN CATCH
			PRINT @IDX;
		END CATCH;
		SET @IDX += 1
	END
END