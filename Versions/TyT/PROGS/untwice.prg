#INCLUDE DOBRA.H
lcSQL	= 	"SELECT id, matrículaid, tabladtid, count( id ) as cantidad " + ;
			"FROM EST_MATRICULAS_CONVENIOS GROUP BY ID, MatrículaID, TablaDTID " + ;
			"HAVING ( count( id ) > 1 )"
SQLEXEC( _DOBRA.SQLServerID, lcSQL, "DUPLICADOS" )
BROW NORMAL
IF MESSAGEBOX( "Listo para eliminar duplicados ?...", MB_ICONQUESTION + MB_YESNO ) != IDYES
	RETURN
ENDIF
SCAN
	m.ID			= DUPLICADOS.ID
	m.MatrículaID	= DUPLICADOS.MatrículaID
	m.TablaDTID		= DUPLICADOS.TablaDTID
	m.Cantidad		= DUPLICADOS.Cantidad
	lcSQL	= 	"DELETE FROM EST_MATRICULAS_CONVENIOS WHERE " + ;
				"( ID = '" + m.ID + "' ) AND " + ;
				"( MatrículaID = '" + m.MatrículaID + "' ) AND " + ;
				"( TablaDTID = '" + m.TablaDTID + "' ) "
	SQLEXEC( _DOBRA.SQLServerID, lcSQL )
ENDSCAN
