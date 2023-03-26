--+SqlPlusRoutine
    --&SelectType=SingleRow
    --&Comment=Simple service to return a welcome message based on the users name.
    --&Author=Alan@SQLPlus.net
--+SqlPlusRoutine

--+Parameters

    DECLARE

	--+Required
	--+MaxLength=32
	@Name varchar(32) = 'ValueOf@Name',

    --+Output
    @ReturnValue int

--+Parameters

SELECT CONCAT('Hello ', @Name, ', Welcome to SQL+')  AS WelcomMessage;


IF @@ROWCOUNT = 0
BEGIN
    --+Return=NotFound
    SET @ReturnValue=0;
END;
ELSE
BEGIN
    --+ReturnValue=Ok
    SET @ReturnValue = 1;
END;