
* CREAR CONEXION
USE ? 
SCAN ALL

	*-- SECCION DE PREPARACION DE DATOS
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

	INSERT INTO EST_ESTUDIANTES FROM MEMVAR
	
ENDSCAN

