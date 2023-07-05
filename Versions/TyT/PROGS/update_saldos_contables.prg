** Programa actualiza los saldos de las cuentas contables.

*!*	lnN�mero 	= 1
*!*	lcCuentaID 	= ""

*!*	SELECT CGCOMPRO
*!*	lcClave1 = CGCOMPRO.CodDia
*!*	lcClave2 = CGCOMPRO.NumDoc
*!*	SCAN ALL
*!*		lcCuenta = CGCOMPRO.CodCta
*!*		
*!*		** Buscar el ID de la Cuenta
*!*		SELECT CUENTAS
*!*		LOCATE FOR CUENTAS.C�digo = lcCuenta
*!*		lcCuentaID = CUENTAS.ID
*!*		
*!*		IF lcClave1 = CGCOMPRO.Coddia AND lcClave2 = CGCOMPRO.NumDoc
*!*			SELECT CGCOMPRO
*!*			REPLACE ID			WITH TRAN(lnN�mero, "@L 9999999999"), ;
*!*					CuentaID 	WITH lcCuentaID
*!*		ELSE
*!*			lnN�mero = lnN�mero + 1
*!*			lcClave1 = CGCOMPRO.CodDia
*!*			lcClave2 = CGCOMPRO.NumDoc 
*!*			SELECT CGCOMPRO
*!*			REPLACE ID			WITH TRAN(lnN�mero, "@L 9999999999"), ;
*!*					CuentaID 	WITH lcCuentaID
*!*		ENDIF
*!*		
*!*		SELECT CGCOMPRO
*!*	ENDSCAN

** Actualizar la Cabecera y Detalle del SQL Server
m.Tipo		= 'ACC-CD'
m.Divisi�n 	= '0000000001'
m.SucursalID = '00'
m.CreadoPor	= 'CODETEK'
m.PcID		= 'Jessica'

SELECT CGCOMPRO
lcID = ""
SCAN ALL
	IF lcID != CGCOMPRO.ID
		** Cabecera
		m.ID 		= CGCOMPRO.ID
		m.N�mero 	= CGCOMPRO.ID
		m.Fecha		= CGCOMPRO.Fecha
		m.Detalle 	= CGCOMPRO.Detalle
		INSERT INTO ACC_ASIENTOS FROM MEMVAR
	ENDIF
	lcID = CGCOMPRO.ID
	
	** Detalle
	m.AsientoID	= CGCOMPRO.ID
	m.CuentaID	= CGCOMPRO.CuentaID
	m.D�bito	= CGCOMPRO.D�bito
	m.Valor		= CGCOMPRO.Valor
	m.Detalle	= CGCOMPRO.Detalle
	INSERT INTO ACC_ASIENTOS_DT FROM MEMVAR
	
	SELECT CGCOMPRO
ENDSCAN