USE __DATABASE_NAME__
GO

IF EXISTS (SELECT *
           FROM sys.objects
           WHERE object_id = OBJECT_ID(N'__SCHEMA_NAME__.__TABLE_NAME__')
                 AND type IN (N'U'))
    DROP TABLE
      __SCHEMA_NAME__.__TABLE_NAME__
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT *
               FROM sys.objects
               WHERE object_id = OBJECT_ID(N'__SCHEMA_NAME__.__TABLE_NAME__')
                     AND type IN (N'U'))
  BEGIN
    CREATE TABLE
      __SCHEMA_NAME__.__TABLE_NAME__
        (
            __TABLE_NAME__ID  BIGINT        NOT NULL
                              IDENTITY(1,1)
                              CONSTRAINT
                                PK___TABLE_NAME__
                              PRIMARY KEY CLUSTERED
          , __TABLE_NAME_Name VARCHAR(128)   NOT NULL
          , __TABLE_NAME_Desc VARCHAR(512)   NULL
        )
  END
GO
