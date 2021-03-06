use [EmployeeServices]

create PROCEDURE InsertEmployeeDetails
(@ID int,
@Name varchar(50),
@Gender varchar(1),
@PhoneNumber bigint,
@Address varchar(50),
@StartDate date,
@Department varchar(50),
@BasicPay bigint,
@Deduction int,
@TaxablePay int,
@IncomeTax int,
@NetPay int
)

AS
SET XACT_ABORT ON;
SET NOCOUNT ON;
BEGIN
BEGIN TRY
BEGIN TRANSACTION;

SET NOCOUNT ON;
declare @new_identity int = 0
declare @result bit = 0;
Insert into EmployeePayroll(Name,Gender,PhoneNumber,Address, StartDate) Values (@Name,@Gender,@PhoneNumber,@Address,@StartDate);
select @new_identity = @@IDENTITY

insert into Payroll(Payroll.ID,BasicPay,Deduction,TaxablePay,IncomeTax,NetPay) values (@new_identity,@BasicPay,@Deduction,@TaxablePay,@IncomeTax,@NetPay);
insert into DepartmentTable (DepartmentTable.ID,Department)values(@new_identity,@Department);
Commit Transaction
Set @result = 1;
return @result;
END TRY
Begin Catch

if(XACT_STATE()) = -1
 Begin
  Print
  'transaction is uncommitable' + 'rolling back transaction'
 ROLLBACK TRANSACTION;
 RETURN @result;
 End;
else if (XACT_STATE()) = 1
Begin
Print
   'transaction is commitable' + 'commiting back transaction'
   COMMIT TRANSACTION
   set @result = 1;
   return @result;
   END
END Catch
END


select EmployeePayroll.ID, Name,Gender, PhoneNumber, Address,StartDate , Department,BasicPay,Deduction,TaxablePay, IncomeTax, NetPay from
EmployeePayroll left join DepartmentTable on EmployeePayroll.ID = DepartmentTable.Id left join Payroll on EmployeePayroll.ID = Payroll.ID




