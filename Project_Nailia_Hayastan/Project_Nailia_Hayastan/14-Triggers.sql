/* Create User-Defined Triggers for HayastanJan Database
Script Date: February 23, 2018
Developed by: Nailia, Shushan, Bita, Yohannes
*/
use HayastanJan
;
go

/* Create a Trigger, ReordeLevelReachedTr, that checks the UnitsInStock and sends a message
 whenever the reorder level is reached */
create trigger Products.ReordeLevelReachedTr
on [Products].[Products]
for update
as 
	begin
		-- declare variables
		declare @ProductID as int,
				@UnitsInStock as decimal,
				@ReorderLevel as smallint
		-- compute return value
		select @UnitsInStock = UnitsInStock,
			   @ReorderLevel = Reorderlevel
		from inserted
		-- making decision

		if @UnitsInStock <= @ReorderLevel
		begin
			-- set modified date to the current date
			
			print '***** Reorder Level is reached for @ProductID*****'
		end
		
	end
;
go

/* Testing the trigger Products.ReordeLevelReachedTr */
update [Products].[Products]
set [UnitsInStock] = 7
where [ProductID] = 1
;
go
update [Products].[Products]
set [UnitsInStock] = 10
where [ProductID] = 3
;
go
select *
from [Products].[Products]
;
go

/*Create the trigger CheckModifiedDateTr, that checks the modifued date and if phone
	number is missing it will write the comment, that Company doesn not have number */
if OBJECT_ID('dbo.CheckModifiedDataTr', 'Tr') is not null
	drop trigger dbo.CheckModifiedDataTr
;
go

create trigger Sales.CheckModifiedDataTr
on Sales.DeliverVia
for insert, update
as
	begin
		-- declare variable
		declare @CompanyName as nvarchar(60),
		@Phone as nvarchar(24)
		-- compute return value
		select @CompanyName = CompanyName,
				@Phone = Phone
		from inserted
		-- making decision
		if (@Phone is null)
			begin
				-- set modified date to the current date
				update Sales.DeliverVia
				set Phone = 'Has not Phone Number'
				where CompanyName = @CompanyName
				print '***No Phone Number is provided ***'
			end

	end
;
go

/*testing the trigger checkModifiedDateTr*/
insert into Sales.DeliverVia(CompanyName, Phone)
values ('Marselo', '514-228-4523')
;
go
insert into Sales.DeliverVia(CompanyName)
values ('Express')
;
go
select *
from [Sales].[DeliverVia]


/* Create a trigger notifyEmployeeTR, that prints a message when anyone modifies or inserts data in the HumanResourses.Employees */
/*check if the trigger exists */
If OBJECT_ID('HumanResourses.Employees', 'Tr') is not null
	drop trigger HumanResourses.notifyEmployeeTR
;
go

create trigger HumanResourses.notifyEmployeeTR
 on HumanResourses.Employees
 after update, insert
 as
	raiserror('Table HumanResourses.Employees was modified', 16, 10)
;
go

/* testing the trigger HumanResourses.notifyEmployeeTR */
/* modify the employee name from Lea Steinhaus to Epraxiya Martirosyan, for the Employee Id 9 */
select *
from HumanResourses.EmployeeView
where EmpID = 9
;
go

update HumanResourses.Employees
set EmpFirst = 'Epraxiya', EmpLast = 'Martirosyan'
where EmpID = 9
;
go