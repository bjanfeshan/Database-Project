/* Create User-Defined Store-Procedures for HayastanJan Database
Script Date: February 23, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/

/* Create Store-Procedures to import and export an image (binary) file to or from SQL Server without using third party tools */

/*
Please note that as a preliminary action the OLE Automation Procedures option must be set and active on the SQL Server for the image 
export action and the BulkAdmin privilege should be given to the executor of the image import action*/
/* Here is the T-SQL script needed for those privileges: */
Use master
Go
EXEC sp_configure 'show advanced options', 1; 
GO 
RECONFIGURE; 
GO 
EXEC sp_configure 'Ole Automation Procedures', 1; 
GO 
RECONFIGURE; 
GO

use HayastanJan
;
go

/* Image Import Stored Procedure */
CREATE PROCEDURE dbo.usp_ImportImage (
     @PicName NVARCHAR (100)
   , @ImageFolderPath NVARCHAR (1000)
   , @Filename NVARCHAR (1000)
   , @Description NVARCHAR (1000)
   )
AS
BEGIN
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @tsql NVARCHAR (2000);
   SET NOCOUNT ON
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
   SET @tsql = 'insert into [Products].[Category] ([CategoryName], [Description], [Picture]) ' +
               ' SELECT ' + '''' + @PicName + '''' + ',' + '''' + @Description + '''' + ', * ' + 
               'FROM Openrowset( Bulk ' + '''' + @Path2OutFile + '''' + ', Single_Blob) as img'
   EXEC (@tsql)
   SET NOCOUNT OFF
END
GO

/* Image Export Stored Procedure */
CREATE PROCEDURE dbo.usp_ExportImage (
   @PicName NVARCHAR (100)
   ,@ImageFolderPath NVARCHAR(1000)
   ,@Filename NVARCHAR(1000)
   )
AS
BEGIN
   DECLARE @ImageData VARBINARY (max);
   DECLARE @Path2OutFile NVARCHAR (2000);
   DECLARE @Obj INT
 
   SET NOCOUNT ON
 
   SELECT @ImageData = (
         SELECT convert (VARBINARY (max), Picture, 1)
         FROM [Products].[Category]
         WHERE [CategoryName] = @PicName
         );
 
   SET @Path2OutFile = CONCAT (
         @ImageFolderPath
         ,'\'
         , @Filename
         );
    BEGIN TRY
     EXEC sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
     EXEC sp_OASetProperty @Obj ,'Type',1;
     EXEC sp_OAMethod @Obj,'Open';
     EXEC sp_OAMethod @Obj,'Write', NULL, @ImageData;
     EXEC sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
     EXEC sp_OAMethod @Obj,'Close';
     EXEC sp_OADestroy @Obj;
    END TRY
    
 BEGIN CATCH
  EXEC sp_OADestroy @Obj;
 END CATCH
 
   SET NOCOUNT OFF
END
GO
/*

*/
exec dbo.usp_ImportImage 'Ingredients','E:\Nailia_John Abbott\Data Base II\Project Hayastan\images','ingredients.jpg','imported product' 
exec dbo.usp_ImportImage 'Imported Products','E:\Nailia_John Abbott\Data Base II\Project Hayastan\images','Imported.jpg','Jam, beverage, pickles' 
exec dbo.usp_ImportImage 'Deli Meat','E:\Nailia_John Abbott\Data Base II\Project Hayastan\images','Deli_Meat.jpg','Qufta, Basturma, Kebabs, Khorovats, Khash' 
exec dbo.usp_ImportImage 'Cakes','E:\Nailia_John Abbott\Data Base II\Project Hayastan\images','Desert.jpg','Cakes, Birthday cakes' 
exec dbo.usp_ImportImage 'Dried Fruits','E:\Nailia_John Abbott\Data Base II\Project Hayastan\images','Dried_Fruits.jpg','Anali, Sujukh'

exec dbo.usp_ExportImage 'Ingredients','C:\temp\output','ingredients.jpg' 
exec dbo.usp_ExportImage 'Imported Products','C:\temp\output','Imported.jpg'
exec dbo.usp_ExportImage 'Deli Meat','C:\temp\output','Deli_Meat.jpg'
exec dbo.usp_ExportImage 'Cakes','C:\temp\output','Desert.jpg'
exec dbo.usp_ExportImage 'Dried Fruits','C:\temp\output','Dried_Fruits.jpg'


