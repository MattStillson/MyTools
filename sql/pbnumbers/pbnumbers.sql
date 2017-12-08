USE [master]
GO

DROP DATABASE [PBNumbers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE DATABASE [PBNumbers]
GO

USE [PBNumbers]
GO

CREATE TABLE [dbo].[DrawNumbers](
	[DateOfDraw] [date] NOT NULL,
	[Number1] [int] NOT NULL,
	[Number2] [int] NOT NULL,
	[Number3] [int] NOT NULL,
	[Number4] [int] NOT NULL,
	[Number5] [int] NOT NULL,
	[PowerBall] [int] NOT NULL
) ON [PRIMARY]
GO

SELECT CONVERT(VARCHAR(10), [DateOfDraw], 110) AS [MM-DD-YYYY] FROM [dbo].[DrawNumbers];
GO

INSERT INTO [dbo].[DrawNumbers] ([DateOfDraw],[Number1],[Number2],[Number3],[Number4],[Number5],[PowerBall])
VALUES
('11/1/2017','3','6','19','26','44','1'),
('10/28/2017','27','35','38','57','66','10'),
('10/25/2017','18','22','29','54','57','8'),
('10/21/2017','14','41','42','45','69','4'),
('10/18/2017','30','49','54','66','69','8'),
('10/14/2017','32','37','56','66','69','11'),
('10/11/2017','1','3','13','19','69','23'),
('10/7/2017','10','49','61','63','65','7'),
('10/4/2017','22','23','62','63','66','24'),
('9/30/2017','8','12','25','41','64','15'),
('9/27/2017','8','10','21','23','25','22'),
('9/23/2017','24','45','55','56','57','19'),
('9/20/2017','39','48','53','67','68','26'),
('9/16/2017','17','18','24','25','31','24'),
('9/13/2017','17','24','35','57','63','19'),
('9/9/2017','6','20','29','57','59','22'),
('9/6/2017','8','14','32','58','67','17'),
('9/2/2017','6','21','41','52','62','26'),
('8/30/2017','19','28','43','67','69','7'),
('8/26/2017','7','15','32','38','66','15'),
('8/23/2017','6','7','16','23','26','4'),
('8/19/2017','17','19','39','43','68','13'),
('8/16/2017','9','15','43','60','64','4'),
('8/12/2017','20','24','26','35','49','19'),
('8/9/2017','12','30','36','47','62','9'),
('8/5/2017','11','21','28','33','45','11'),
('8/2/2017','1','16','54','63','69','18'),
('7/29/2017','1','28','40','45','48','12'),
('7/26/2017','7','19','21','42','69','12'),
('7/22/2017','5','32','44','53','60','9'),
('7/19/2017','50','51','59','61','63','4'),
('7/15/2017','9','40','63','64','66','17'),
('7/12/2017','1','2','18','23','61','9'),
('7/8/2017','8','10','29','40','59','26'),
('7/5/2017','4','9','16','54','68','21'),
('7/1/2017','19','42','45','48','53','16'),
('6/28/2017','29','37','46','53','68','8'),
('6/24/2017','10','22','32','36','58','10'),
('6/21/2017','14','46','61','65','68','13'),
('6/17/2017','10','13','32','53','62','21'),
('6/14/2017','5','22','43','57','63','24'),
('6/10/2017','20','26','32','38','58','3'),
('6/7/2017','5','21','57','66','69','13'),
('6/3/2017','3','9','21','41','54','25'),
('5/31/2017','4','33','39','46','60','6'),
('5/27/2017','5','10','28','55','67','9'),
('5/24/2017','28','32','33','38','62','15'),
('5/20/2017','5','22','45','47','54','3'),
('5/17/2017','4','11','39','45','48','9'),
('5/13/2017','17','20','32','63','68','19'),
('5/10/2017','29','31','46','56','62','8'),
('5/6/2017','11','21','31','41','59','21'),
('5/3/2017','17','18','49','59','66','9'),
('4/29/2017','22','23','24','45','62','5'),
('4/26/2017','1','15','18','26','51','26'),
('4/22/2017','21','39','41','48','63','6'),
('4/19/2017','1','19','37','40','52','15'),
('4/15/2017','5','22','26','45','61','13'),
('4/12/2017','8','14','61','63','68','24'),
('4/8/2017','23','36','51','53','60','15'),
('4/5/2017','8','20','46','53','54','13'),
('4/1/2017','9','32','36','44','65','1'),
('3/29/2017','8','15','31','36','62','11'),
('3/25/2017','18','31','32','45','48','16'),
('3/22/2017','2','9','27','29','42','9'),
('3/18/2017','13','25','44','54','67','5'),
('3/15/2017','16','30','41','48','53','16'),
('3/11/2017','1','26','41','50','57','11'),
('3/8/2017','23','33','42','46','59','4'),
('3/4/2017','2','18','19','22','63','19'),
('3/1/2017','10','16','40','52','55','17'),
('2/25/2017','6','32','47','62','65','19'),
('2/22/2017','10','13','28','52','61','2'),
('2/18/2017','3','7','9','31','33','20'),
('2/15/2017','5','28','33','38','42','19'),
('2/11/2017','5','9','17','37','64','2'),
('2/8/2017','14','20','42','49','66','5'),
('2/4/2017','6','13','16','17','52','25'),
('2/1/2017','9','43','57','60','64','10'),
('1/28/2017','12','20','39','49','69','17'),
('1/25/2017','18','28','62','66','68','22'),
('1/21/2017','23','25','45','52','67','2'),
('1/18/2017','9','40','41','53','58','12'),
('1/14/2017','23','55','59','64','69','13'),
('1/11/2017','1','3','13','16','43','24'),
('1/7/2017','3','12','24','37','63','10'),
('1/4/2017','16','17','29','41','42','4'),
('12/31/2016','1','3','28','57','67','9'),
('12/28/2016','16','23','30','44','58','4'),
('12/24/2016','28','38','42','51','52','21'),
('12/21/2016','25','33','40','54','68','3')


CREATE TABLE [dbo].[CurrentTree](
  [Number] int not null
) on [PRIMARY]
GO

INSERT INTO [dbo].[CurrentTree]([Number])
VALUES
('0'),
('1'),
('2'),
('4'),
('6'),
('8'),
('7'),
('10'),
('11'),
('12'),
('14'),
('16'),
('18'),
('17'),
('20'),
('12'),
('22'),
('42'),
('62'),
('82'),
('72'),
('40'),
('14'),
('24'),
('44'),
('64'),
('84'),
('74'),
('60'),
('16'),
('26'),
('46'),
('66'),
('86'),
('76'),
('80'),
('18'),
('28'),
('48'),
('68'),
('88'),
('78'),
('70'),
('17'),
('27'),
('47'),
('67'),
('87'),
('77'),
('01'),
('11'),
('12'),
('14'),
('16'),
('18'),
('17'),
('02'),
('21'),
('22'),
('24'),
('26'),
('28'),
('27'),
('04'),
('41'),
('42'),
('44'),
('46'),
('48'),
('47'),
('06'),
('61'),
('62'),
('64'),
('66'),
('68'),
('67'),
('08'),
('81'),
('82'),
('84'),
('86'),
('88'),
('87'),
('07'),
('71'),
('72'),
('74'),
('76'),
('78'),
('77')
GO


SELECT DISTINCT * FROM [dbo].[CurrentTree]
USE [PBNumbers]
GO
SELECT DISTINCT * FROM [dbo].[CurrentTree]
select sum([Number1]) from DrawNumbers

SELECT TOP 30 
[Number1]
, COUNT([Number1]) as Occurences1 
, 90/COUNT([Number1]) as Ratio1
FROM DrawNumbers 
GROUP BY [Number1] ORDER BY Occurences1 DESC
GO

SELECT TOP 30 [Number2], COUNT([Number2]) as Occurences2 FROM DrawNumbers group by [Number2] ORDER BY Occurences2 DESC
SELECT TOP 30 [Number3], COUNT([Number3]) as Occurences3 FROM DrawNumbers group by [Number3] ORDER BY Occurences3 DESC
SELECT TOP 30 [Number4], COUNT([Number4]) as Occurences4 FROM DrawNumbers group by [Number4] ORDER BY Occurences4 DESC
SELECT TOP 30 [Number5], COUNT([Number5]) as Occurences5 FROM DrawNumbers group by [Number5] ORDER BY Occurences5 DESC
SELECT TOP 30 [PowerBall], COUNT([PowerBall]) as PowerBallOcc FROM DrawNumbers group by [PowerBall] ORDER BY PowerBallOcc DESC
GO

SELECT TOP 60 [Number1], COUNT([Number1]) as Occurences1 FROM DrawNumbers GROUP BY [Number1] ORDER BY Occurences1 DESC
SELECT TOP 60 [Number2], COUNT([Number2]) as Occurences2 FROM DrawNumbers group by [Number2] ORDER BY Occurences2 DESC
SELECT TOP 60 [Number3], COUNT([Number3]) as Occurences3 FROM DrawNumbers group by [Number3] ORDER BY Occurences3 DESC
SELECT TOP 60 [Number4], COUNT([Number4]) as Occurences4 FROM DrawNumbers group by [Number4] ORDER BY Occurences4 DESC
SELECT TOP 60 [Number5], COUNT([Number5]) as Occurences5 FROM DrawNumbers group by [Number5] ORDER BY Occurences5 DESC
SELECT TOP 60 [PowerBall], COUNT([PowerBall]) as PowerBallOcc FROM DrawNumbers group by [PowerBall] ORDER BY PowerBallOcc DESC
GO


SELECT TOP 90 [Number1], COUNT([Number1]) as Occurences1 FROM DrawNumbers GROUP BY [Number1] ORDER BY Occurences1 DESC
SELECT TOP 90 [Number2], COUNT([Number2]) as Occurences2 FROM DrawNumbers group by [Number2] ORDER BY Occurences2 DESC
SELECT TOP 90 [Number3], COUNT([Number3]) as Occurences3 FROM DrawNumbers group by [Number3] ORDER BY Occurences3 DESC
SELECT TOP 90 [Number4], COUNT([Number4]) as Occurences4 FROM DrawNumbers group by [Number4] ORDER BY Occurences4 DESC
SELECT TOP 90 [Number5], COUNT([Number5]) as Occurences5 FROM DrawNumbers group by [Number5] ORDER BY Occurences5 DESC
SELECT TOP 90 [PowerBall], COUNT([PowerBall]) as PowerBallOcc FROM DrawNumbers group by [PowerBall] ORDER BY PowerBallOcc DESC
GO


SELECT TOP 5 * FROM [dbo].[DrawNumbers]
SELECT * FROM [dbo].[DrawNumbers]