CREATE TYPE [dbo].[FilterCriteria] AS TABLE (
    [ComparisonTypeId] INT           NULL,
    [ColumnName]       VARCHAR (256) NULL,
    [Criteria]         VARCHAR (256) NULL);

