** Convierte un String para ser impreso con Fuente 
** True Type PF BARCODE 128C
** Solo caracteres numéricos
**
** USO : _StrTo128C("1234567890")
**
FUNCTION _StrTo128C(tcString)
LOCAL lcStart, lcStop, lcRet, lcCheck, lcCar, ;
	lnLong, lnI, lnCheckSum, lnAsc

	lcStart	= CHR(105 + 32)
	lcStop	= CHR(106 + 32)
	lnCheckSum = ASC(lcStart) - 32
	lcRet 	= ALLTRIM(tcString)
	lnLong	= LEN(lcRet)
	** La longitud debe ser par
	IF MOD(lnLong,2) != 0
		lcRet = "0" + lcRet
		lnLong = LEN(lcRet)
	ENDIF
	
	lcCar = ""
	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBSTR(lcRet,lnI,1)) - 32
		lcCar = lcCar + CHR(VAL(SUBSTR(lcRet,lnI,2)) + 32)
	ENDFOR

	lcRet = lcCar
	lnLong = LEN(lcRet)
	FOR lnI = 1 TO lnLong
		lnAsc = ASC(SUBSTR(lcRet,lnI,1)) - 32
		lnCheckSum = lnCheckSum + (lnAsc * lnI)
	ENDFOR
	
	lcCheck = CHR(MOD(lnCheckSum,103) + 32)
	lcRet 	= lcStart + lcRet + lcCheck + lcStop
	
	* Para cambiar los espacios y caracteres invalidos
	lcRet = STRTRAN(lcRet,CHR(32),CHR(232))
	lcRet = STRTRAN(lcRet,CHR(127),CHR(192))
	lcRet = STRTRAN(lcRet,CHR(128),CHR(193))
	
	RETURN lcRet
END FUNCTION
