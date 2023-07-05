** Convierte un String para ser impreso con Fuente 
** True Type PF BARCODE 39
**
FUNCTION _StrTo39(tcString)
LOCAL lcRet
	lcRet = "*" + tcString + "*"
	RETURN lcRet
END FUNCTION