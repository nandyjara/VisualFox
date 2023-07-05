** Convierte un String para ser impreso con Fuente 
** True Type PF Interleaved 2 of 5 o PF Interleaved 2 of 5 Wide
** Parametros
** tcString: Solo caracteres Númericos (0..9)
**
** USO : _StrToI2Of5("1234567890")
**
FUNCTION _StrToI2Of5(tcString)
LOCAL lcStart, lcStop, lcRet, lcCheck, ;
	lcCar, lcLon, lnI, lnSum, lnAux
	
	lcStart = CHR(40)
	lcStop	= CHR(41)
	lcRet 	= ALLTRIM(tcString)

	* Genero dígito de control
	lnLon = LEN(lcRet)
	lnSum = 0
	lnCount = 0
	FOR lnI = lnLon TO 1 STEP -1
		lnSum = lnSum + VAL(SUBSTR(lcRet,lnI,1)) * IIF(MOD(lnCount,2)= 0,1,3)
		lnCount = lnCount + 1
	ENDFOR
	lnAux = MOD(lnSum,10)
	lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10 - lnAux)))
	lnLon = LEN(lcRet)
	* La Longitud debe ser par
	IF MOD(lnLon,2) != 0	
		lcRet = "0" + lcRet
		lnLon = LEN(lcRet)
	ENDIF
	* Comvierto los pares a caracteres
	lcCar = ""
	FOR lnI = 1 TO lnLon STEP 2
		IF VAL(SUBSTR(lcRet,lnI,2)) < 50
			lcCar = lcCar + CHR(VAL(SUBSTR(lcRet,lnI,2)) + 48)
		ELSE	
			lcCar = lcCar + CHR(VAL(SUBSTR(lcRet,lnI,2)) + 142)		
		ENDIF
	ENDFOR
	* Armo el código
	lcRet = lcStart + lcCar + lcStop	
	RETURN lcRet
END FUNCTION