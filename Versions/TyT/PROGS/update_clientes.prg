SELECT CL.ID AS ClienteID, CU.ID AS CuentaID FROM CLIENTES CL INNER JOIN CUENTAS CU ;
	ON (CL.Cuenta1 = CU.C�digo) INTO CURSOR SQLTEMP
	
SELECT SQLTEMP
SCAN ALL 
	lcCuenta = SQLTEMP.CuentaID
	SELECT CLIENTES
	REPLACE CLIENTES.CtaTr�miteID WITH lcCuenta FOR CLIENTES.ID = SQLTEMP.ClienteID
		
	SELECT SQLTEMP
ENDSCAN	
	