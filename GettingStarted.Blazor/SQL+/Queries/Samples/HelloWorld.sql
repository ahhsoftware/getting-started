/*
    To build services based on queries, include a routine tag with the desired select type, comment, and author.
    In this case only a single row is returned.
*/

--+SqlPlusRoutine
    --&SelectType=SingleRow
    --&Comment=Simple service to return a welcome message based on the users name.
    --&Author=Alan@SQLPlus.net
--+SqlPlusRoutine

/*
    Declare the set of variables that you want to pass into the generated service 
    and encapsulate them in a pair of parameter tags.

    Note that any values assigned to these variables are ignored by the builder.

    By default all variables are created as input parameters. to override this behavior
    you can use:
        1) --+InOut tag 
        2) --+Output tag
   
    The variable name ReturnValue emulates a stored procedure return value and may optionally be enumerated.
*/

--+Parameters

    DECLARE

	--+Required
	--+MaxLength=32
	@Name varchar(32) = 'ValueOf@Name',

    --+Output
    @ReturnValue int

--+Parameters

/* Your SQL statement(s) here note that Multiple Results are fully supported */

SELECT CONCAT('Hello ', @Name, ', Welcome to SQL+')  AS WelcomMessage;

/*  If you use the special name @ReturnValue in tandem with the the output tag,
    you can enumerate the return values as follows.
*/

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