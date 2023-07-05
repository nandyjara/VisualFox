LPARAMETER lnCount, lcDate, lnValue, lcDetalle

* CREAR CONEXION
lpSQLServerID = SQLCONNECT( "SQL Server" )
lnSQL = SQLEXEC( lpSQLServerID, "USE DOBRA" )
IF ( lnSQL <= 0 )
	MESSAGEBOX("Error en Conexión")
	RETURN
ENDIF

*-- SECCION DE PREPARACION DE DATOS

lnCount 		= lnCount
lnErrorCount	= 0

m.Número		= ""
m.DocumentoID	= ""
m.DocumentoNUMBER = ""
m.Fecha     	= lcDate
m.Detalle   	= lcDetalle
m.Tipo      	= "BAN-ND"
m.BancoID		= "0000000012"
m.DivisaID		= "0000000001"
m.Valor			= lnValue
m.Valor_Base	= lnValue
m.Cambio		= 1
m.CreadoPor		= "ADMIN"
m.EditadoPor	= "ADMIN"
m.SucursalID	= "00"

lnSQL = SQLEXEC( lpSQLServerID, "BEGIN TRANSACTION" )
IF ( lnSQL <= 0 )
	lnErrorCount = lnErrorCount + 1
ENDIF

FOR i = 1 TO lnCount
		* ACTUALIZAR SALDOS Y MOVIMIENTOS
		* -------------------------------
	
		* Calcular Nuevo ID de MOVIMIENTO 
		lcSQL = "SIS_GetNextID 'BAN_BANCOS_CARDEX-ID-" + m.SucursalID + "' "
		lnSQL = SQLEXEC( lpSQLServerID, lcSQL )
		IF ( lnSQL <= 0 )
			lnErrorCount = lnErrorCount + 1
		ENDIF
		m.ID = m.SucursalID + TRAN( SQLRESULT.NextID, '@L 99999999' )
		* Insertar Movimiento y Actualizar Saldo de Cuenta Bancaria
		m.Débito   		= .T.
		m.Cheque		= ""
		m.Fecha_Cheque	= m.Fecha
		m.Fecha_Banco	= m.Fecha
		m.Beneficiario	= ""
		lcSQL = "BAN_BancosCardex_Insert " + ;
			"'" + m.ID + "', " + ;
			"'" + m.BancoID + "', " + ;
			"'" + m.DocumentoID + "', " + ;
			"'" + m.DocumentoNUMBER + "', " + ;
			"'" + m.Fecha + "', " + ;
			"'" + m.Tipo + "', " + ;
			"'" + m.Cheque + "', " + ;
			"'" + m.Fecha_Cheque + "', " + ;
			"'" + m.Beneficiario + "', " + ;
			"'" + m.Detalle + "', " + ;
			"'" + m.DivisaID + "', " + ;
			" " + ALLTRIM(STR(m.Cambio,20,4)) + ", " + ;
			" " + IIF( m.Débito, "1", "0" ) + ", " + ; 
			" " + ALLTRIM(STR(m.Valor,20,4)) + ", " + ;
			" " + ALLTRIM(STR(m.Valor_Base,20,4)) + ", " + ;
			"'" + m.CreadoPor + "', " + ;
			"'" + m.SucursalID + "', " + ;
			"'" + SYS(0) + "' "	
		lnSQL = SQLEXEC( lpSQLServerID, lcSQL )
		IF ( lnSQL <= 0 )
			lnErrorCount = lnErrorCount + 1
		ENDIF
ENDFOR

* END TRANSACTION 
IF lnErrorCount > 0
	lnSQL = SQLEXEC( lpSQLServerID, "ROLLBACK TRANSACTION" )
	SQLROLLBACK( lpSQLServerID )
	MESSAGEBOX("Errores en la transacción")
ELSE
	lnSQL = SQLEXEC( lpSQLServerID, "COMMIT TRANSACTION" )
	SQLCOMMIT( lpSQLServerID )
	MESSAGEBOX("Generación exitosa")
ENDIF

SQLDISCONNECT( lpSQLServerID )

