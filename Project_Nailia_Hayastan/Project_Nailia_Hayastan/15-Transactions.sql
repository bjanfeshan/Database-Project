/* T-SQL transactions in Hajastan Jan database
Script Date: February 27, 2018
Develped by: Nailia,Shushan,Bita and Yohannes
*/

use Hayastanjan
;
go
/***********************Manage Transactions*****************/
/*Task1: Execute a multi-statement inserting batch with error */
begin try	
	insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
	values (6, 4, 6, '2018/02/27', 7);

	insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
	values (2, 1, 4, '2018/02/27', 10);
	
	insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
	values (2, 20, 5, '2018/02/27', 6); -- we don't have EmpID = 20
end try
begin catch
	select ERROR_NUMBER() as 'Error Number',
			ERROR_MESSAGE() as 'Error Message'	
end catch
;
go

/*Task2: Execute a multi-statement batch without error */
begin try
	begin transaction
		insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
		values (6, 4, 6, '2018/02/27', 7);

		insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
		values (2, 1, 4, '2018/02/27', 10);
		
		insert into Products.Purchase (SupplierID,EmpID,ProductID, PurchaseDate,Quantity)
		values (2, 20, 5, '2018/02/27', 6); -- we don't have EmpID = 20		
	commit transaction
end try
begin catch
	select ERROR_NUMBER() as 'Error Number',
			ERROR_MESSAGE() as 'Error Message'
	rollback transaction
end catch
;
go

/* show that even with exception handling, some rows were inserted */
select *
from Products.Purchase
;
go

/*Task3: Delete transaction */
begin try
	begin transaction
		delete from Products.Purchase  
		where PurchaseID > 32 ; 
	commit transaction
end try
begin catch
	select 	ERROR_NUMBER() as 'Error Number',
			ERROR_MESSAGE() as 'Error Message'
	rollback transaction
end catch
;
go

/*Task 4: Create Order input with checking the data */  
begin try
	insert into Sales.Orders (CustomerID,EmpID,RequireDelivery,OrderDate,ToAddress,ToCity,ToProvince)
	values (22, 5, 0, getDate(), '258 4th street', 'Laval', 'QC');
	
	insert into Sales.[Order Details](OrderID,ProductID,SellingPrice,Quantity)
	values (19, 8, 14.99, 5);	
end try
begin catch	
	select OD.OrderID,OD.ProductID,OD.SellingPrice,OD.Quantity,
			O.OrderDate,O.ToAddress,O.ToCity,O.ToProvince
	from Sales.Orders as O
		inner join Sales.[Order Details] as OD
			on O.OrderID = OD.OrderID
			inner join Products.Products as P
				on OD.ProductID = P.ProductID
	if(OD.Quantity > P.UnitsInStock)
	begin
		print '***Insertid Quantity is not availabale ***'
	end
end catch
;
go