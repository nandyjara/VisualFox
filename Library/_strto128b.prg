** Convierte un String para ser impreso con Fuente 
** True Type PF BARCODE 128B
** Caracteres numéricos y alfabeticos ( Mayúsculas y Minusculas)
** Si un caracter no es valido es reemplazado por un espacio
**
** USO : _StrTo128B("CODOGO 128 B")
**
LPARAMETER tcString
LOCAL lcStart, lcStop, lcRet, lcCheck, ;
	lnLong, lnI, lnCheckSum, lnAsc
	
	lcStart	= CHR(104 + 32)
	lcStop	= CHR(106 + 32)
	lnCheckSum = ASC(lcStart) - 32
	lcRet 	= tcString
	lnLong	= LEN(lcRet)
	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBSTR(lcRet,lnI,1)) - 32
		IF !BETWEEN(lnAsc, 0, 99)
			lcRet = STUFF(lcRet,lnI,1,CHR(32))
			lnAsc = ASC(SUBSTR(lcRet,lnI,1)) - 32
		ENDIF
		lnCheckSum = lnCheckSum + (lnAsc * lnI)
	ENDFOR

	lcCheck = CHR(MOD(lnCheckSum,103) + 32)
	lcRet 	= lcStart + lcRet + lcCheck + lcStop
	
	* Para cambiar los espacios y caracteres invalidos
	lcRet = STRTRAN(lcRet,CHR(32),CHR(232))
	lcRet = STRTRAN(lcRet,CHR(127),CHR(192))
	lcRet = STRTRAN(lcRet,CHR(128),CHR(193))
	
	RETURN lcRet
