/* Add indexes to HayastanJan Database
Script Date: February 21, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/* create a unique non-clustered index u_ncl_ProductName on table Products.Products */
create nonclustered index u_cnl_ProductName on Products.Products (ProductName)
;
go
/* create a non-clustered index u_ncl_PositionID on table HumanResourses.Employees */
create nonclustered index u_cnl_PositionID on HumanResourses.Employees (PositionID)
;
go

/* create a non-clustered index ncl_PurchaseDate on table Products.Purchase */
create nonclustered index ncl_PurchaseDate on Products.Purchase (PurchaseDate)
;
go

/* create a non-clustered index ncl_CompanyName on table Products.Suppliers */
create nonclustered index ncl_CompanyName on Products.Suppliers (CompanyName)
;
go

/* create non-clustered indexes cl_CustomerFirst, cl_CustomerLast and cl_Phone on table Sales.Customers */
create nonclustered index ncl_CustomerFirst on Sales.Customers (CustomerFirst)
;
go
create nonclustered index ncl_CustomerLast on Sales.Customers (CustomerLast)
;
go
create nonclustered index ncl_Phone on Sales.Customers (Phone)
;
go

/* create non-clustered indexes ncl_OrderDate and ncl_DeliveryDate on table Sales.Orders */
create nonclustered index ncl_OrderDate on Sales.Orders (OrderDate)
;
go
create nonclustered index ncl_DeliveryDate on Sales.Orders (DeliveryDate)
;
go
