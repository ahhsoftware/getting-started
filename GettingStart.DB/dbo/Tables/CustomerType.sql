CREATE TABLE [dbo].[CustomerType] (
    [CustomerTypeId] TINYINT       NOT NULL,
    [Name]           VARCHAR (32)  NOT NULL,
    [Description]    VARCHAR (256) NOT NULL,
    CONSTRAINT [PK_CustomerType] PRIMARY KEY CLUSTERED ([CustomerTypeId] ASC)
);

