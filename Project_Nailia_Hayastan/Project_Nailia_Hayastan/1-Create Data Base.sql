/* Create HayastanJan Database
Script Date: February 19, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/

/* add a statement that specifies that the scypt runs*/
use master
;
go -- including end of batch markers (go statement)

/* Syntax: create object_type object_name*/

create database HayastanJan
on primary
(
-- Rows data file name
name = 'HayastanJan',
-- Rows Data path and filename
filename='C:\Hayastan Data\HayastanJan.mdf',
-- Rows Data size
size = 12MB,
-- Rows Data file growth
filegrowth = 2MB,
-- Maximum Pows Data file size
maxsize = 100MB
)
-- log file
log on
(
-- log file name
name = 'HayastanJan_log',
-- Log path and filename
filename='C:\Hayastan Data\HayastanJan_log.ldf',
-- Log size
size = 3MB,
-- Log file growth
filegrowth = 10%,
-- Maximum log file size
maxsize = 25MB
)

/* return information about HayastanJan database */
execute sp_helpdb HayastanJan
;
go

