** Convierte un String para ser impreso con Fuente 
** True Type PF EAN P36 o PF EAN P72
** Parametros
** tcString: Caracretes de 12 Dígitos (0..9)
** tlCheckD: .T. Solo genera el Dígito de control
**			 .F. Gerera Dígito y caracteres a imprimir
**
** USO : _StrToEan13("123456789012")
**
FUNCTION _StrToEan13(tcString, tlCheckD)
LOCAL lcLat, lcMed, lcRet, lcJuego, ;
	lcIni, lcResto, lcCod, lnI, lnCheckSum, ;
	lnAux, laJuego(10),lnPri
	
	lcRet 	= ALLTRIM(tcString)
	IF LEN(lcRet) != 12
		MESSAGEBOX ("La cadena debe tener 12 digitos",64)
		RETURN ""
	ENDIF
	* Genero dígito de control
	lnCheckSum = 0
	FOR lnI = 1 TO 12
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
	* Primer Dígito
	lnPri = VAL(LEFT(lcRet,1))
	
	* Tabla de juego de caracteres
	* Segun lnPri (¡NO CAMBIAR!)
	laJuego(1) = "AAAAAACCCCCC" && 0
	laJuego(2) = "AABABBCCCCCC" && 1
	laJuego(3) = "AABBABCCCCCC" && 2
	laJuego(4) = "AABBBACCCCCC" && 3
	laJuego(5) = "ABAABBCCCCCC" && 4
	laJuego(6) = "ABBAABCCCCCC" && 5
	laJuego(7) = "ABBBAACCCCCC" && 6
	laJuego(8) = "ABABABCCCCCC" && 7
	laJuego(9) = "ABABBACCCCCC" && 8
	laJuego(10) = "ABBABACCCCCC" && 9
	
	* Caracter inicial fuera del código
	lcIni = CHR(lnPri + 35)
	* Caracter lateral y central
	lcLat = CHR(33)
	lcMed = CHR(45)
	* Resto de los caracteres
	lcResto = SUBSTR(lcRet,2,12)
	FOR lnI =  1 TO 12
		lcJuego = SUBSTR(laJuego(lnPri+1), lnI,1)
		DO CASE
			CASE lcJuego = "A"
				lcResto = STUFF(lcResto, lnI,1,CHR(VAL(SUBSTR(lcResto,lnI,1)) + 48))
			CASE lcJuego = "B"
				lcResto = STUFF(lcResto, lnI,1,CHR(VAL(SUBSTR(lcResto,lnI,1)) + 65))
			CASE lcJuego = "C"
				lcResto = STUFF(lcResto, lnI,1,CHR(VAL(SUBSTR(lcResto,lnI,1)) + 97))
		ENDCASE		
	ENDFOR
	* Armo el código
	lcCod = lcIni + lcLat + SUBSTR(lcResto,1,6) + lcMed + SUBSTR(lcResto,7,6)
	RETURN lcCod
END FUNCTION