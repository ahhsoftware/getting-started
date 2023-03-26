CREATE TABLE [dbo].[Customer] (
    [CustomerId]     INT           IDENTITY (1, 1) NOT NULL,
    [CustomerTypeId] TINYINT       NOT NULL,
    [FirstName]      NVARCHAR (64) NOT NULL,
    [LastName]       NVARCHAR (64) NOT NULL,
    [Email]          VARCHAR (256) NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([CustomerId] ASC),
    CONSTRAINT [FK_Customer_CustomerType] FOREIGN KEY ([CustomerTypeId]) REFERENCES [dbo].[CustomerType] ([CustomerTypeId])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer_Email]
    ON [dbo].[Customer]([Email] ASC);

