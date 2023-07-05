LPARAMETERS lcid
* Localizar Documento
*SET STEP ON 
lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_Ordenes_SeekID '" + lcID + "'" )
IF ( lnSQL = 1 ) AND ( RECCOUNT() = 1 ) AND !EMPTY( lcID )
	lcTrámiteID = NVL(SQLRESULT.TrámiteID,"")
	lcOficialID = NVL(SQLRESULT.OficialID,"")
	lcClienteID = NVL(SQLRESULT.ClienteID,"")
	m.DivisiónID = SQLRESULT.DivisiónID
	m.Módulo = ALLTRIM(SQLRESULT.Módulo)
	m.Fecha   = TTOD(SQLRESULT.Fecha)
	m.Producto = ALLTRIM(SQLRESULT.Producto)
	m.OrdenTorres = SUBSTR(SQLRESULT.Orden,5,2) + "-" + SUBSTR(SQLRESULT.Orden,7,4)
	m.OrdenCia = SUBSTR(SQLRESULT.OrdenCIA,1,4) + "-" + SUBSTR(SQLRESULT.OrdenCIA,5,2) + "-" + SUBSTR(SQLRESULT.OrdenCIA,7,4)
	m.Multas 	= SQLRESULT.Multas
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "EMP_EMPLEADOS_SeekID '" + lcOficialID + "'" )
	m.Oficial = IIF(lnSQL = 1 AND RECCOUNT() = 1,ALLTRIM(SQLRESULT.Nombre),"")
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "CLI_CLIENTES_SeekID '" + lcClienteID + "'" )
	m.Cliente = IIF(lnSQL = 1 AND RECCOUNT() = 1,ALLTRIM(SQLRESULT.Nombre),"")
	
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_ORDENESDT_Select_Costos_Operacion2'" + lcID + "'", "SQLCOSTOS")
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_Ordenes_Select_DT '" + lcID + "'", "SQLTRANSPORTE" )
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_Trámites_Select_Observaciones2 '" + lcID + "', '" + lcTrámiteID + "'", "SQLOBSERVACIONES" )
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_Ordenes_Select_Servicios2 '" + lcID + "', '" + lcClienteID  + "'", "SQLFACTURA" )
	lnSQL = SQLEXEC( _DOBRA.SQLServerID, "TRA_Ordenes_Select_Reembolsos '" + lcID + "'", "SQLREEMBOLSOS" )

	SELECT "1" AS Orden, carga, SPACE(20),Cantidad,Estibadores,FechaLlegada,CFechaConfPrecios, ;
		cFechaSalida,Factura, RutaName, Recargo, NTOM(0) AS Total_Transporte,SPACE(8) AS Hora, SPACE(250) AS Nota, {//} AS Fecha, ;
		SPACE(15) AS Código, SPACE(50) AS Nombre, 0 AS Extendido,NTOM(0) AS Valor,SPACE(25) AS Proveedor, ;
		Peso, Volumen, SPACE(50) as Detalle , NTOM(0) AS Transporte , NTOM(0) AS Custodia, NTOM(0) AS Vacio, ;
		NTOM(0) AS Operativo, NTOM(0) AS ValorTrasbordo, NTOM(0) AS Desconsolidacion, NTOM(0) AS OtrosCostos, ;
		NTOM(0) AS Venta, NTOM(0) as Utilidad;
	 	FROM  SQLTRANSPORTE WHERE !Trasbordo;
	 UNION ALL ;
	SELECT "1" AS Orden, carga, SPACE(20),Cantidad,Estibadores,FechaLlegada,CFechaConfPrecios, ;
		cFechaSalida,Factura, "Trasbordo: " + ALLTRIM(RutaName), SPACE(25), NTOM(0),SPACE(8) AS Hora, SPACE(250) AS Nota, {//} AS Fecha, ;
		SPACE(15) AS Código, SPACE(50) AS Nombre, 0 AS Extendido,NTOM(0) AS Valor,SPACE(25) AS Proveedor, ;
		Peso, Volumen, SPACE(50), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0) ;
	 	FROM  SQLTRANSPORTE WHERE Trasbordo ;
	 UNION ALL ;
	SELECT "2", SPACE(15), SPACE(20),0,0,SPACE(10),SPACE(10), ;
		SPACE(10),SPACE(10), SPACE(50), SPACE(25), NTOM(0), Hora, Nota, CTOD(Fecha) AS Fecha, ;
		SPACE(15), SPACE(50), 0,NTOM(0),SPACE(25), 0, 0, SPACE(50), NTOM(0), NTOM(0), NTOM(0), ;
		NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0)	;
	 	FROM  SQLOBSERVACIONES	;
	UNION ALL ;
	SELECT "3", SPACE(15), SPACE(20),0,0,SPACE(10),SPACE(10), ;
		SPACE(10),SPACE(10) AS Factura, SPACE(50), SPACE(25), NTOM(0), SPACE(8), SPACE(250), {//},  ;
		SPACE(10) AS Código,SPACE(10) AS Nombre,0 AS Extendido,NTOM(0),SPACE(25), 0, 0, SPACE(50), NTOM(0), NTOM(0), NTOM(0),;
		NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0) ;
	 	FROM  SQLFACTURA WHERE Facturar ;
	UNION ALL ;
	SELECT "4", SPACE(15), SPACE(20),0,0,SPACE(10),SPACE(10), ;
		SPACE(10),SPACE(10) as Factura, SPACE(50), SPACE(25), NTOM(0), SPACE(8), SPACE(250), {//},  ;
		SPACE(10) AS PDCódigo,SPACE(10) AS PDName,0, NTOM(0) AS Valor,SPACE(10) AS Proveedor, 0, 0, SPACE(50), NTOM(0), NTOM(0), NTOM(0), NTOM(0),;
		NTOM(0), NTOM(0), NTOM(0), NTOM(0), NTOM(0) ;
	 	FROM  SQLREEMBOLSOS WHERE Facturar ; 
	UNION ALL ;
	SELECT "5", SPACE(15), SPACE(20),0,0,SPACE(10),SPACE(10), ;
		SPACE(10),SPACE(10), SPACE(50), SPACE(25), NTOM(0), SPACE(8), SPACE(250), {//},  ;
		SPACE(15), SPACE(50), 0,NTOM(0),SPACE(25), 0, 0, Detalle, Transporte , ;
		Custodia, Vacio, Operativo, Trasbordo AS ValorTrasbordo, Desconsolidacion, OtrosCostos, Venta, Utilidad ;
	FROM SQLCOSTOS ;
	INTO CURSOR SQLCURSOR 

	SELECT SQLCURSOR 
	IF !EOF()
		lcRuta		= _DOBRA.GetRegKey( "SIS-ReportPath", "" )
		lcFileName	= lcRuta
		lcFileName	= lcFileName + "TRA_DOCUMENT_ORDENES"
		
		***********************************************************************************************************************
		* Generar PDF 
		lcSQL = "SIS_Divisiones_SeekID '" + m.DivisiónID + "' "
		lnSQL = SQLEXEC( _DOBRA.SQLServerID, lcSQL )
		lcDirectorioDig = _DOBRA.GetParameter("DIR-DIG-ORD","")
		LOCAL loFile
		LOCAL lcReportFullName
		LOCAL lcOutPutFileName
		LOCAL lcOutPutFilePath
		LOCAL lcFRX2AnyLibrary
		lcReportFullName = ALLTRIM(lcFileName + ".FRX")
		SELECT SQLCURSOR 
		GO TOP
		IF !FILE(lcReportFullName)
			=MESSAGEBOX('Archivo ' + lcReportFullName + CHR(13) + ' no Existe.', 16, 'Tramites')
		ELSE
			lcOutPutFileName = m.ordenCia
			*lcOutPutFilePath = ALLTRIM(SQLRESULT.RutaImagenes) + ALLTRIM(lcDirectorioDig)
			lcOutPutFilePath = '\\image-srv\Documentos Digitalizados\02. Ciateite S.A\2011\'
			
			loFile = CREATEOBJ('FRX2Any.PDFFile')
			IF TYPE('loFile') = 'O'
				loFile.UNLOCK( Thisform.UnlockFrx2Any )
				loFile.cExportFileName = lcOutPutFileName
				loFile.cSaveFolder     = lcOutPutFilePath
				loFile.lDisplayStatus  = .T.
				loFile.nOutPutType = 4
				loFile.lTranslateFontStyle = .T.
				loFile.nCodePage = 1252
				loFile.SAVE(lcReportFullName)
				loFile.RELEASE()
			ENDIF
		ENDIF
		***********************************************************************************************************************
	ENDIF
ENDIF

	
