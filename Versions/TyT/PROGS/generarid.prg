IF !USED("DVDETAIL")
	USE DVDETAIL IN 0
ENDIF

lnCont01 = 0
lnCont02 = 0
select DVDETAIL
scan all
	IF DVDETAIL.SucursalID = "00"
		lnCont01 = lnCont01 + 1
		lcID = DVDETAIL.sucursalid + tran(lncont01, "@L 99999999")
	ELSE
		lnCont02 = lnCont02 + 1
		lcID = DVDETAIL.sucursalid + tran(lncont02, "@L 99999999")
	ENDIF
	replace id with lcID
endscan
