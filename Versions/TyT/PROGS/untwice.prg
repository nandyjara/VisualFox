#INCLUDE DOBRA.H
lcSQL	= 	"SELECT id, matr�culaid, tabladtid, count( id ) as cantidad " + ;
			"FROM EST_MATRICULAS_CONVENIOS GROUP BY ID, Matr�culaID, TablaDTID " + ;
			"HAVING ( count( id ) > 1 )"
SQLEXEC( _DOBRA.SQLServerID, lcSQL, "DUPLICADOS" )
BROW NORMAL
IF MESSAGEBOX( "Listo para eliminar duplicados ?...", MB_ICONQUESTION + MB_YESNO ) != IDYES
	RETURN
ENDIF
SCAN
	m.ID			= DUPLICADOS.ID
	m.Matr�culaID	= DUPLICADOS.Matr�culaID
	m.TablaDTID		= DUPLICADOS.TablaDTID
	m.Cantidad		= DUPLICADOS.Cantidad
	lcSQL	= 	"DELETE FROM EST_MATRICULAS_CONVENIOS WHERE " + ;
				"( ID = '" + m.ID + "' ) AND " + ;
				"( Matr�culaID = '" + m.Matr�culaID + "' ) AND " + ;
				"( TablaDTID = '" + m.TablaDTID + "' ) "
	SQLEXEC( _DOBRA.SQLServerID, lcSQL )
ENDSCAN
