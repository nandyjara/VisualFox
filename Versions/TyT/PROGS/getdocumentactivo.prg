PARAMETERS lcTipo, lcDocumentoID
#INCLUDE DOBRA.H

lcTipo = STRTRAN(lcTipo,'*')

DO CASE
	CASE lcTipo = IDDOC_ACT_ASIGNACION
		DO FORM ACT_DOCUMENT_ASIGNACIONES WITH lcDocumentoID

	CASE lcTipo = IDDOC_ACT_DEPRECIACION
		DO FORM ACT_DOCUMENT_DEPRECIACIONES WITH lcDocumentoID

	CASE lcTipo = IDDOC_ACT_EGRESOS
		DO FORM ACT_DOCUMENT_EGRESOS WITH lcDocumentoID

	CASE lcTipo = IDDOC_ACT_FACTURAS
		DO FORM ACT_DOCUMENT_FACTURAS WITH lcDocumentoID

	CASE lcTipo = IDDOC_ACT_INGRESOS
		DO FORM ACT_DOCUMENT_INGRESOS WITH lcDocumentoID

	CASE lcTipo = IDDOC_ACT_ORDENES
		DO FORM ACT_DOCUMENT_ORDENES WITH lcDocumentoID

	OTHERWISE
		MESSAGEBOX("Lo siento, pero no se puede presentar el documento.")		
ENDCASE