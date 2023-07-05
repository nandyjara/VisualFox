FUNCTION ValidaCedula
PARAMETER	lcCedula 
* Control de provincia entre 1 y 22
lv_prov = VAL(SUBSTR(lcCedula,1, 2))
IF (lv_prov >= 1 AND lv_prov <= 22) 
	lv_numced = lccedula 
	ll_TenDig = VAL(SUBSTR(lcCedula,10))
	ll_sum = 0

	ll_Cnt 		= 0
	ll_CntPos 	= 0
		
	DO WHILE (ll_CntPos < 10)
*		IF ll_Cnt = 0
*			lv_StrNum = SUBSTR(lv_numced,1, 2 )
*		ELSE
			ll_CntPos = 2 * ll_Cnt + 1
			lv_StrNum = SUBSTR(lv_numced, ll_CntPos - 1, ll_CntPos )
*		ENDIF	
		ll_multi = VAL(lv_StrNum) * 2
		IF (ll_multi >= 10)
			ll_multi = 1 + (ll_multi % 10)
		ENDIF	
		ll_sum = ll_sum + ll_multi
		ll_Cnt = ll_Cnt + 1
	ENDDO

	ll_Cnt = 1
	ll_CntPos = 1
	DO WHILE (ll_CntPos < 9 ) 
*		IF ll_Cnt = 1
*			lv_StrNum = SUBSTR(lv_numced,2, 2)
*		ELSE
			ll_CntPos = 2 * ll_Cnt
			lv_StrNum = SUBSTR(lv_numced,ll_CntPos - 1, ll_CntPos)
*		ENDIF	
		ll_sum = ll_sum + VAL(lv_StrNum)
		ll_Cnt = ll_Cnt + 1
	ENDDO
	

	ll_cociente = FLOOR(ll_sum / 10)
	ll_decena = (ll_cociente + 1) * 10
	ll_verificador = ll_decena - ll_sum

	IF (ll_verificador = 10)
		ll_verificador = 0
	ENDIF	

	IF (ll_verificador = ll_TenDig)
		RETURN ll_verificador &&.T.
	ELSE
		RETURN ll_verificador &&.F.
	ENDIF	
ELSE
	RETURN .F.
ENDIF	

