CREATE TABLE [dbo].[Customer] (
    [CustomerId] INT          IDENTITY (1, 1) NOT NULL,
    [FirstName]  VARCHAR (64) NOT NULL,
    [LastName]   VARCHAR (64) NOT NULL,
    [Email]      VARCHAR (64) NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email]
    ON [dbo].[Customer]([Email] ASC);

