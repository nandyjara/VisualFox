LPARAMETER W_Código
W_Valor = 0
W_Acumulador = 0
W_Código = ALLTRIM(UPPER(W_Código))
IF MOD(LEN(W_Código),2) = 0
	W_Multimpar = 1
	W_Multipar  = 2
ELSE
	W_Multimpar = 2
	W_Multipar  = 1
ENDIF
FOR I = 1  TO LEN(W_Código)
	W_Car = SUBSTR(W_Código,I,1)
	IF W_Car < "0" OR W_Car > "9" AND W_Car < "A" OR W_Car > "Z"
	ENDIF
	IF ISDIGIT(W_Car)
		W_Valor = VAL(W_Car)
	ELSE
		DO CASE
			CASE INLIST(W_Car,'A','K','U')
				W_Valor = 0
			CASE INLIST(W_Car,'B','L','V')
				W_Valor = 1
			CASE INLIST(W_Car,'C','M','W')
				W_Valor = 2
			CASE INLIST(W_Car,'D','N','X')
				W_Valor = 3
			CASE INLIST(W_Car,'E','O','Y')
				W_Valor = 4
			CASE INLIST(W_Car,'F','P','Z')
				W_Valor = 5
			CASE INLIST(W_Car,'G','Q')
				W_Valor = 6
			CASE INLIST(W_Car,'H','R')
				W_Valor = 7
			CASE INLIST(W_Car,'I','S')
				W_Valor = 8
			CASE INLIST(W_Car,'J','T')
				W_Valor = 9
		ENDCASE
	ENDIF
	IF MOD(I,2) = 0
		W_Valor = W_Valor * W_Multipar
	ELSE
		W_Valor = W_Valor * W_Multimpar
	ENDIF
	W_Acumulador = W_Acumulador + IIF(W_Valor > 9,W_Valor - 9,W_Valor)
ENDFOR
W_Acumulador = MOD(W_Acumulador,10)
IF W_Acumulador <> 0
	W_Acumulador = 10 - W_Acumulador
ENDIF
RETURN ALLTRIM(STR(W_Acumulador))