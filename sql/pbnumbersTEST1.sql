USE [NUMBERS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Numbers](
	[Date] [date] NOT NULL,
	[Number1] [int] NOT NULL,
	[Number2] [int] NOT NULL,
	[Number3] [int] NOT NULL,
	[Number4] [int] NOT NULL,
	[Number5] [int] NOT NULL,
	[PowerBall] [int] NOT NULL
) ON [PRIMARY]
GO

BULK INSERT [dbo].[Numbers]
    FROM '\\insertPC-Name\Users\mstillson\Desktop\today\pbnumbers\pbNumbers.csv'
    WITH(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\r,\n'   --Use to shift the control to next row
    -- ERRORFILE = '\\ultimatemedical.local\public\Information Technology\Matt\PickUps\NewHire9-18Errrors.csv'
);
GO

CREATE TABLE [dbo].[PBNumOccurences](
  [Number1] [int] NOT NULL,
  [Occurences1] NVARCHAR(20) NOT NULL,
	[Number2] [int] NOT NULL,
  [Occurences2] NVARCHAR(20) NOT NULL,
	[Number3] [int] NOT NULL,
  [Occurences3] NVARCHAR(20) NOT NULL,
	[Number4] [int] NOT NULL,
  [Occurences4] NVARCHAR(20) NOT NULL,
	[Number5] [int] NOT NULL,
  [Occurences5] NVARCHAR(20) NOT NULL,
	[PowerBall] [int] NOT NULL,
  [PowerBallOcc] NVARCHAR(20) NOT NULL
) ON [PRIMARY]
GO

SELECT * FROM Numbers
INSERT INTO [dbo].[PBNumOccurences] ( [Number1],[Occurences1])
SELECT [Number1], COUNT([Number1]) as Occurences1 FROM Numbers GROUP BY [Number1] ORDER BY Occurences1 DESC


SELECT [Number2], COUNT([Number2]) as Occurences2 FROM Numbers group by [Number2] ORDER BY Occurences2 DESC

SELECT [Number3], COUNT([Number3]) as Occurences3 FROM Numbers group by [Number3] ORDER BY Occurences3 DESC

SELECT [Number4], COUNT([Number4]) as Occurences4 FROM Numbers group by [Number4] ORDER BY Occurences4 DESC

SELECT [Number5], COUNT([Number5]) as Occurences5 FROM Numbers group by [Number5] ORDER BY Occurences5 DESC

SELECT [PowerBall], COUNT([PowerBall]) as PowerBallOcc FROM Numbers group by [PowerBall] ORDER BY PowerBallOcc DESC