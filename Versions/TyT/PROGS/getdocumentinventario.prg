PARAMETERS lcTipo, lcDocumentoID
#INCLUDE DOBRA.H

lcTipo = STRTRAN(lcTipo,'*')

DO CASE
	CASE lcTipo = IDDOC_COM_FACTURAS
		DO FORM COM_DOCUMENT_FACTURAS WITH lcDocumentoID

	CASE lcTipo = IDDOC_COM_ORDENES	
		DO FORM COM_DOCUMENT_ORDENES WITH lcDocumentoID	

	CASE lcTipo = IDDOC_COM_DEVOLUCIONES
		DO FORM COM_DOCUMENT_DEVOLUCIONES WITH lcDocumentoID

	CASE lcTipo = IDDOC_TRA_SERVICIOS_MASIVOS
		DO FORM TRA_DOCUMENT_FACTURAS_MASIVO WITH lcDocumentoID
		
	CASE INLIST(lcTipo, IDDOC_VEN_FACTURAS, IDDOC_VEN_FACTURAS_LETRAS)
*!*			DO FORM VEN_DOCUMENT_FACTURAS WITH lcDocumentoID
		IF UPPER(ALLTRIM(_Dobra.Database)) = "TYT"
			DO FORM VEN_DOCUMENT_FACTURAS_TYT WITH lcDocumentoID
		ENDIF
		IF UPPER(ALLTRIM(_Dobra.Database)) = "CIA"
			DO FORM VEN_DOCUMENT_FACTURAS_CIA WITH lcDocumentoID
		ENDIF
		IF UPPER(ALLTRIM(_Dobra.Database)) = "TOLEPU"
			DO FORM VEN_DOCUMENT_FACTURAS WITH lcDocumentoID
		ENDIF
		IF UPPER(ALLTRIM(_Dobra.Database)) = "ESTIBA"
			DO FORM VEN_DOCUMENT_FACTURAS_ESTIBA WITH lcDocumentoID
		ENDIF

	CASE lcTipo = IDDOC_VEN_ORDENES	
		DO FORM VEN_DOCUMENT_ORDENES WITH lcDocumentoID	

	CASE lcTipo = IDDOC_VEN_DEVOLUCIONES
		DO FORM VEN_DOCUMENT_DEVOLUCIONES WITH lcDocumentoID	

	CASE lcTipo = IDDOC_POS_FACTURAS			
		DO FORM POS_DOCUMENT_FACTURAS WITH lcDocumentoID	

	CASE INLIST(lcTipo, IDDOC_INV_EGRESO, IDDOC_VEN_EGRESO_ORDENES)
		DO FORM INV_DOCUMENT_EGRESOS WITH lcDocumentoID

	CASE INLIST(lcTipo,IDDOC_INV_INGRESO,IDDOC_INV_INGRESO_PRODUCCION,IDDOC_IMP_PEDIDOS,IDDOC_COM_INGRESO_ORDENES)
		DO FORM INV_DOCUMENT_INGRESOS WITH lcDocumentoID

	CASE lcTipo = IDDOC_INV_TRANSFERENCIA
		DO FORM INV_DOCUMENT_TRANSFERENCIAS WITH lcDocumentoID

	OTHERWISE
		MESSAGEBOX("Lo siento, pero no se puede presentar el documento.")		
ENDCASE