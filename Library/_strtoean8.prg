** Convierte un String para ser impreso con Fuente 
** True Type PF EAN P366 o PF EAN P72
** Parametros
** tcString: Caracretes de 7 Dígitos (0..9)
** tlCheckD: .T. Solo genera el Dígito de control
**			 .F. Gerera Dígito y caracteres a imprimir
**
** USO : _StrToEan13("1234567")
**
FUNCTION _StrToEan8(tcString, tlCheckD)
LOCAL lcLat, lcMed, lcRet, ;
	lcIni, lcCod, lnI, lnCheckSum, lnAux
	
	lcRet 	= ALLTRIM(tcString)
	IF LEN(lcRet) != 7
		MESSAGEBOX ("La cadena debe tener 7 digitos",64)
		RETURN ""
	ENDIF
	* Genero dígito de control
	lnCheckSum = 0
	FOR lnI = 1 TO 7
		IF MOD(lnI,2) = 0
			lnCheckSum = lnCheckSum + VAL(SUBSTR(lcRet,lnI,1)) * 3
		ELSE
			lnCheckSum = lnCheckSum + VAL(SUBSTR(lcRet,lnI,1)) * 1
		ENDIF
	ENDFOR
	lnAux = MOD(lnCheckSum,10)
	lcRet = lcRet + ALLTRIM(STR(IIF(lnAux = 0,0,10 - lnAux)))
	
	* Si solo se genera el digito de control	
	IF tlCheckD
		RETURN lcRet
	ENDIF	
	
	* Para imprimir con fuente True Type PF_EAN_PXX
	* Caracter lateral y central
	lcLat = CHR(33)
	lcMed = CHR(45)
	* Resto de los caracteres
	FOR lnI =  1 TO 8
		IF lnI <= 4
			lcRet = STUFF(lcRet, lnI,1,CHR(VAL(SUBSTR(lcRet,lnI,1)) + 48))
		ELSE
			lcRet = STUFF(lcRet, lnI,1,CHR(VAL(SUBSTR(lcRet,lnI,1)) + 97))
		ENDIF
	ENDFOR
	* Armo el código
	lcCod = lcLat + SUBSTR(lcRet,1,4) + lcMed + SUBSTR(lcRet,5,4) + lcLat
	RETURN lcCod
END FUNCTION