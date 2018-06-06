/* Create User-defined data types for HayastanJan Database
Script Date: February 21, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/*Create User-deifened data type for Address*/
 create type myAddress
 from nvarchar(60) not null
 ;
 go

